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
        aoc2022 = with pkgs; [ go ];
        aoc2023 = rec {
          cc = pkgs.gcc12;
          deps = with pkgs; [
            glibc
            gnumake
            criterion
          ] ++ [ cc ];
          shell = with pkgs; [
            ltrace
            valgrind
            python311Packages.compiledb
            man-pages
            man-pages-posix
            gdb
          ] ++ deps;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = aoc2022 ++ aoc2023.shell;
        };

        formatter = pkgs.nixpkgs-fmt;
        packages = {
          aoc2022 = pkgs.buildGoModule rec {
            name = "aoc2022";
            version = "1.0.0";
            src = ./2022;

            vendorHash = null;
            buildPhase = ''
              ${pkgs.go}/bin/go build -o ${name}
            '';
            installPhase = ''
              mkdir -p $out/bin
              cp ${name} $out/bin/
            '';
          };

          aoc2023 = pkgs.stdenv.mkDerivation rec {
            name = "aoc2023";
            src = ./2023;

            makeFlags = [ "CC=${aoc2023.cc}/bin/gcc" ];
            buildInputs = aoc2023.deps;

            hardeningDisable = [ "format" "fortify" ];
            enableParallelBuilding = true;

          buildPhase = ''
            make ${name}
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp ${name} $out/bin
          '';
          };
        };
      });
}
