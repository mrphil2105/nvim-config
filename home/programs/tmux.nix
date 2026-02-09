{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    prefix = "C-s";
    keyMode = "vi";
    escapeTime = 1;
    clock24 = true;
    baseIndex = 1;
    historyLimit = 10000;
    extraConfig = ''
      set -as terminal-features ",*:RGB"
      set -g renumber-windows on
      # TODO: Remove line below when https://github.com/nix-community/home-manager/issues/7771 has been fixed
      bind C-s send-prefix
      bind b last-window
      bind 0 select-window -t :10
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind -n C-_ select-pane -l
      bind -r C-h resize-pane -L 5
      bind -r C-j resize-pane -D 5
      bind -r C-k resize-pane -U 5
      bind -r C-l resize-pane -R 5
      bind -r M-h resize-pane -L 1
      bind -r M-j resize-pane -D 1
      bind -r M-k resize-pane -U 1
      bind -r M-l resize-pane -R 1
      unbind Left
      unbind Right
      unbind Up
      unbind Down
      unbind C-Left
      unbind C-Right
      unbind C-Up
      unbind C-Down
      unbind M-Left
      unbind M-Right
      unbind M-Up
      unbind M-Down
      unbind -n C-\\
    '';
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      tokyo-night-tmux
    ];
  };
}
