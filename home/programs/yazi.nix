{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    settings = {
      mgr = {
        show_hidden = true;
      };
      plugin = {
        prepend_previewers = [
          {
            mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch";
          }
        ];
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "C" ];
          run = "plugin ouch";
          desc = "Compress with ouch";
        }
      ];
    };
    plugins = {
      ouch = pkgs.yaziPlugins.ouch;
    };
  };
}
