with import <nixpkgs> {};

let
  autopatchelf = import ../default.nix;
in
stdenv.mkDerivation {
  name = "cpio";
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/c/cpio/cpio_2.11+dfsg-0.1+deb7u2_amd64.deb;
    sha256 = "1zakzlxg6fygqhizkw65qjsiv1n2swaxffgghbh447qyxc286mzw";
  };
  buildInputs = [ dpkg autopatchelf ];
  libs = stdenv.lib.makeLibraryPath [ stdenv.glibc ];
  unpackPhase = ''
    mkdir cpio
    cd cpio
    dpkg -x "$src" .
  '';
  installPhase = ''
    mkdir -p $out
    mv * $out
    autopatchelf $out
  '';
  dontStrip = true;
}
