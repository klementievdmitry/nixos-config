{ config, pkgs, home-manager, inputs, ironbar, user, ... }:

{
  home-manager.users.${user} = {
    programs.ironbar = {
      enable = true;
      package = inputs.ironbar;
      #features = [ ];

      #config = {};
      #style = "";
    };  
  };
}
