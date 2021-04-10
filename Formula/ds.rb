class Ds < Formula
  desc "Convert defaults or any plist into Shell Scripts"
  homepage "https://github.com/aerobounce/defaults.sh"
  url "https://github.com/aerobounce/defaults.sh/archive/2021.04.10.zip"
  sha256 "7f58aee4e8162095489cc752ad23c3e78c101522738fd7dfc50df047a0b1c08a"
  head "https://github.com/aerobounce/defaults.sh.git"

  bottle :unneeded

  def install
    bin.install "ds"
  end
end
