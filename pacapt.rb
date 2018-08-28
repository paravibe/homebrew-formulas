class Pacapt < Formula
  desc "Package manager in the style of Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v2.3.15.tar.gz"
  sha256 "766f10320082c542fba2a5db1e0dab46e51dc45be07ade53c99a1ce3b1591245"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ad28a5d3416ac9be738ee60626a75f91c126a5b2d12f33a2e92a3d14542bcee" => :mojave
    sha256 "f56e9b1cb09ec56792706fe1364ebcd50e655d45ba7f6dd9d13969f11c1b7100" => :high_sierra
    sha256 "f56e9b1cb09ec56792706fe1364ebcd50e655d45ba7f6dd9d13969f11c1b7100" => :sierra
    sha256 "f56e9b1cb09ec56792706fe1364ebcd50e655d45ba7f6dd9d13969f11c1b7100" => :el_capitan
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
