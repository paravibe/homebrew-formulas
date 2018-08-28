class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.6.2/libqalculate-2.6.2.tar.gz"
  sha256 "bb52944426646a369a3b113d79f19bb92c7569bb3801f65f4fd416bed67e98d7"

  bottle do
    sha256 "300a9001eea1c18c38d455a20bf3ab263e9db65baa7568e697ca1280f67ccfb7" => :mojave
    sha256 "4c6df26327cf457539cc99114a427764e29f79f181a158f404c374f16a449300" => :high_sierra
    sha256 "5b89bef8bcdd68effb87ea4a502b5c5fe71a761b7dfdbbc271b75d8c8b9420e6" => :sierra
    sha256 "85e1909281f7f216ed9596f644f5faee604ab65612fb5cfa235d575232bda7c7" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gnuplot"
  depends_on "gettext"
  depends_on "mpfr"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-icu",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end
