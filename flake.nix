{
  description = "Advent of code";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            go
          ];
        };

        formatter = pkgs.nixpkgs-fmt;
        packages = {
          aoc2022 = pkgs.buildGoModule {
            pname = "main";
            version = "1.0.0";

            vendorHash = null;

            src = ./2022;
          };
        };
      });
}
