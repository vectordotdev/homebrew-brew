class Timber < Formula
  desc "Timber.io CLI - Live tail and search your logs"
  homepage "https://github.com/timberio/cli"
  url "https://packages.timber.io/cli/0.0.1/amd64/timber-0.0.1-darwin-amd64.tar.gz"
  sha256 "ecc8474d006643d168c39dfb4030f31bd65d448433c990b8c8a8df0dcd3daea2"

  def install
    bin.install "bin/timber"
  end

  test do
    system "false"
  end
end
