{ ... }:

{
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";

    shellAliases = {
      # Flake
      nfu  = "cd ~/nixos-config && nix flake update";
      nfc  = "cd ~/nixos-config && nix flake check";

      # Búsqueda e inspección
      nse  = "nix search nixpkgs";
      nsh  = "nix shell nixpkgs#";
      ndev = "nix develop";
      nrpl = "nix repl '<nixpkgs>'";

      # Limpieza
      ngc  = "sudo nix-collect-garbage -d";
      ngco = "nix-collect-garbage";

      # Info generación actual
      ngen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    };

    initContent = ''
      # Autocompletado case-insensitive
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{A-Z}={a-z}'
      zstyle ':completion:*' menu select
      autoload -Uz compinit && compinit

      # Commit con IA: genera mensaje con claude y abre editor para confirmar
      gcai() {
        if ! git diff --cached --quiet; then
          local msg
          msg=$(git diff --cached | claude --print "Genera un mensaje de commit conciso en inglés para este diff. Devuelve solo el mensaje, sin explicaciones ni formato extra." 2>/dev/null)
          if [[ -n "$msg" ]]; then
            GIT_EDITOR=nvim git commit -e -m "$msg"
          else
            echo "No se pudo generar el mensaje. Abriendo editor vacío."
            git commit
          fi
        else
          echo "No hay cambios en staging. Usa 'git add' primero."
        fi
      }
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
