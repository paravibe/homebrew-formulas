class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https://github.com/squizlabs/PHP_CodeSniffer/"
  url "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/2.9.1/phpcs.phar"
  sha256 "ad58ee2ce17dade0ceff3a5090386af63e55faf16beba15256e578064981f8f6"

  bottle :unneeded

  resource "phpcbf.phar" do
    url "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/2.9.1/phpcbf.phar"
    sha256 "a1bde49a936eb38de4b207aa73e3faa4fea82c6ca80ec9eb06b184712673b1ae"
  end

  def install
    bin.install "phpcs.phar" => "phpcs"
    resource("phpcbf.phar").stage { bin.install "phpcbf.phar" => "phpcbf" }
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php
      /**
      * PHP version 5
      *
      * @category  Homebrew
      * @package   Homebrew_Test
      * @author    Homebrew <do.not@email.me>
      * @license   BSD Licence
      * @link      https://brew.sh/
      */
    EOS

    assert_match /FOUND 13 ERRORS/, shell_output("#{bin}/phpcs --runtime-set ignore_errors_on_exit true test.php")
    assert_match /13 ERRORS WERE FIXED/, shell_output("#{bin}/phpcbf test.php", 1)
    system "#{bin}/phpcs", "test.php"
  end
end
