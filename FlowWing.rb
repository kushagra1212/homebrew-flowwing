class Flowwing < Formula
  desc "A fast, simple, and easy to use programming language"
  homepage "https://github.com/kushagra1212/Flow-Wing"
  version "$VERSION"

  on_macos do
    if Hardware::CPU.arm?
      url "$MACOS_URL"
      sha256 "$(curl -s "$MACOS_URL" | shasum -a 256 | cut -d' ' -f1)"
    else
      odie "FlowWing: this tap only publishes an Apple Silicon (arm64) macOS SDK zip. Use Linux/Windows releases or build from source on Intel Macs."
    end
  end

  on_linux do
    url "$(curl -s "https://api.github.com/repos/kushagra1212/Flow-Wing/releases/tags/$VERSION" | jq -r '.assets[] | select(.name | test("linux")) | .browser_download_url')"
    sha256 "$(curl -s "$(curl -s "https://api.github.com/repos/kushagra1212/Flow-Wing/releases/tags/$VERSION" | jq -r '.assets[] | select(.name | test("linux")) | .browser_download_url')" | shasum -a 256 | cut -d' ' -f1)"
  end

  on_windows do
    url "$(curl -s "https://api.github.com/repos/kushagra1212/Flow-Wing/releases/tags/$VERSION" | jq -r '.assets[] | select(.name | test("windows")) | .browser_download_url')"
    sha256 "$(curl -s "$(curl -s "https://api.github.com/repos/kushagra1212/Flow-Wing/releases/tags/$VERSION" | jq -r '.assets[] | select(.name | test("windows")) | .browser_download_url')" | shasum -a 256 | cut -d' ' -f1)"
  end

  license "GPL-2.0-only"

  def install
    if OS.mac? && Hardware::CPU.arm?
      # macOS ARM64
      lib_dir = "FlowWing-$VERSION-macos-arm64"
      mkdir_p lib_dir
      system "unzip", "-d", lib_dir, "#{share}/#{lib_dir}.zip"
      bin.install Dir["#{lib_dir}/bin/*"]
      # Install each top-level entry under SDK lib (modules/, platform libs, etc.).
      # Using **/* flattens into prefix/lib and breaks lib/modules layout.
      lib.install Dir["#{lib_dir}/lib/*"]
    elsif OS.linux?
      # Linux
      deb_file = "#{share}/FlowWing-$VERSION-linux-x86_64.deb"
      system "dpkg", "-x", deb_file, "deb_extracted"
      bin.install "deb_extracted/usr/local/flow-wing/$VERSION/bin/*"
      lib.install Dir["deb_extracted/usr/local/flow-wing/$VERSION/lib/*"]
    else
      skip "Unsupported platform for Homebrew formula"
    end
  end

  test do
    system "#{bin}/FlowWing", "--version"
  end
end
