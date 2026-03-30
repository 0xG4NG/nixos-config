{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    bitwarden-cli
  ];

  # sudo via SSH agent — desbloquea Bitwarden al inicio y sudo usa la clave del agente
  security.pam.sshAgentAuth.enable  = true;
  security.sudo.extraConfig         = "Defaults env_keep+=SSH_AUTH_SOCK";
}
