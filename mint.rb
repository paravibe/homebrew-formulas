class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.11.2.tar.gz"
  sha256 "9090af8dfb6b0334e961bcd373950bf1a33fc54fad064723afd4774df8871504"

  bottle do
    cellar :any_skip_relocation
    sha256 "6de176459dc60f0e7e9ccc8152243f4507b6f55ddd3bfdf44bb330df6066891d" => :mojave
    sha256 "aef9ebf4d33822af63de9f640914abb04ba5624ef209f664681a87b5b122ec7f" => :high_sierra
    sha256 "84fbf229c3562f68a413630ab112bf8859f3cd171ccf78e3e4aaa1429141eab6" => :sierra
  end

  depends_on :xcode => ["9.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Test by showing the help scree
    system "#{bin}/mint", "--help"
    # Test showing list of installed tools
    system "#{bin}/mint", "list"
  end
end
