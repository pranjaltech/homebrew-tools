cask "scribe" do
  version "0.7.0"
  sha256 "467b1c7dc2f76453ea1090e10113db30c1e991ff3a916e1d34791abf9a9cefe4"

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
