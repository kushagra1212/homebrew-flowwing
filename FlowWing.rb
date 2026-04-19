class Flowwing < Formula
  desc "A fast, simple, and easy to use programming language"
  homepage "https://github.com/kushagra1212/Flow-Wing"
  version "v0.0.3-alpha"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kushagra1212/Flow-Wing/releases/download/v0.0.3-alpha/FlowWing-v0.0.3-alpha-macos-arm64.zip"
      sha256 "c82e149f6bdde6b1d7151428fdaa1a58e8a24346b2636f0d3774f359084283f1"

    else
      odie "FlowWing: this tap only publishes an Apple Silicon (arm64) macOS SDK zip. Use Linux/Windows releases or build from source on Intel Macs."
    end
  end

  on_linux do
    url "https://github.com/kushagra1212/Flow-Wing/releases/download/v0.0.3-alpha/FlowWing-v0.0.3-alpha-linux-x86_64.deb"
    sha256 "0cbc4dfab7cce3adf012042c40ec4469080740f3752daf1b76039d3ab39b2ab3"
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
      bin.install Dir["#{root}/bin/*"]
      # Install each top-level entry under SDK lib (modules/, platform libs, etc.).
      # Using **/* flattens into prefix/lib and breaks lib/modules layout.
      lib.install Dir["#{root}/lib/*"]
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
