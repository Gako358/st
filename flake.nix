{
  description = "MerrinX ST build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
      let
        system = "x86_64-linux";
	overlay = final: prev: {
	  st_mx = prev.st.overrideAttrs (oldAttrs: rec {
	    version = "main";
	    src = ./.;
	    buildInputs = oldAttrs.buildInputs ++ [
	      prev.harfbuzz.dev
	    ];
	  });
	};
	in
	rec {
	  overlays.default = overlay;
	  checks.${system}.build = (
            import nixpkgs {
	      inherit system;
	      overlays = [ overlay ];
	    }
	  ).st;
	};
}
