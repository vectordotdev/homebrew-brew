class Vector < Formula
  desc "A High-Performance Log, Metrics, and Events Router"
  homepage "https://github.com/timberio/vector"
  version "0.44.0"

  on_macos do
    on_intel do
      url "https://packages.timber.io/vector/0.44.0/vector-0.44.0-x86_64-apple-darwin.tar.gz"
      sha256 "49d629155c8934a317dad0456fffc8779b164a8a312bd3f16ae51e08f19bbc1a" # x86_64-apple-darwin
    end

    on_arm do
      url "https://packages.timber.io/vector/0.44.0/vector-0.44.0-arm64-apple-darwin.tar.gz"
      sha256 "b05d9b8b624a99d6a0efdd904aed06485a3caf8ab85d4f7fc6636e8e0f2e126d" # arm64-apple-darwin
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
    system "false"
  end
end
