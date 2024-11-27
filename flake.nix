{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { ... }@inputs:
    inputs.utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };
        inherit (pkgs) lib;
      in
      rec {
        formatter = pkgs.nixfmt-rfc-style;

        devShells = {
          "2022" = pkgs.mkShell {
            inputsFrom = [ packages."2022" ];
          };

          "2023" = pkgs.mkShell {
            inputsFrom = [ packages."2023" ];
            packages =
              with pkgs;
              lib.optionals stdenv.isLinux [
                gdb
                ltrace
                valgrind
              ];
          };
        };

        packages = {
          "2022" = pkgs.buildGoModule {
            name = "aoc2022";
            version = "1.0.0";
            src = ./2022;
            vendorHash = null;
          };

          "2023" = pkgs.gcc12Stdenv.mkDerivation {
            name = "aoc2023";
            src = ./2023;

            buildInputs = with pkgs; [ criterion ];

            hardeningDisable = [
              "format"
              "fortify"
            ];
            env.PREFIX = "${placeholder "out"}";
            enableParallelBuilding = true;
          };
        };
      }
    );
}
