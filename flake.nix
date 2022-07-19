{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
  };
  outputs = { self, nixpkgs, flake-utils, devshell }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            devshell.overlay
          ];
        };
      in

      {
        packages = {
          hotload = pkgs.writeShellApplication {
            name = "hotload";
            runtimeInputs = [ pkgs.python39 ];
            text =
              ''
                python ${./hotload.py} "$@"
              '';
          };
          hotload_38 = pkgs.writeShellApplication {
            name = "hotload_38";
            runtimeInputs = [ pkgs.python38 ];
            text =
              ''
                python ${./hotload.py} "$@"
              '';
          };
          hotload_37 = pkgs.writeShellApplication {
            name = "hotload_37";
            runtimeInputs = [ pkgs.python37 ];
            text =
              ''
                python ${./hotload.py} "$@"
              '';
          };
        };

        devShells.default =
          pkgs.devshell.mkShell {
            packages = [
              self.packages."${system}".hotload
              self.packages."${system}".hotload_38
              self.packages."${system}".hotload_37
            ];
          };
      });
}
