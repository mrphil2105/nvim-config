{ ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''eval "$(direnv hook bash)"'';
    bashrcExtra = ''
      alias hms="home-manager switch --flake ."
      alias nrs="sudo nixos-rebuild switch --flake ."
      alias v="nvim ."
      alias s="systemctl suspend"
      alias sl="nohup hyprlock >/dev/null 2>&1 & sleep 0.3 && systemctl suspend"
      alias dionysos="ssh group01@dionysos.itu.dk"
      alias ituvpn="sudo openfortivpn sslvpn.itu.dk -u phimo"
    '';
  };
}
