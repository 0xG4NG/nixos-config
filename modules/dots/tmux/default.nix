{ ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "tmux-256color";
    extraConfig = ''
      # Ventanas y paneles desde el índice 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Colores 24-bit
      set-option -sa terminal-overrides ",xterm*:Tc"

      # Split con la misma ruta
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # Barra de estado
      set -g status-position top
    '';
  };
}
