class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.44.3/e2fsprogs-1.44.3.tar.gz"
  sha256 "c2ae6d8ce6fb96b55886cf761411fc22ab41976f4f8297fc54c706df442483be"
  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

  bottle do
    sha256 "4dfcbf0c7e622b4cb1b2f8b79e2f472c57320752e1cb07eb558b3bd6b1630114" => :mojave
    sha256 "b7daa8ca1c002746acf36634291eaa5235333477799745b95fe33c5d4f780fc4" => :high_sierra
    sha256 "7adfb15de137e432cc89e4baf97778fb86a0ef3a5df8b9c7103990cfb5e51bb1" => :sierra
    sha256 "2c773cea28459ddd2a0387f45a089a5d0c40d7b10bf1c796c0f29c0df7c6800d" => :el_capitan
  end

  keg_only "this installs several executables which shadow macOS system commands"

  depends_on "pkg-config" => :build
  depends_on "gettext"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-e2initrd-helper"
    system "make"
    system "make", "install"
    system "make", "install-libs"
  end

  test do
    assert_equal 36, shell_output("#{bin}/uuidgen").strip.length
    system bin/"lsattr", "-al"
  end
end
