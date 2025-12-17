{ inputs, ... }:
{
  imports = [ inputs.walker.homeManagerModules.default ];
  programs.walker = {
    enable = true;
    runAsService = true;
    config = {
      keybinds = {
        next = [ "ctrl j" ];
        previous = [ "ctrl k" ];
      };
      keybinds.quick_activate = [ ];
    };
  };
}
