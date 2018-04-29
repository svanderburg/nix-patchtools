with import <nixpkgs> { system = "i686-linux"; };

let
  autopatchelf = import ../default.nix;
in
stdenv.mkDerivation {
  name = "quake4-demo-1.0";
  src = fetchurl {
    url = ftp://ftp.idsoftware.com/idstuff/quake4/demo/quake4-linux-1.0-demo.x86.run;
    sha256 = "0wxw2iw84x92qxjbl2kp5rn52p6k8kr67p4qrimlkl9dna69xrk9";
  };
  buildInputs = [ autopatchelf ];
  libs = stdenv.lib.makeLibraryPath [ glibc SDL xlibs.libX11 xlibs.libXext ];

  buildCommand = ''
    # Extract files from the installer
    cp $src quake4-linux-1.0-demo.x86.run
    bash ./quake4-linux-1.0-demo.x86.run --noexec --keep

    # Move extracted files into the Nix store
    mkdir -p $out/libexec
    mv quake4-linux-1.0-demo $out/libexec
    cd $out/libexec/quake4-linux-1.0-demo

    # Remove obsolete setup files
    rm -rf setup.data

    # Patch ELF binaries
    autopatchelf .

    # Remove libgcc_s.so.1 that conflicts with Mesa3D's libGL.so
    rm ./bin/Linux/x86/libgcc_s.so.1

    # Create wrappers for the executables and ensure that they are executable
    for i in q4ded quake4
    do
        mkdir -p $out/bin
        cat > $out/bin/$i <<EOF
    #! ${stdenv.shell} -e
    cd $out/libexec/quake4-linux-1.0-demo
    ./bin/Linux/x86/$i.x86 "\$@"
    EOF
        chmod +x $out/libexec/quake4-linux-1.0-demo/bin/Linux/x86/$i.x86
        chmod +x $out/bin/$i
    done
  '';
}
