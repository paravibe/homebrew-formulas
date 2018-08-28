class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "https://libofx.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libofx/libofx/libofx-0.9.13.tar.gz"
  sha256 "57eaf97cddbaf82c24f26b8f5cf8b2fbfd4969c74500a2c9acc9082b83bcc0e4"

  bottle do
    sha256 "76ec57f4127bd219529ab60bff89e86e8779479424f69e2f485aba05cf4ca63c" => :high_sierra
    sha256 "6a59abeb58d3b9f5659fa0e6544540a50fb6521c7b149e4aa2f677d91d5093e8" => :sierra
    sha256 "c59e5f4445b49e59cc869aa9c01c0dbcb6d8cc5eb7822c3b1c2500f10fd4dacc" => :el_capitan
  end

  depends_on "open-sp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "ofxdump #{version}", shell_output("#{bin}/ofxdump -V").chomp
  end
end
