class Vector < Formula
  desc "A High-Performance Log, Metrics, and Events Router"
  homepage "https://github.com/timberio/vector"
  version "0.45.0"

  on_macos do
    on_intel do
      url "https://packages.timber.io/vector/0.45.0/vector-0.45.0-x86_64-apple-darwin.tar.gz" # x86_64 url
      sha256 "cfd5f9cb8bcb8a73a87a3e8c404e887ec5a876a8adc6a4e46ca849b3db151d19" # x86_64 sha256
    end

    on_arm do
      url "https://packages.timber.io/vector/0.45.0/vector-0.45.0-arm64-apple-darwin.tar.gz" # arm64 url
      sha256 "5dd47b634497db9e358f1122918b492ef9e0cfe1d0f144d66a52118571145644" # arm64 sha256
    end
  end

  head "https://github.com/timberio/vector.git"

  def install
    bin.install "bin/vector"

    # Set up Vector for local development
    inreplace "config/vector.yaml" do |s|
      s.gsub!(/data_dir: ".*"/, "data_dir: \"#{var}/lib/vector/\"")
    end

    # Move config files into etc
    (etc/"vector").install Dir["config/*"]

    begin
      FileUtils.rm_rf("config")
    rescue
      # Swallow errors if this causes any
    end
  end

  def post_install
    # Make sure runtime directories exist
    (var/"lib/vector").mkpath
    (var/"log/vector").mkpath
  end

  def caveats
    s = <<~EOS
      Data:    #{var}/lib/vector/
      Logs:    #{var}/log/vector/vector.log
      Config:  #{etc}/vector/
    EOS

    s
  end

  service do
    run [opt_bin/"vector", "--config", etc/"vector/vector.yaml"]
    keep_alive false
    working_dir var
    error_log_path var/"log/vector.log"
    environment_variables {}
  end

  test do
    output = shell_output("#{bin}/vector --version").chomp
    assert output.start_with?("vector ")
  end
end