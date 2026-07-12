cask "scribe" do
  version "0.17.0"
  sha256 "6994778ef1fc2492a2cf736bc011f5930ce8b684129709e3c4965d22b9b0e49e"

  url "https://github.com/pranjaltech/homebrew-tools/releases/download/scribe-v#{version}/Scribe-#{version}-aarch64.dmg"
  name "Scribe"
  desc "Video to Article Generator - AI-powered transcription and content creation"
  homepage "https://github.com/pranjaltech/scribe"

  # Runtime system libraries the bundled Python venv loads via
  # DYLD_FALLBACK_LIBRARY_PATH (see scribe/main.py:24–28).
  depends_on formula: "ffmpeg"
  depends_on formula: "cairo"
  depends_on formula: "pango"
  depends_on formula: "libffi"
  depends_on macos: :ventura
  depends_on arch: :arm64

  app "Scribe.app"

  # Quit the app before uninstalling
  uninstall quit: "com.scribe.app"

  # Clean uninstall: remove all app data
  zap trash: [
    "~/.scribe",
    "~/Library/Application Support/Scribe",
    "~/Library/Caches/com.scribe.app",
    "~/Library/Logs/Scribe",
    "~/Library/Preferences/com.scribe.app.plist",
  ]

  caveats <<~EOS
    On first launch Scribe bootstraps a private Python runtime at
    ~/.scribe/runtime/ via a bundled `uv` sidecar. The download takes
    ~60-120s and requires an internet connection; subsequent launches
    are instant.

    To wipe and re-bootstrap (e.g. after a corrupted install), use the
    menu-bar Scribe icon → Reset Scribe runtime…
  EOS
end
