{
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlay = import ./nix/overlay.nix;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
      in
      {
        inherit overlay;
        defaultApp = {
          type = "app";
          program = "${pkgs.autopatchelf}/bin/autopatchelf";
        };
      });
}
