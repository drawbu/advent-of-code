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

          "2024" = pkgs.mkShell {
            inputsFrom = [ packages."2024" ];
            packages = with pkgs; [ zig_0_13 ];
            shellHook = ''
              export ZIG_GLOBAL_CACHE_DIR=$out/2024/.cache
            '';
          };

          "2025" = pkgs.mkShell {
            inputsFrom = [ packages."2025" ];
            packages = with pkgs; [ zig ];
            shellHook = ''
              export ZIG_GLOBAL_CACHE_DIR=$out/2025/.cache
            '';
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

          "2024" = pkgs.zigStdenv.mkDerivation {
            name = "aoc2024";
            src = ./2024;
            nativeBuildInputs = with pkgs; [ zig_0_13.hook ];
          };

          "2025" = pkgs.zigStdenv.mkDerivation {
            name = "aoc2025";
            src = ./2025;
            nativeBuildInputs = with pkgs; [ zig.hook ];
          };
        };
      }
    );
}
