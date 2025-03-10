{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-p";
    escapeTime = 0;
    mouse = true;
    baseIndex = 1;
    paneBaseIndex = 1;
    keyMode = "vi";
    extraConfig = ''
      unbind r
      bind r source-file ~/.tmux.conf

      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      set -g status-position top
      
      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'christoomey/vim-tmux-navigator'
      set -g @plugin 'dracula/tmux'

      set -g @dracula-show-powerline true
      set -g @dracula-show-fahrenheit false
      set -g @dracula-plugins "weather"
      set -g @dracula-show-left-icon session
      set -g @dracula-show-timezone false
      set -g @dracula-battery-label "Battery"

      run '~/.tmux/plugins/tpm/tpm'
    '';
  };
}
