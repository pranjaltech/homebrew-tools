cask "scribe" do
  version "0.20.1"
  sha256 "572cce68149daa29a3b9b75b6a6ddd094cd05b621309e4123f6596b3007b3ed4"

  url "https://github.com/pranjaltech/homebrew-tools/releases/download/scribe-v#{version}/Scribe-#{version}-aarch64.dmg"
  name "Scribe"
  desc "Video to Article Generator - AI-powered transcription and content creation"
  homepage "https://github.com/pranjaltech/scribe"

  # Runtime system libraries the bundled Python venv loads via
  # DYLD_FALLBACK_LIBRARY_PATH (see scribe/main.py).
  depends_on formula: "ffmpeg"
  depends_on formula: "cairo"
  depends_on formula: "pango"
  depends_on formula: "libffi"
  depends_on macos: :ventura
  depends_on arch: :arm64

  app "Scribe.app"

  # Quit the app before uninstalling.
  uninstall quit: "com.scribe.app"

  # Clean uninstall. ~/.scribe holds the entire provisioned runtime — venv,
  # bundled Python interpreter, source, web dist, AND uv's cache (pinned under
  # ~/.scribe/cache/uv by the app so it is captured here rather than orphaned in
  # ~/.cache/uv). The remaining entries are bundle-id-keyed OS residue.
  zap trash: [
    "~/.scribe",
    "~/Library/Logs/Scribe",
    "~/Library/Caches/com.scribe.app",
    "~/Library/WebKit/com.scribe.app",
    "~/Library/HTTPStorages/com.scribe.app",
    "~/Library/Preferences/com.scribe.app.plist",
    "~/Library/Saved Application State/com.scribe.app.savedState",
    # Sandbox container for the bundled "Send to Scribe" Safari app-extension.
    "~/Library/Containers/com.scribe.app.Extension",
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
