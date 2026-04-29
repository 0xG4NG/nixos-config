{ hostName, lib, ... }:

let
  dns = [ "192.168.1.104" "1.1.1.1" ];

  # Fuente única de verdad: toda la info de red por host.
  # address es opcional en hosts con DHCP (se usa solo para /etc/hosts).
  profiles = {
    toledo = {
      type    = "networkmanager";
      address = "192.168.1.101";
    };
    laptop = {
      type = "networkmanager";
    };
    servidor = {
      type    = "static";
      address = "192.168.1.100";
      iface   = "enp6s0";
      prefix  = 24;
      gateway = "192.168.1.1";
    };
  };

  p    = profiles.${hostName};
  isNM = p.type == "networkmanager";

  hostsMap = lib.mapAttrs'
    (name: cfg: lib.nameValuePair cfg.address [ name "${name}.lan" ])
    (lib.filterAttrs (_: cfg: cfg ? address) profiles);
in
{
  networking.hostName    = hostName;
  networking.hosts       = hostsMap;
  networking.firewall.enable = true;
  services.timesyncd.enable  = true;

  networking.networkmanager = lib.mkIf isNM {
    enable            = true;
    insertNameservers = dns;
  };

  networking.useDHCP        = lib.mkIf (!isNM) false;
  networking.interfaces     = lib.mkIf (!isNM) {
    ${p.iface} = {
      useDHCP = false;
      ipv4.addresses = [{ address = p.address; prefixLength = p.prefix; }];
    };
  };
  networking.defaultGateway = lib.mkIf (!isNM) p.gateway;
  networking.nameservers    = lib.mkIf (!isNM) dns;
}
