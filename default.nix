with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "autopatchelf";
  buildCommand = ''
    mkdir -p $out/bin
    cp ${./autopatchelf} $out/bin/autopatchelf
    sed -i \
      -e "s|file |${file}/bin/file |" \
      -e "s|getopt |${getopt}/bin/getopt |" $out/bin/autopatchelf
    chmod +x $out/bin/autopatchelf
    patchShebangs $out/bin
  '';
}
