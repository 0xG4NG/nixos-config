{ config, lib, ... }:

let cfg = config.misc.virtualisation;
in {
  options.misc.virtualisation = {
    enable = lib.mkEnableOption "podman + libvirtd + virt-manager";

    user = lib.mkOption {
      type        = lib.types.str;
      description = "Usuario que se añade al grupo libvirtd para gestionar VMs.";
      example     = "g4ng";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman.enable = true;

    virtualisation.libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;  # TPM virtual (útil para Windows 11)
    };
    programs.virt-manager.enable = true;

    users.users.${cfg.user}.extraGroups = [ "libvirtd" ];
  };
}
