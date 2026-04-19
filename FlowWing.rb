class Flowwing < Formula
  desc "A fast, simple, and easy to use programming language"
  homepage "https://github.com/kushagra1212/Flow-Wing"
  version "v0.0.3-alpha"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kushagra1212/Flow-Wing/releases/download/v0.0.3-alpha/FlowWing-v0.0.3-alpha-macos-arm64.zip"
      sha256 "f2fd9691d4702895bc2946cb468dcd47957ed9b365ba57e71722f7d9361616bf"
    else
      odie "FlowWing: this tap only publishes an Apple Silicon (arm64) macOS SDK zip. Use Linux/Windows releases or build from source on Intel Macs."
    end
  end

  on_linux do
    url "https://github.com/kushagra1212/Flow-Wing/releases/download/v0.0.3-alpha/FlowWing-v0.0.3-alpha-linux-x86_64.deb"
    sha256 "65743215d20e569e8ac976d24b5dd066108d279b7324c76ff83466edc1c1fdc8"
  end

  # Do not use  here: it is not defined on many Homebrew versions (e.g. macOS),
  # and the install path below only supports macOS arm64 and Linux anyway.

  license "GPL-2.0-only"

  def install
    if OS.mac? && Hardware::CPU.arm?
      # macOS ARM64 - flat structure matching actual zip contents
      bin.install "bin/FlowWing"
      
      # Install all library files recursively, preserving directory structure
      lib.install Dir["lib/**/*"]
    elsif OS.linux?
      # Linux
      deb_file = cached_download
      system "dpkg", "-x", deb_file, "deb_extracted"
      bin.install "deb_extracted/usr/local/flow-wing/#{version}/bin/*"
      lib.install Dir["deb_extracted/usr/local/flow-wing/#{version}/lib/**/*"]
    else
      skip "Unsupported platform for Homebrew formula"
    end
  end

  test do
    system "#{bin}/FlowWing", "--version"
  end
end
