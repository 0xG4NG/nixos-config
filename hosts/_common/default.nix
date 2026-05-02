{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/system/audio
    ../../modules/system/boot
    ../../modules/system/bluetooth
    ../../modules/system/desktop-base
    ../../modules/system/locale-es
    ../../modules/network
  ];

  options.misc.allowUnfreeNames = lib.mkOption {
    type        = lib.types.listOf lib.types.str;
    default     = [];
    description = "Paquetes unfree permitidos en este host (por nombre vía lib.getName).";
    example     = [ "obsidian" "steam" ];
  };

  config = {
    nixpkgs.overlays = [ inputs.nur.overlays.default ];

    age.identityPaths = [ "/etc/age/keys.txt" "/etc/ssh/ssh_host_ed25519_key" ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nix.gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 14d";
    };

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) config.misc.allowUnfreeNames;

    programs.zsh.enable = true;

    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    environment.systemPackages = with pkgs; [
      wget
      just
      nh
      git
      gh
      neovim
      rsync
      ripgrep
      jq
      fastfetch
      tree
      cmatrix
      cava
      ghostty
    ];
  };
}
