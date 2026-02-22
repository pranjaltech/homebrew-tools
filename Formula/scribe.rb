class Scribe < Formula
  desc "Video to Article Generator - AI-powered transcription and article generation"
  homepage "https://github.com/pranjaltech/scribe"
  url "https://github.com/pranjaltech/homebrew-tools/releases/download/scribe-v0.7.0/scribe-0.7.0.tar.gz"
  sha256 "6de9e40383210a78d444b3d8b4682bec1784dcb996f0710c7acf63dd6425957f"
  license "MIT"
  head "https://github.com/pranjaltech/scribe.git", branch: "main"

  depends_on "python@3"
  depends_on "uv"
  depends_on "ffmpeg"
  depends_on "cairo"
  depends_on "pango"
  depends_on "libffi"
  depends_on :macos
  depends_on arch: :arm64

  # Ensure scribe-server symlink is created even when installed as a cask dependency
  link_overwrite "bin/scribe-server"

  # Prevent Homebrew from rewriting dylib IDs inside the Python venv.
  # The cryptography package ships a Rust-compiled .abi3.so whose Mach-O
  # header is too small for the longer absolute install path.
  skip_clean "libexec"

  def install
    python = Formula["python@3"].opt_bin/"python3"

    # Install only dependencies (not the project itself) — the wrapper
    # script runs the source tree directly.
    system "uv", "sync", "--frozen", "--no-dev",
           "--no-install-project",
           "--python", python,
           "--no-managed-python",
           "--directory", buildpath.to_s

    # Install everything into libexec (private prefix)
    libexec.install Dir["scribe"]
    libexec.install ".venv"
    libexec.install "pyproject.toml"
    libexec.install "uv.lock"
    # Frontend is pre-built in the release tarball
    (libexec/"web"/"dist").install Dir["web/dist/*"]

    # Create the scribe-server wrapper script.
    # Default to production port/env so the Tauri Mac app finds it via the
    # state file at ~/.scribe/scribe-production.state.  Override with
    # SCRIBE_ENV=dev or SCRIBE_PORT=8080 for manual dev use.
    (bin/"scribe-server").write <<~BASH
      #!/bin/bash
      export SCRIBE_PORT="${SCRIBE_PORT:-8090}"
      export SCRIBE_ENV="${SCRIBE_ENV:-production}"
      export DYLD_FALLBACK_LIBRARY_PATH="#{HOMEBREW_PREFIX}/lib:#{HOMEBREW_PREFIX}/opt/libffi/lib:#{HOMEBREW_PREFIX}/opt/cairo/lib:#{HOMEBREW_PREFIX}/opt/pango/lib"
      exec "#{libexec}/.venv/bin/python" "#{libexec}/scribe/main.py" "$@"
    BASH
  end

  def post_install
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
    assert_match "scribe.main",
      shell_output("#{libexec}/.venv/bin/python -c 'import scribe.main; print(scribe.main.__name__)'")
  end
end
