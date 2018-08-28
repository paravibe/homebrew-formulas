class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.5.1/imlib2-1.5.1.tar.bz2"
  sha256 "fa4e57452b8843f4a70f70fd435c746ae2ace813250f8c65f977db5d7914baae"

  bottle do
    sha256 "bf73b51f136932cbf6403da131f9e509eb05b6c677a42c1edcc82e5003d3e40e" => :mojave
    sha256 "7edcb670d36ba9a1ff093c23f08a87162e7ff0969591a5666ba4e7c42b91a047" => :high_sierra
    sha256 "2e9f97ed9f360067b209b424ef476282a12be3bea11cc30ef10b9848d7a754f8" => :sierra
    sha256 "90bd1801b3f7c1ada18b6a2982770453893c3f71b2fa07621e6a5c051e1776a9" => :el_capitan
  end

  deprecated_option "without-x" => "without-x11"

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "giflib" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "libid3tag" => :optional
  depends_on :x11 => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-amd64=no
    ]
    args << "--without-x" if build.without? "x11"
    args << "--without-id3" if build.without? "libid3tag"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end
