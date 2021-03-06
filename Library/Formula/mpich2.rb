require 'formula'

# This should really be named Mpich now, but homebrew cannot currently handle
# formula renames, see homebrew issue #14374.
class Mpich2 < Formula
  homepage 'http://www.mpich.org/'
  url 'http://www.mpich.org/static/downloads/3.1.3/mpich-3.1.3.tar.gz'
  mirror 'http://fossies.org/linux/misc/mpich-3.1.3.tar.gz'
  sha1 'aa9907891ef4a4a584ab2f90a86775f29ca0dec0'

  bottle do
    sha1 "8542cf77b01f4b5ada4d7d1643729daf2fd23ebf" => :yosemite
    sha1 "662fa2b53e2504c7c9335e82c9ad69cecaa7c902" => :mavericks
    sha1 "a83acbfaaafc46da53d3be743037f197cbb34bfb" => :mountain_lion
  end

  head do
    url 'git://git.mpich.org/mpich.git'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'libtool'  => :build
  end

  devel do
    url 'http://www.mpich.org/static/downloads/3.2a2/mpich-3.2a2.tar.gz'
    sha1 '2bea3f7cb3d69d2ea372e48f376187e91b929bb6'
  end

  deprecated_option "disable-fortran" => "without-fortran"

  depends_on :fortran => :recommended

  conflicts_with 'open-mpi', :because => 'both install mpi__ compiler wrappers'

  def install
    if build.head?
      # ensure that the consistent set of autotools built by homebrew is used to
      # build MPICH, otherwise very bizarre build errors can occur
      ENV['MPICH_AUTOTOOLS_DIR'] = HOMEBREW_PREFIX+'bin'
      system "./autogen.sh"
    end

    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--mandir=#{man}"
    ]

    args << "--disable-fortran" if build.without? "fortran"

    system "./configure", *args
    system "make"
    system "make install"
  end

  test do
    # a better test would be to build and run a small MPI program
    system "#{bin}/mpicc", "-show"
  end
end
