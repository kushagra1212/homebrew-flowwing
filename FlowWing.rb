class Flowwing < Formula
  desc "A fast, simple, and easy to use programming language"
  homepage "https://github.com/kushagra1212/Flow-Wing"
  version "v0.0.3-alpha"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kushagra1212/Flow-Wing/releases/download/v0.0.3-alpha/FlowWing-v0.0.3-alpha-macos-arm64.zip"
      sha256 "97189ecaed426aea7fa1d2dcd1735b0e6d54f1c9283e044836d19f674432c66e"
    else
      odie "FlowWing: this tap only publishes an Apple Silicon (arm64) macOS SDK zip. Use Linux/Windows releases or build from source on Intel Macs."
    end
  end

  on_linux do
    url "https://github.com/kushagra1212/Flow-Wing/releases/download/v0.0.3-alpha/FlowWing-v0.0.3-alpha-linux-x86_64.deb"
    sha256 "ef41ddec79c1dafa83e2940d54c1c7cf99748a3a04f31f7c10018d49a85b2d2d"
  end

  # Do not use  here: it is not defined on many Homebrew versions (e.g. macOS),
  # and the install path below only supports macOS arm64 and Linux anyway.

  license "GPL-2.0-only"

  def install
    if OS.mac? && Hardware::CPU.arm?
      # macOS ARM64
      #
      # Homebrew stages/extracts archives into the build directory automatically. The release zip
      # contains a top-level directory named .
      root = "FlowWing-#{version}-macos-arm64"
      lib.install Dir["lib/**/*"]
      bin.install "bin/FlowWing"
    elsif OS.linux?
      # Linux
      #  is not extracted by Homebrew; use the downloaded file directly.
      deb_file = cached_download
      system "dpkg", "-x", deb_file, "deb_extracted"
      bin.install "deb_extracted/usr/local/flow-wing/#{version}/bin/*"
      lib.install Dir["deb_extracted/usr/local/flow-wing/#{version}/lib/*"]
    else
      skip "Unsupported platform for Homebrew formula"
    end
  end

  test do
    system "#{bin}/FlowWing", "--version"
  end
end
