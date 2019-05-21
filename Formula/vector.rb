class Vector < Formula
  desc "A High-Performance Log and Metrics Routing Layer"
  homepage "https://github.com/timberio/cli"
  url "https://packages.timber.io/vector/vector-v0.2.0-dev.1-7-gbbf04c9-x86_64-unknown-linux-gnu.tar.gz"
  sha256 "d121823513109d9664ca816c5362268015c916fdd66a732101902c174c28e223"
  
  def install
    bin.install "vector"
  end

  test do
    system "false"
  end
end
