{
  description = "A very basic flake";
  inputs = {
    haskellNix.url = "github:input-output-hk/haskell.nix";
    nixpkgs.follows = "haskellNix/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, haskellNix }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ] (system:
    let
      overlays = [ haskellNix.overlay
        (final: prev: {
          # This overlay adds our project to pkgs
          helloProject =
            final.haskell-nix.project' {
              src = ./.;
              compiler-nix-name = "ghc8104";
            };
        })
      ];
      pkgs = import nixpkgs { inherit system overlays; };
      flake = pkgs.helloProject.flake {};
    in flake // {
      # Built by `nix build .`
      defaultPackage = flake.packages."hello:exe:hello";

      # This is used by `nix develop .` to open a shell for use with
      # `cabal`, `hlint` and `haskell-language-server`
      devShell = pkgs.helloProject.shellFor {
        with-hoogle = true;
        tools = {
          cabal = "latest";
          hlint = "latest";
          haskell-language-server = "latest";
        };
      };
    });
}
