class Flowwing < Formula
  desc "A fast, simple, and easy to use programming language"
  homepage "https://github.com/kushagra1212/Flow-Wing"
  version "v1.0.5"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kushagra1212/Flow-Wing/releases/download/v1.0.5/FlowWing-v1.0.5-macos-arm64.zip"
      sha256 "5e196de84093688622c35d014f223ed2d1aaa7e1d78e0e65e708a90cd9be1156"
    else
      odie "FlowWing: this tap only publishes an Apple Silicon (arm64) macOS SDK zip. Use Linux/Windows releases or build from source on Intel Macs."
    end
  end

  on_linux do
    url "https://github.com/kushagra1212/Flow-Wing/releases/download/v1.0.5/FlowWing-v1.0.5-linux-x86_64.deb"
    sha256 "7b7fefcf71c32e96da1350ac63fda2ca28b7c6abbf57f1f3a33cd555b8156ff7"
  end

  # Do not use  here: it is not defined on many Homebrew versions (e.g. macOS),
  # and the install path below only supports macOS arm64 and Linux anyway.

  license "GPL-2.0-only"

  def install
    if OS.mac? && Hardware::CPU.arm?
      # macOS ARM64 — install the whole staged bin/ (FlowWing AOT driver,
      # FlowWing-jit JIT driver, bundled clang / clang++ linker tools).
      #
      # Previous version hand-picked names via
      #   %w[clang++ llvm-config].select { |t| File.exist?("bin/\#{t}") }
      # which (a) omitted FlowWing-jit, (b) referenced llvm-config (not
      # shipped — see release.yml: intentionally excluded to keep installer
      # size sane), and (c) passed bare names like "clang++" to bin.install
      # which then looked for "./clang++" (not "./bin/clang++") and raised
      #   Errno::ENOENT: No such file or directory - clang++
      # on every install. Dir["bin/*"] stays in sync with whatever the SDK
      # zip actually ships.
      bin.install Dir["bin/*"]

      # Use single wildcard; Homebrew natively copies subdirectories recursively
      lib.install Dir["lib/*"]
    elsif OS.linux?
      # Linux - extract .deb and install files
      deb_file = cached_download
      system "dpkg", "-x", deb_file, "deb_extracted"
      
      bin.install Dir["deb_extracted/usr/local/flow-wing/#{version}/bin/*"] if Dir.exist?("deb_extracted/usr/local/flow-wing/#{version}/bin")
      
      # Apply the same fix here to prevent potential Linux install failures
      lib.install Dir["deb_extracted/usr/local/flow-wing/#{version}/lib/*"] if Dir.exist?("deb_extracted/usr/local/flow-wing/#{version}/lib")
    else
      skip "Unsupported platform for Homebrew formula"
    end
  end

  test do
    system "#{bin}/FlowWing", "--version"
    # Only the macOS SDK zip ships the JIT driver; Linux .deb bundles it too
    # but via a different Dir[...] path. Guard with File.exist? so the test
    # doesn't falsely fail on transitional SDK layouts.
    system "#{bin}/FlowWing-jit", "--version" if File.exist?("#{bin}/FlowWing-jit")
  end
end
