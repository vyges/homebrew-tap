class Vyges < Formula
  desc "Vyges — one CLI for the Vyges hardware-IP toolchain"
  homepage "https://vyges.com"
  version "0.1.33"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/vyges-tools/cli/releases/download/v0.1.33/vyges-aarch64-apple-darwin.tar.xz"
    sha256 "f5091867d25b4d1fe7da72011515465a1df003a0c04880d9f4a926002d17a7ca"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vyges-tools/cli/releases/download/v0.1.33/vyges-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "67ec5d401dcfb1b0ff57ab815fb94304783aad4c62b3967ddae7e134fe36297b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vyges-tools/cli/releases/download/v0.1.33/vyges-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f44946376205b58cfedc9a5e1aa08af1d5e5e473366d3eb6bdf34cefbcbb2fdb"
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
