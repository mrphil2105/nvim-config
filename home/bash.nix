{ ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''eval "$(direnv hook bash)"'';
    bashrcExtra = ''
      alias hms="home-manager switch --flake ."
      alias v="nvim ."
      alias s="systemctl suspend"
      alias sl="nohup hyprlock >/dev/null 2>&1 & sleep 0.3 && systemctl suspend"
      alias dionysos="ssh group01@dionysos.itu.dk"
      alias ituvpn="sudo openfortivpn sslvpn.itu.dk -u phimo"
      alias startvpn="sudo systemctl start openvpn-router.service"
      alias stopvpn="sudo systemctl stop openvpn-router.service"
    '';
  };
}
