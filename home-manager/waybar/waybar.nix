{
  inputs,
  lib,
  config,
  pkgs,
  ...
} : let
    configFile = builtins.readFile ./config.json;
    config = builtins.fromJSON configFile;
  in {
  stylix.targets.waybar.addCss = false;
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [ config ];
    style = '' 
* {
  font-family: "Maple Mono NF";
  font-size: 14px;
  color: @base05;
  border: none;
  min-height: 0;
  padding: 0;
  margin: 0;
}

window#waybar {
  background: transparent;
}

.modules-left, .modules-center, .modules-right {
  background-color: @base00;
  border: 1px solid @base03;
  border-radius: 8px;
  padding: 4px;
  margin: 8px 8px 0 8px;
}

.module {
  padding: 0 8px;
  border-radius: 8px;
}

#idle_inhibitor {
  /* fix icon alignment */
  padding-left: 5px;
}

#idle_inhibitor.activated {
  background-color: @base02;
  color: @base04;
}
    '';
  };
}
