class Vyges < Formula
  desc "Vyges — one CLI for the Vyges hardware-IP toolchain"
  homepage "https://vyges.com"
  version "0.1.45"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/vyges-tools/cli/releases/download/v0.1.45/vyges-aarch64-apple-darwin.tar.xz"
    sha256 "de87b4eff9352d74c1d13b1aefce6e9a82f384c7a1078067418fc7208ecdb11c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vyges-tools/cli/releases/download/v0.1.45/vyges-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f6ed32c5c129eb9180963465243a1ac4e624b7ffcaeed15f25627c01a7c764b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vyges-tools/cli/releases/download/v0.1.45/vyges-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6747c40fcedceae3735014ef778caf38488691789c53d9686e93bae743901f76"
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
