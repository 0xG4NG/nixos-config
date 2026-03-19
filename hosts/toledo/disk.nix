{ ... }:

{
  # enableConfig = false: disko solo documenta el layout, los mounts los gestiona
  # hardware-configuration.nix con las UUIDs reales de las particiones.
  disko.enableConfig = false;

  disko.devices = {
    disk = {
      main = {
        type   = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name     = "ESP";
              size     = "1G";
              type     = "EF00";
              content  = {
                type         = "filesystem";
                format       = "vfat";
                mountpoint   = "/boot";
                mountOptions = [ "fmask=0077" "dmask=0077" ];
              };
            };

            root = {
              priority = 2;
              size     = "1829G";
              content  = {
                type       = "filesystem";
                format     = "ext4";
                mountpoint = "/";
              };
            };

            swap = {
              priority = 3;
              size     = "100%";
              content  = {
                type = "swap";
              };
            };
          };
        };
      };
    };
  };
}
