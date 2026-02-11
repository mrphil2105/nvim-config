{ lib, pkgs, ... }:
let
  p10kFile = pkgs.writeText "p10k.zsh" (builtins.readFile ./p10k.zsh);
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = lib.mkBefore ''
      source ${p10kFile}
      function zvm_config() {
        ZVM_INIT_MODE=sourcing
      }
      function zvm_after_init() {
        zvm_bindkey viins '^Y' autosuggest-accept
      }
    '';
    shellAliases = {
      hms = "home-manager switch --flake ~/.nixos";
      nrs = "sudo nixos-rebuild switch --flake ~/.nixos";
      nrt = "sudo nixos-rebuild test --flake ~/.nixos";
      v = "nvim";
      s = "systemctl suspend";
      sl = "nohup hyprlock >/dev/null 2>&1 & sleep 0.3 && systemctl suspend";
      ituvpn = "sudo openfortivpn sslvpn.itu.dk -u phimo";
    };
    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
    ];
    oh-my-zsh.enable = true;
    oh-my-zsh.plugins = [ "git" ];
  };
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
