class IceHead < Formula
  desc "A comprehensive RPC framework with support for C++, .NET, Java, Python, JavaScript and more"
  homepage "https://zeroc.com"
  head "https://github.com/zeroc-ice/ice.git"

  option "with-java", "Build Ice for Java and the IceGrid Admin app"

  depends_on "berkeley-db53"
  depends_on "lmdb"
  depends_on "mcpp"
  depends_on :java => ["1.7+", :optional]
  depends_on :macos => :mavericks

  def install
     inreplace "cpp/src/slice2js/Makefile", /install:/, "dontinstall:"

    # Unset ICE_HOME as it interferes with the build
    ENV.delete("ICE_HOME")
    ENV.delete("USE_BIN_DIST")
    ENV.delete("CPPFLAGS")
    ENV.O2

    args = %W[
      prefix=#{prefix}
      embedded_runpath_prefix=#{prefix}
      USR_DIR_INSTALL=yes
      OPTIMIZE=yes
      MCPP_HOME=#{Formula["mcpp"].opt_prefix}
      DB_HOME=#{Formula["berkeley-db53"].opt_prefix}
    ]

    system "cp", "-r", "cpp", "cpp11"
    cd "cpp11" do
      system "make", "install", "CPP11_MAPPING=yes", *args
    end

    cd "cpp" do
      system "make", "install", *args
    end

    cd "objective-c" do
      system "make", "install", *args
    end

    if build.with? "java"
      cd "java" do
        system "make", "install", *args
      end
    end

    cd "php" do
      args << "install_phpdir=#{share}/php"
      args << "install_libdir=#{lib}/php/extensions"
      system "make", "install", *args
    end
  end
end
