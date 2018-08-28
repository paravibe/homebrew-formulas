class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://github.com/axiomatic-systems/Bento4/archive/v1.5.1-624.tar.gz"
  version "1.5.1-624"
  sha256 "eda725298e77df83e51793508a3a2640eabdfda1abc8aa841eca69983de83a4c"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "02e298856c60a2522c51548fb8d894d857b0f0ed0a9b0c510bfb45e4e7d80347" => :mojave
    sha256 "65e6be377382a21bee312e8cdbcbd9ccdf1faff54014c066d9feda9041da364d" => :high_sierra
    sha256 "fce3a39cf4350b096a0557694554e077d56d17f7ae8aaaffacf8d71469302db5" => :sierra
    sha256 "a9f65233b8bfd756e673a09ea18cb1847610170402bd9ac6a57107370ce9a3e5" => :el_capitan
  end

  depends_on :xcode => :build
  depends_on "python@2"

  conflicts_with "gpac", :because => "both install `mp42ts` binaries"
  conflicts_with "mp4v2",
    :because => "both install `mp4extract` and `mp4info` binaries"

  def install
    cd "Build/Targets/universal-apple-macosx" do
      xcodebuild "-target", "All", "-configuration", "Release", "SYMROOT=build"
      programs = Dir["build/Release/*"].select do |f|
        next if f.end_with? ".dylib"
        next if f.end_with? "Test"
        File.file?(f) && File.executable?(f)
      end
      bin.install programs
    end

    rm Dir["Source/Python/wrappers/*.bat"]
    inreplace Dir["Source/Python/wrappers/*"],
              "BASEDIR=$(dirname $0)", "BASEDIR=#{libexec}/Python/wrappers"
    libexec.install "Source/Python"
    bin.install_symlink Dir[libexec/"Python/wrappers/*"]
  end

  test do
    system "#{bin}/mp4mux", "--track", test_fixtures("test.m4a"), "out.mp4"
    assert_predicate testpath/"out.mp4", :exist?, "Failed to create out.mp4!"
  end
end
