{ pkgs, ... }:

{
  imports =
    [ (import ../../modules/gnome/home.nix) ];

  home = {
    packages = with pkgs; [
    ];
  };
}
