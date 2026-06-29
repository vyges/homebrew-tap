class Vyges < Formula
  desc "Vyges — one CLI for the Vyges hardware-IP toolchain"
  homepage "https://vyges.com"
  version "0.1.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/vyges-tools/cli/releases/download/v0.1.2/vyges-aarch64-apple-darwin.tar.xz"
    sha256 "a7e242a7574f960f8ab1dfa5c0c1928db7435752cee047933a09a634e691043e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vyges-tools/cli/releases/download/v0.1.2/vyges-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bd5d3d56b724ebf9e2511841676bb6d03dd305f6f7ea384a100b726307c21e46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vyges-tools/cli/releases/download/v0.1.2/vyges-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a23a0b5db52ecd9a94d81e6a3f8f9973ee171b5e6cad89f22b55c9f1bff53c76"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "vyges", "vyges-catalog", "vyges-metadata", "vyges-pdk-store" if OS.mac? && Hardware::CPU.arm?
    bin.install "vyges", "vyges-catalog", "vyges-metadata", "vyges-pdk-store" if OS.linux? && Hardware::CPU.arm?
    bin.install "vyges", "vyges-catalog", "vyges-metadata", "vyges-pdk-store" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
