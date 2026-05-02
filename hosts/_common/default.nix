{ pkgs, inputs, ... }:

{
  imports = [
    ../../modules/system/audio
    ../../modules/system/boot
    ../../modules/system/bluetooth
    ../../modules/system/desktop-base
    ../../modules/system/locale-es
    ../../modules/network
  ];

  nixpkgs.overlays = [ inputs.nur.overlays.default ];

  age.identityPaths = [ "/etc/age/keys.txt" "/etc/ssh/ssh_host_ed25519_key" ];

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
    just
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
}
