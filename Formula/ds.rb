class Ds < Formula
  desc "Convert defaults or any plist into Shell Scripts"
  homepage "https://github.com/aerobounce/defaults.sh"
  url "https://github.com/aerobounce/defaults.sh/archive/2021.04.09.zip"
  sha256 "89d187075934876732a7a2f24057b24c59d92b8b5c5178b6d26da667853d6d43"
  head "https://github.com/aerobounce/defaults.sh.git"

  bottle :unneeded

  def install
    bin.install "ds"
  end
end
