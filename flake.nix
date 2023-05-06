{
  description = "MerrinX terminal (suckless + lightweight)";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              stMX = prev.st.overrideAttrs (oldAttrs: rec {
                src = builtins.path {
					path = ./.;
					name = "stMX";
				};
                buildInputs = 
					oldAttrs.buildInputs
					++ [
						prev.gd
						prev.glib
						prev.fontconfig
						prev.harfbuzz
					];
              });
            })
          ];
        };
      in
      rec {
        apps = {
          st = {
            type = "app";
            program = "${defaultPackage}/bin/st";
          };
        };
        
        devShell = pkgs.mkShell rec {
          name = "stMX";
          packages = with pkgs; [
            pkg-config
            xorg.libX11
            xorg.libXft
            fontconfig
            harfbuzz
            gd
            glib
          ];
        };

        packages.stMX = pkgs.stMX;
        defaultApp = apps.st;
        defaultPackage = pkgs.stMX;
      }
    );
}
