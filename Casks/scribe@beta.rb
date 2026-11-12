cask "scribe@beta" do
  version "0.33.0-rc.1"
  sha256 "333bb85e7122995765789fb8f2ee6350f7a50155c5a033a747047b5d9bbe9543"

  url "https://github.com/pranjaltech/homebrew-tools/releases/download/scribe-v#{version}/Scribe-#{version}-aarch64.dmg"
  name "Scribe Beta"
  desc "Turn videos, web pages and X posts into readable articles"
  homepage "https://github.com/pranjaltech/scribe"

  # Runtime system libraries the bundled Python venv loads via
  # DYLD_FALLBACK_LIBRARY_PATH (see scribe/main.py).
  depends_on formula: "ffmpeg"
  depends_on formula: "cairo"
  depends_on formula: "pango"
  depends_on formula: "libffi"
  depends_on macos: :sonoma
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
    The first launch, and the first launch after each update, sets Scribe
    up: about a minute or two, online.

    If Scribe ever won’t start, choose Help ▸ Troubleshooting ▸ Reinstall
    Scribe’s Helper… (also in the menu-bar icon’s Troubleshooting menu). To
    remove everything Scribe keeps on this Mac, choose Remove All Scribe
    Data… there, or run `brew uninstall --zap scribe`.
  EOS
end
