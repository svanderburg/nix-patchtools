{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-compat = {
    url = github:edolstra/flake-compat;
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      overlay = import ./nix/overlay.nix;
    in
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlay ];
          };
        in
        {
          defaultPackage = pkgs.autopatchelf;
          defaultApp = {
            type = "app";
            program = "${pkgs.autopatchelf}/bin/autopatchelf";
          };
        })
    // { inherit overlay; };
}
