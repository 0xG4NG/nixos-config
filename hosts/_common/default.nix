{ pkgs, inputs, ... }:

{
  imports = [
    ../../modules/system/audio
    ../../modules/system/boot
    ../../modules/system/bluetooth
    ../../modules/system/desktop-base
    ../../modules/system/locale-es
  ];

  nixpkgs.overlays = [ inputs.nur.overlays.default ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 14d";
  };

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  environment.systemPackages = with pkgs; [
    wget
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
  ];
}
