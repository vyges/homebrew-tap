class Vyges < Formula
  desc "Vyges — one CLI for the Vyges hardware-IP toolchain"
  homepage "https://vyges.com"
  version "0.1.50"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/vyges-tools/cli/releases/download/v0.1.50/vyges-aarch64-apple-darwin.tar.xz"
    sha256 "8734310f650eeb8a1c4067a4e7ee366cb7a4d4cc6f5a4a988362d3ac3f1f3b7f"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vyges-tools/cli/releases/download/v0.1.50/vyges-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "40ef6ee6387c70e4fab2d765c9cb467c575933a3e8ad44874ccef3a3e9bf6174"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vyges-tools/cli/releases/download/v0.1.50/vyges-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2179534132a51d769ba36b395afd92255c5ace9775c946f2b20fc8b100ffdbdd"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "vyges", "vyges-catalog", "vyges-mcp", "vyges-metadata", "vyges-model", "vyges-pdk-store"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "vyges", "vyges-catalog", "vyges-mcp", "vyges-metadata", "vyges-model", "vyges-pdk-store"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "vyges", "vyges-catalog", "vyges-mcp", "vyges-metadata", "vyges-model", "vyges-pdk-store"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
