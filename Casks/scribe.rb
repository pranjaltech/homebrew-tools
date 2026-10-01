cask "scribe" do
  version "0.26.2"
  sha256 "528642c0914effa721b4d160c63fc81d87a0050cbf62aabc2a7edaa636802ed2"

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

  # Clean uninstall. Application Support holds settings, state files, X tokens
  # and the provisioned Python runtime; Caches holds the working folder
  # (downloaded videos while a job runs), uv's and yt-dlp's caches and WebKit's
  # HTTP cache. docs/storage.md lists every path the app writes.
  zap trash: [
    "~/Library/Application Support/com.scribe.app",
    "~/Library/Caches/com.scribe.app",
    "~/Library/Logs/Scribe",
    "~/Library/WebKit/com.scribe.app",
    "~/Library/HTTPStorages/com.scribe.app",
    "~/Library/Preferences/com.scribe.app.plist",
    "~/Library/Saved Application State/com.scribe.app.savedState",
    # Left by "Remove All Scribe Data…" when its after-exit delete is stopped (a logout).
    "~/Library/Caches/com.scribe.app.removing-*",
    "~/Library/WebKit/com.scribe.app.removing-*",
    "~/Library/HTTPStorages/com.scribe.app.removing-*",
    "~/Library/Preferences/com.scribe.app.plist.removing-*",
    "~/Library/Saved Application State/com.scribe.app.savedState.removing-*",
    "~/Library/Logs/Scribe.removing-*",
    # Sandbox container for the bundled "Send to Scribe" Safari app-extension.
    "~/Library/Containers/com.scribe.app.Extension",
    "~/Library/Application Scripts/com.scribe.app.Extension",
    # Where versions before 0.26.0 kept everything: the runtime and settings
    # in ~/.scribe, the working folder in $TMPDIR/Scribe. The app migrates
    # them on first launch; these catch an install that never got that far.
    # A working folder the user picked in Settings is theirs and is not removed.
    "~/.scribe",
    "/private/var/folders/*/*/T/Scribe",
    # Copies of browser cookies for yt-dlp; normally deleted after each
    # download, left behind only if the backend was killed mid-download.
    "/private/var/folders/*/*/T/scribe-cookies-*.txt",
    # WebKit and Metal scratch for the app's webview and its helper processes.
    "/private/var/folders/*/*/C/com.scribe.app",
    "/private/var/folders/*/*/T/com.scribe.app",
    "/private/var/folders/*/*/*/com.apple.WebKit.*+com.scribe.app",
  ]

  caveats <<~EOS
    On first launch Scribe sets up a private Python runtime in
    ~/Library/Application Support/com.scribe.app/runtime via a bundled `uv`
    sidecar. The download takes ~60-120s and requires an internet
    connection; subsequent launches are instant.

    To wipe and re-bootstrap (e.g. after a corrupted install), use the
    menu-bar Scribe icon → Reset Scribe runtime… To remove everything Scribe
    keeps on this Mac, use Remove All Scribe Data… there, or run
    `brew uninstall --zap scribe`.
  EOS
end
