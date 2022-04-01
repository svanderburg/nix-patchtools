with import <nixpkgs> { };

let
  autopatchelf = import ../default.nix;
in
stdenv.mkDerivation {
  name = "kzipmix-20150319";
  src = fetchurl {
    url = http://static.jonof.id.au/dl/kenutils/kzipmix-20150319-linux.tar.gz;
    sha256 = "0fv3zxhmwc3p34larp2d6rwmf4cxxwi71nif4qm96firawzzsf94";
  };
  buildInputs = [ autopatchelf ];
  libs = stdenv.lib.makeLibraryPath [ glibc ];
  installPhase = ''
    ${if stdenv.system == "i686-linux" then "cd i686"
    else if stdenv.system == "x86_64-linux" then "cd x86_64"
    else throw "Unsupported system architecture: ${stdenv.system}"}

    mkdir -p $out/bin
    cp zipmix kzip $out/bin
    autopatchelf $out/bin
  '';
}
