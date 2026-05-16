cask "scribe" do
  version "0.8.1"
  sha256 "6102acc33974ecdbf43a692091e8edc0061d8c8cef0d0613f822fb54bfb1f0c9"

  url "https://github.com/pranjaltech/homebrew-tools/releases/download/scribe-v#{version}/Scribe-#{version}-aarch64.dmg"
  name "Scribe"
  desc "Video to Article Generator - AI-powered transcription and content creation"
  homepage "https://github.com/pranjaltech/scribe"

  # Auto-install the backend formula when installing the cask
  depends_on formula: "pranjaltech/tools/scribe"
  depends_on macos: ">= :ventura"
  depends_on arch: :arm64

  app "Scribe.app"

  # Quit the app before uninstalling
  uninstall quit: "com.scribe.app"

  # Clean uninstall: remove all app data
  zap trash: [
    "~/Library/Application Support/Scribe",
    "~/Library/Preferences/com.scribe.app.plist",
    "~/Library/Caches/com.scribe.app",
    "~/Library/Logs/Scribe",
    "~/.scribe",
  ]
end
