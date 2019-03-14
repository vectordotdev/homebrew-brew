class Timber < Formula
  desc "Timber.io CLI - Live tail and search your logs"
  homepage "https://github.com/timberio/cli"
  url "https://packages.timber.io/cli/0.1.0/amd64/timber-0.1.0-darwin-amd64.tar.gz"
  sha256 "cdcea433106f10190146bb0a7ae651a51057a4a3fc0fd51b55110777080cd34e"
  
  def install
    bin.install "bin/timber"
  end

  test do
    system "false"
  end
end
