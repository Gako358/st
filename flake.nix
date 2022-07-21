{
  description = "MerrinX ST build";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: 
    let 
      system = "x86_64-linux";
      overlay = final: prev: {
        st = prev.st.overrideAttrs (old: {
	  src = builtins.path { path = ./.; name = "st"; };
	  buildInputs = old.buildInputs ++ [
	    prev.haskel.Packages.gi-harfbuzz
	  ];
	});
      };
      in 
      {
        overlays.default = overlay;
	checks.${system}.build = (
	  import nixpkgs {
	    inherit system;
	    overlays = [ overlay ];
	  }
        ).st;
      };
}
