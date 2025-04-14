class Vector < Formula
  desc "A High-Performance Log, Metrics, and Events Router"
  homepage "https://github.com/timberio/vector"
  version "0.46.1"

  on_macos do
    on_intel do
      url "https://packages.timber.io/vector/0.46.1/vector-0.46.1-x86_64-apple-darwin.tar.gz" # x86_64 url
      sha256 "6d8ba3fb2e0a71911549b27ee62f4ecb34a0e1314d15e1147f546e3b3a5f72be" # x86_64 sha256
    end

    on_arm do
      url "https://packages.timber.io/vector/0.46.1/vector-0.46.1-arm64-apple-darwin.tar.gz" # arm64 url
      sha256 "9a198d7a50029e7ef0d850bf2f0970a0cf54f1e8de5b9c0070bc1f56188a0ce6" # arm64 sha256
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