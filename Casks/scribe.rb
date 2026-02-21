cask "scribe" do
  version "0.6.0"
  sha256 "0eadd0f4a3699963e23591eff9bab6c2daba4e8306196d1897a02bd54e1354dd"

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
