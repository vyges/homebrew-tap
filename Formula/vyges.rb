class Vyges < Formula
  desc "Vyges — one CLI for the Vyges hardware-IP toolchain"
  homepage "https://vyges.com"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/vyges-tools/cli/releases/download/v0.1.1/vyges-aarch64-apple-darwin.tar.xz"
    sha256 "f132aeff7a569e668b857803bd240cfb167ea1a88014bbc0304b64df4510235b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vyges-tools/cli/releases/download/v0.1.1/vyges-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cb4cfe7c869a011c6ddfba4b99589e77d36902e1cd525e5e7e198c0ed62eca78"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vyges-tools/cli/releases/download/v0.1.1/vyges-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8405b3834a8fd8f5cabe96216dcf5670d67fc6d652197ebe23c901ba67d913b3"
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
