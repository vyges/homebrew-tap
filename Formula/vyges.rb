class Vyges < Formula
  desc "Vyges — one CLI for the Vyges hardware-IP toolchain"
  homepage "https://vyges.com"
  version "0.1.14"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/vyges-tools/cli/releases/download/v0.1.14/vyges-aarch64-apple-darwin.tar.xz"
    sha256 "9cea24136778dbf84cb7aaaef6c0a58aa351182354f9164107e3414429f75a28"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vyges-tools/cli/releases/download/v0.1.14/vyges-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0d7ef16262f0d8a595d4122605c6f315297b699fc5d340e9dfc069ecc1af80f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vyges-tools/cli/releases/download/v0.1.14/vyges-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0251e4350557ffd687691d077e56afee8a05da33d3d72a93178c17dc5d9ea297"
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
