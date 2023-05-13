{ pkgs, ... }:

{
  imports =
    [ (import ../base/home.nix) ] ++ # Base system configuration
    [ (import ../../modules/gnome/home.nix) ];

  home = {
    packages = with pkgs; [
    ];
  };
}
