class Gnuradio < Formula
  desc "SDK providing the signal processing runtime and processing blocks"
  homepage "https://gnuradio.org/"
  url "https://gnuradio.org/releases/gnuradio/gnuradio-3.7.13.4.tar.gz"
  sha256 "c536c268b1e9c24f1206bbc881a5819ac46e662f4e8beaded6f3f441d3502f0d"
  head "https://github.com/gnuradio/gnuradio.git"

  bottle do
    sha256 "776bf89ad97f91a5dfde51675515b59dc40715130a09039c713a291bc11e4708" => :mojave
    sha256 "bd03698a2b1a89f865eceb8d22eb335ec0b80cc5afb6a03c4c96f71560390e6c" => :high_sierra
    sha256 "8967e3a4fb54a2f0a191d42fefa74066ffc3384290792c325b5d6ce72e1819d5" => :sierra
    sha256 "dc19d373b871c7cf3325e5ff041a5a46aa3fe75cee2c8efa36b33b70bb492b73" => :el_capitan
  end

  option "without-python@2", "Build without python support"

  deprecated_option "without-python" => "without-python@2"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :recommended
  depends_on "boost"
  depends_on "fftw"
  depends_on "gsl"
  depends_on "zeromq"

  if build.with? "python@2"
    depends_on "swig" => :build
    depends_on "numpy"
  end

  # For documentation
  depends_on "doxygen" => [:build, :optional]
  depends_on "sphinx-doc" => [:build, :optional]

  depends_on "uhd" => :recommended
  depends_on "sdl" => :optional
  depends_on "jack" => :optional
  depends_on "portaudio" => :recommended
  depends_on "pygtk" => :optional
  depends_on "wxpython" => :optional

  # cheetah starts here
  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/b3/73/fc5c850f44af5889192dff783b7b0d8f3fe8d30b65c8e3f78f8f0265fecf/Markdown-2.6.11.tar.gz"
    sha256 "a856869c7ff079ad84a3e19cd87a64998350c2b94e9e08e44270faef33400f81"
  end

  resource "Cheetah" do
    url "https://files.pythonhosted.org/packages/cd/b0/c2d700252fc251e91c08639ff41a8a5203b627f4e0a2ae18a6b662ab32ea/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end
  # cheetah ends here

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/54/a6/43be8cf1cc23e3fa208cab04ba2f9c3b7af0233aab32af6b5089122b44cd/lxml-4.2.3.tar.gz"
    sha256 "622f7e40faef13d232fb52003661f2764ce6cdef3edb0a59af7c1559e4cc36d1"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/eb/f3/67579bb486517c0d49547f9697e36582cd19dafb5df9e687ed8e22de57fa/Mako-1.0.7.tar.gz"
    sha256 "4e02fde57bd4abb5ec400181e4c314f56ac3e49ba4fb8b0d50bba18cb27d25ae"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "cppzmq" do
    url "https://raw.githubusercontent.com/zeromq/cppzmq/46fc0572c5e9f09a32a23d6f22fd79b841f77e00/zmq.hpp"
    sha256 "964031c0944f913933f55ad1610938105a6657a69d1ac5a6dd50e16a679104d5"
  end

  def install
    ENV.prepend_path "PATH", "/System/Library/Frameworks/Python.framework/Versions/2.7/bin"

    ENV["CHEETAH_INSTALL_WITHOUT_SETUPTOOLS"] = "1"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    %w[Markdown Cheetah MarkupSafe Mako six].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    begin
      # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
      ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

      resource("lxml").stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    ensure
      ENV.delete("SDKROOT")
    end

    resource("cppzmq").stage include.to_s

    args = std_cmake_args
    args << "-DGR_PKG_CONF_DIR=#{etc}/gnuradio/conf.d"
    args << "-DGR_PREFSDIR=#{etc}/gnuradio/conf.d"

    args << "-DENABLE_DEFAULT=OFF"
    enabled_components = %w[gr-analog gr-fft volk gr-filter gnuradio-runtime
                            gr-blocks gr-pager gr-noaa gr-channels gr-audio
                            gr-fcd gr-vocoder gr-fec gr-digital gr-dtv gr-atsc
                            gr-trellis gr-zeromq]
    if build.with? "python@2"
      enabled_components << "python"
      enabled_components << "gr-utils"
      enabled_components << "grc" if build.with? "pygtk"
      enabled_components << "gr-wxgui" if build.with? "wxpython"
    end
    enabled_components << "gr-wavelet"
    enabled_components << "gr-video-sdl" if build.with? "sdl"
    enabled_components << "gr-uhd" if build.with? "uhd"
    enabled_components << "doxygen" if build.with? "doxygen"
    enabled_components << "sphinx" if build.with? "sphinx"

    enabled_components.each do |c|
      args << "-DENABLE_#{c.upcase.split("-").join("_")}=ON"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    rm bin.children.reject(&:executable?)
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnuradio-config-info -v")

    (testpath/"test.c++").write <<~EOS
      #include <gnuradio/top_block.h>
      #include <gnuradio/blocks/null_source.h>
      #include <gnuradio/blocks/null_sink.h>
      #include <gnuradio/blocks/head.h>
      #include <gnuradio/gr_complex.h>

      class top_block : public gr::top_block {
      public:
        top_block();
      private:
        gr::blocks::null_source::sptr null_source;
        gr::blocks::null_sink::sptr null_sink;
        gr::blocks::head::sptr head;
      };

      top_block::top_block() : gr::top_block("Top block") {
        long s = sizeof(gr_complex);
        null_source = gr::blocks::null_source::make(s);
        null_sink = gr::blocks::null_sink::make(s);
        head = gr::blocks::head::make(s, 1024);
        connect(null_source, 0, head, 0);
        connect(head, 0, null_sink, 0);
      }

      int main(int argc, char **argv) {
        top_block top;
        top.run();
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-L#{Formula["boost"].opt_lib}",
           "-lgnuradio-blocks", "-lgnuradio-runtime", "-lgnuradio-pmt",
           "-lboost_system", testpath/"test.c++", "-o", testpath/"test"
    system "./test"

    if build.with? "python@2"
      (testpath/"test.py").write <<~EOS
        from gnuradio import blocks
        from gnuradio import gr

        class top_block(gr.top_block):
            def __init__(self):
                gr.top_block.__init__(self, "Top Block")
                self.samp_rate = 32000
                s = gr.sizeof_gr_complex
                self.blocks_null_source_0 = blocks.null_source(s)
                self.blocks_null_sink_0 = blocks.null_sink(s)
                self.blocks_head_0 = blocks.head(s, 1024)
                self.connect((self.blocks_head_0, 0),
                             (self.blocks_null_sink_0, 0))
                self.connect((self.blocks_null_source_0, 0),
                             (self.blocks_head_0, 0))

        def main(top_block_cls=top_block, options=None):
            tb = top_block_cls()
            tb.start()
            tb.wait()

        main()
      EOS
      system "python2.7", testpath/"test.py"

      cd testpath do
        system "#{bin}/gr_modtool", "newmod", "test"

        cd "gr-test" do
          system "#{bin}/gr_modtool", "add", "-t", "general", "test_ff", "-l",
                 "python", "-y", "--argument-list=''", "--add-python-qa",
                 "--copyright=brew"
        end
      end
    end
  end
end
