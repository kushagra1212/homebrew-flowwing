class Flowwing < Formula
  desc "A fast, simple, and easy to use programming language"
  homepage "https://github.com/kushagra1212/Flow-Wing"
  version "v0.0.3-alpha"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kushagra1212/Flow-Wing/releases/download/v0.0.3-alpha/FlowWing-v0.0.3-alpha-macos-arm64.zip"
      sha256 "0dc09583f685ebfb303458a88f1244f5dc2de38f16cd4496dfb56c84d6ba4ae0"
    else
      odie "FlowWing: this tap only publishes an Apple Silicon (arm64) macOS SDK zip. Use Linux/Windows releases or build from source on Intel Macs."
    end
  end

  on_linux do
    url "https://github.com/kushagra1212/Flow-Wing/releases/download/v0.0.3-alpha/FlowWing-v0.0.3-alpha-linux-x86_64.deb"
    sha256 "1fb2e4421a58f4719173cf5821777500636562d4a5199cc1dd72d697f2ba4791"
  end

  # Do not use  here: it is not defined on many Homebrew versions (e.g. macOS),
  # and the install path below only supports macOS arm64 and Linux anyway.

  license "GPL-2.0-only"

  def install
    if OS.mac? && Hardware::CPU.arm?
      # macOS ARM64 - flat structure matching actual zip contents
      bin.install "bin/FlowWing"
      
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
  end
end
