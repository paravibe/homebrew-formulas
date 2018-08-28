class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.5.0.tar.gz"
  sha256 "f2b5cb971b368085e9c4f607d906e0622aa94d65c0f7c820d9cbdf23fb972c33"
  revision 2

  bottle do
    rebuild 1
    sha256 "0c4ce6dfda9ab46076fb9c4ad8e0f934559e2ac7ba87579f900ced4d6977a0cb" => :mojave
    sha256 "f57ef8c0e048007c3d387fd21ad982b6ada957e24b77effa4aea18fe197d59f3" => :high_sierra
    sha256 "cd5fd88fd935f1481a562e62058c6c8570f56894b757eca01c2dc3d6d171b88e" => :sierra
    sha256 "bb812144655843a6e3a772467ea7178a9e78ce3352feda83a0107615019eda1f" => :el_capitan
  end

  depends_on "crystal"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
