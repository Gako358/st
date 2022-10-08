{
  description = "MerrinX terminal (suckless + lightweight)";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = flake-utils.lib.flattenTree {
          st-mx = pkgs.callPackage ./default.nix { };
        };
        defaultPackage = packages.st-mx;
        apps.st-mx = flake-utils.lib.mkApp {
          drv = packages.st-mx;
          exePath = "/bin/st";
        };
        apps.default = apps.st-mx;
        defaultApp = apps.st-mx;
        devShell = pkgs.mkShell rec {
          name = "st-mx";
          packages = with pkgs; [
            pkgconfig
            xorg.libX11
            xorg.libXft
            fontconfig
            harfbuzz
            gd
            glib
          ];
        };

      });
}
