{ config, pkgs, home-manager, ... }:

{
  programs.ironbar = {
    enable = true;
    package = inputs.ironbar;
    #features = [ ];

    #config = {};
    #style = "";
  };
}
