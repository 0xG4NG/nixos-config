{ ... }:

{
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      # Autocompletado case-insensitive
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{A-Z}={a-z}'
      zstyle ':completion:*' menu select
      autoload -Uz compinit && compinit
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol   = "[❯](bold red)";
      };

      directory = {
        style            = "bold blue";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch = {
        format = "[ $branch](bold purple)";
        symbol = " ";
      };

      git_status = {
        format    = "[$all_status$ahead_behind]($style) ";
        style     = "bold yellow";
        ahead     = "⇡$count";
        behind    = "⇣$count";
        modified  = "!$count";
        untracked = "?$count";
        staged    = "+$count";
        deleted   = "✘$count";
      };

      cmd_duration = {
        format    = "[ $duration]($style)";
        style     = "bold yellow";
        min_time  = 2000;
      };
    };
  };
}
