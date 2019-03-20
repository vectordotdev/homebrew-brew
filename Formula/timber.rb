class Timber < Formula
  desc "Timber.io CLI - Live tail and search your logs"
  homepage "https://github.com/timberio/cli"
  url "https://packages.timber.io/cli/0.2.0/amd64/timber-0.2.0-darwin-amd64.tar.gz"
  sha256 "24f3258cf2978f6120240cea3049dd34bbbdc45b1664f4ed44d1f5379e9e8ed5"
  
  def install
    bin.install "bin/timber"
  end

  test do
    system "false"
  end
end
