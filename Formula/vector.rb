class Vector < Formula
  desc "A High-Performance Log, Metrics, and Events Router"
  homepage "https://github.com/timberio/vector"
  url "https://packages.timber.io/vector/vector-v0.2.0-dev.1-7-gbbf04c9-x86_64-unknown-linux-gnu.tar.gz"
  sha256 "d121823513109d9664ca816c5362268015c916fdd66a732101902c174c28e223"
  
  def install
    bin.install "vector"

    # Set up Vector for local development
    inreplace "#{libexec}/config/vector.toml" do |s|
      s.gsub!(/data_dir: ".*"/, "data_dir: #{var}/lib/vector/")
    end

    # Move config files into etc
    (etc/"vector").install Dir[libexec/"config/*"]
    (libexec/"config").rmtree
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

  plist_options :manual => "vector"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <false/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/vector</string>
            <string>--config</string>
            <string>#{etc}/vector/vector.toml</string>
          </array>
          <key>EnvironmentVariables</key>
          <dict>
          </dict>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/vector.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/vector.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    output = shell_output("#{bin}/vector --version").chomp
    assert_equal "Vector v#{version}", output
  end
end
