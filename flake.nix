{
  description = "MerrinX ST build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
	  inherit system;
	  overlays = [
	    (final: prev: {
	      st_mx = prev.st.overrideAttrs (oldAttrs: rec {
	        version = "main";
		src = ./.;
		buildInputs = oldAttrs.buildInputs ++ [
		  prev.harfbuzz.dev
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

	  package.st_mx = pkgs.st_mx;
	  defaultApp = apps.st;
	  defaultPackage = pkgs.st_mx;
	}
    );
}
