class Groonga < Formula
  desc "Fulltext search engine and column store"
  homepage "http://groonga.org/"
  url "https://packages.groonga.org/source/groonga/groonga-8.0.5.tar.gz"
  sha256 "763bdfd2ea1de57110815f5d912959cd31e4addf90e76e7fac332170f1f3fef0"

  bottle do
    sha256 "17be506e20179e3211f5c9d379601ed475625e30bf9b57064643b2ab0ac688a0" => :mojave
    sha256 "c90ce281c566184a1deafbf78d0b62694ddc9e33bd19e5488999a56b0f469b90" => :high_sierra
    sha256 "6702ed199953048e627754a14ee831912adaf4a7ba93db957bdcb120af59cebf" => :sierra
    sha256 "920ce31a60645f983cb15548d8dd8b0454a77a38b11f8744926a18d7e20d1e1b" => :el_capitan
  end

  head do
    url "https://github.com/groonga/groonga.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-glib", "With benchmark program for developer use"
  option "with-zeromq", "With suggest plugin for suggesting"
  option "with-stemmer", "Build with libstemmer support"

  deprecated_option "enable-benchmark" => "with-glib"
  deprecated_option "with-benchmark" => "with-glib"
  deprecated_option "with-suggest-plugin" => "with-zeromq"

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "msgpack"
  depends_on "openssl"
  depends_on "glib" => :optional
  depends_on "lz4" => :optional
  depends_on "mecab" => :optional
  depends_on "mecab-ipadic" if build.with? "mecab"
  depends_on "zeromq" => :optional
  depends_on "libevent" if build.with? "zeromq"
  depends_on "zstd" => :optional

  resource "groonga-normalizer-mysql" do
    url "https://packages.groonga.org/source/groonga-normalizer-mysql/groonga-normalizer-mysql-1.1.3.tar.gz"
    sha256 "e4534c725de244f5da72b2b05ddcbf1cfb4e56e71ac40f01acae817adf90d72c"
  end

  resource "stemmer" do
    url "https://github.com/snowballstem/snowball.git",
        :revision => "1964ce688cbeca505263c8f77e16ed923296ce7a"
  end

  link_overwrite "lib/groonga/plugins/normalizers/"
  link_overwrite "share/doc/groonga-normalizer-mysql/"
  link_overwrite "lib/pkgconfig/groonga-normalizer-mysql.pc"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-zlib
      --with-ssl
      --enable-mruby
    ]

    if build.with? "zeromq"
      args << "--enable-zeromq"
    else
      args << "--disable-zeromq"
    end

    if build.with? "stemmer"
      resource("stemmer").stage do
        system "make", "dist_libstemmer_c"
        system "tar", "xzf", "dist/libstemmer_c.tgz", "-C", buildpath
        Dir.chdir buildpath.join("libstemmer_c")
        system "make"
        mkdir "lib"
        mv "libstemmer.o", "lib/libstemmer.a"
        args << "--with-libstemmer=#{Dir.pwd}"
      end
    else
      args << "--without-libstemmer"
    end

    args << "--enable-benchmark" if build.with? "glib"
    args << "--with-mecab" if build.with? "mecab"
    args << "--with-lz4" if build.with? "lz4"
    args << "--with-zstd" if build.with? "zstd"

    if build.head?
      args << "--with-ruby"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make", "install"

    resource("groonga-normalizer-mysql").stage do
      ENV.prepend_path "PATH", bin
      ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    IO.popen("#{bin}/groonga -n #{testpath}/test.db", "r+") do |io|
      io.puts("table_create --name TestTable --flags TABLE_HASH_KEY --key_type ShortText")
      sleep 2
      io.puts("shutdown")
      # expected returned result is like this:
      # [[0,1447502555.38667,0.000824928283691406],true]\n
      assert_match(/\[\[0,\d+.\d+,\d+.\d+\],true\]/, io.read)
    end

    IO.popen("#{bin}/groonga -n #{testpath}/test-normalizer-mysql.db", "r+") do |io|
      io.puts "register normalizers/mysql"
      sleep 2
      io.puts("shutdown")
      # expected returned result is like this:
      # [[0,1447502555.38667,0.000824928283691406],true]\n
      assert_match(/\[\[0,\d+.\d+,\d+.\d+\],true\]/, io.read)
    end
  end
end
