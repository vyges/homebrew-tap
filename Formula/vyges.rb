class Vyges < Formula
  desc "Vyges — one CLI for the Vyges hardware-IP toolchain"
  homepage "https://vyges.com"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/vyges-tools/cli/releases/download/v0.1.0/vyges-aarch64-apple-darwin.tar.xz"
    sha256 "76b0eedc3dc35916e49aeb2d60045f53e1e4cdc4a5bd2de438aa64b92f9c57f6"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vyges-tools/cli/releases/download/v0.1.0/vyges-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "094df7b0f31b894f3a79924c9f06b42b0a40b44e073a427eabd6300d027b2e6a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vyges-tools/cli/releases/download/v0.1.0/vyges-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5e57d423da1664321558b0114887944ce8ee5a2672058eac6b7e2dd8b0077aba"
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
