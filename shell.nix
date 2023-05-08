{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.zsh
    pkgs.rnix-lsp
  ];
}
