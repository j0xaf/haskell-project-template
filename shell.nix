{ nixpkgs ? import <nixpkgs> {}
, lib ? nixpkgs.lib
, ...
}:
(import (nixpkgs.fetchFromGitHub {
    owner = "edolstra";
    repo = "flake-compat";
    rev = "99f1c2157fba4bfe6211a321fd0ee43199025dbf";
    sha256 = "oq8d4//CJOrVj+EcOaSXvMebvuTkmBJuT5tzlfewUnQ=";
  }) {
    src = ./.;
  }).shellNix.default
