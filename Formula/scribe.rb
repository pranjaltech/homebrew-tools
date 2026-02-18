class Scribe < Formula
  desc "Video to Article Generator - AI-powered transcription and article generation"
  homepage "https://github.com/pranjaltech/scribe"
  url "https://github.com/pranjaltech/scribe/releases/download/v0.4.0/scribe-0.4.0.tar.gz"
  sha256 "9923b43f0ea1e53779dd8b591ef98db9ba6020c6b91236f94a1d6f29903f79f5"
  license "MIT"
  head "https://github.com/pranjaltech/scribe.git", branch: "main"

  depends_on "uv"
  depends_on "ffmpeg"
  depends_on "cairo"
  depends_on "pango"
  depends_on "libffi"
  depends_on "node" => :build
  depends_on :macos
  depends_on arch: :arm64

  def install
    # Build frontend assets
    cd "web" do
      system "npm", "ci", "--ignore-scripts"
      system "npm", "run", "build"
    end

    # Create virtualenv and install Python deps using uv
    system "uv", "sync", "--frozen", "--no-dev", "--directory", buildpath.to_s

    # Install everything into libexec (private prefix)
    libexec.install Dir["scribe"]
    libexec.install ".venv"
    libexec.install "pyproject.toml"
    libexec.install "uv.lock"
    (libexec/"web"/"dist").install Dir["web/dist/*"]

    # Create the scribe-server wrapper script
    (bin/"scribe-server").write <<~BASH
      #!/bin/bash
      export DYLD_FALLBACK_LIBRARY_PATH="#{HOMEBREW_PREFIX}/lib:#{HOMEBREW_PREFIX}/opt/libffi/lib:#{HOMEBREW_PREFIX}/opt/cairo/lib:#{HOMEBREW_PREFIX}/opt/pango/lib"
      exec "#{libexec}/.venv/bin/python" "#{libexec}/scribe/main.py" "$@"
    BASH
  end

  def post_install
    # Create data directories
    (var/"log/scribe").mkpath
    (var/"scribe/downloads").mkpath
  end

  def caveats
    <<~EOS
      Scribe backend has been installed.

      If you installed the Scribe desktop app, it manages the backend automatically.

      To run the backend manually:
        scribe-server

      Configuration:
        Set your OpenRouter API key via the Scribe app Settings page,
        or export it in your shell:
          export OPENROUTER_API_KEY=your_key_here

      Data directories:
        Downloads: #{var}/scribe/downloads
        Logs:      #{var}/log/scribe
    EOS
  end

  test do
    # Verify the server can start (will fail to bind if port is taken, but import works)
    assert_match "scribe.main",
      shell_output("#{libexec}/.venv/bin/python -c 'import scribe.main; print(scribe.main.__name__)'")
  end
end
