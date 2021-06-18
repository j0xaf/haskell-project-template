{ pkgs ? import <nixpkgs> { } }:
let
  inherit (pkgs) callPackage fetchFromGitHub mkShell lib;
  ghcVersion = "8.10.4";

  concatenateVersion = v: lib.concatStrings (builtins.filter (c: c != ".") (lib.stringToCharacters v));
  ghc = lib.attrByPath [ "haskell" "compiler" "ghc${concatenateVersion ghcVersion}" ] null pkgs;

  easy-hls-src = fetchFromGitHub {
    owner  = "jkachmar";
    repo   = "easy-hls-nix";
    rev    = "9d64543a015563942c954b89addc1108800ed134";
    sha256 = "sha256-33cphoKJK0GB7M7iTYwuBoXW7q6JFBo/dkLsRsYb+Os=";
  };
  easy-hls = callPackage easy-hls-src {
    ghcVersions = [ ghcVersion ];
  };
in

mkShell {
  buildInputs = with pkgs; let
      exe = haskell.lib.justStaticExecutables;
  in [
    easy-hls
    cabal-install
    ghc
    (exe haskellPackages.hoogle)
    python3
    stylish-haskell
#    stylish-cabal            
  ];
}
