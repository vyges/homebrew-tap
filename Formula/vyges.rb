class Vyges < Formula
  desc "Vyges — one CLI for the Vyges hardware-IP toolchain"
  homepage "https://vyges.com"
  version "0.1.20"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/vyges-tools/cli/releases/download/v0.1.20/vyges-aarch64-apple-darwin.tar.xz"
    sha256 "7ca57521ecc9c6dbbcf38a4e270dab677d757985f2328f061055e5e06fdc33c0"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vyges-tools/cli/releases/download/v0.1.20/vyges-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "06a9ea7cf140b6b1cdff7802b15a20487c24429d474be3535da00187e254168b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vyges-tools/cli/releases/download/v0.1.20/vyges-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "87d28dd11da166b494ab1387cf61e2727cff7c730eeb216ef99e68a652a4a0f3"
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
