class Flowwing < Formula
  desc "A fast, simple, and easy to use programming language"
  homepage "https://github.com/kushagra1212/Flow-Wing"
  version "v0.0.3-alpha"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kushagra1212/Flow-Wing/releases/download/v0.0.3-alpha/FlowWing-v0.0.3-alpha-macos-arm64.zip"
      sha256 "c694dcbb4ca162ded84cf90037744b3092379648e744a0e62437dd1bf68ec4cf"
    else
      odie "FlowWing: this tap only publishes an Apple Silicon (arm64) macOS SDK zip. Use Linux/Windows releases or build from source on Intel Macs."
    end
  end

  on_linux do
    url "https://github.com/kushagra1212/Flow-Wing/releases/download/v0.0.3-alpha/FlowWing-v0.0.3-alpha-linux-x86_64.deb"
    sha256 "72d0ca92af683713cb1c288ffaed99cb2abdbe8c764f5834e431cbe30bd058b8"
  end

  # Do not use  here: it is not defined on many Homebrew versions (e.g. macOS),
  # and the install path below only supports macOS arm64 and Linux anyway.

  license "GPL-2.0-only"


  def install
    if OS.mac? && Hardware::CPU.arm?
      # macOS ARM64 - flat structure matching actual zip contents
      bin.install "bin/FlowWing"
      
      # Install Darwin-arm64 libraries explicitly
      lib.mkpath("Darwin-arm64")
      Dir["lib/Darwin-arm64/*.a"].each do |f|
        cp f, "Darwin-arm64/#{File.basename(f)}"
      end
      
      # Install modules directory recursively
      lib.install Dir["lib/modules/**/*"]
    elsif OS.linux?
      # Linux - extract .deb and install files
      deb_file = cached_download
      system "dpkg", "-x", deb_file, "deb_extracted"
      
      bin.install "deb_extracted/usr/local/flow-wing/#{version}/bin/*" if Dir.exist?("deb_extracted/usr/local/flow-wing/#{version}/bin")
      
      lib.mkpath("Darwin-arm64") if Dir.exist?("deb_extracted/usr/local/flow-wing/#{version}/lib/Darwin-arm64")
      Dir["deb_extracted/usr/local/flow-wing/#{version}/lib/Darwin-arm64/*.a"].each do |f|
        cp f, "Darwin-arm64/#{File.basename(f)}" if File.exist?(f)
      end
      
      lib.install Dir["deb_extracted/usr/local/flow-wing/#{version}/modules/**/*"] if Dir.exist?("deb_extracted/usr/local/flow-wing/#{version}/lib/modules")
    else
      skip "Unsupported platform for Homebrew formula"
    end
  end

  test do
    system "#{bin}/FlowWing", "--version"
  end
end
