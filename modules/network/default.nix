{ hostName, lib, ... }:

let
  dns = [ "8.8.8.8" "8.8.4.4" ];

  profiles = {
    toledo = {
      type    = "networkmanager";
      address = "192.168.1.101";
      gateway = "192.168.1.1";
    };
    laptop = {
      type = "networkmanager";
    };
    xeon = {
      type    = "static";
      address = "192.168.1.100";
      iface   = "enp6s0";
      prefix  = 24;
      gateway = "192.168.1.1";
    };
  };

  p       = profiles.${hostName};
  isNM    = p.type == "networkmanager";
  hasAddr = p ? address;

  hostsMap = lib.mapAttrs'
    (name: cfg: lib.nameValuePair cfg.address [ name "${name}.lan" ])
    (lib.filterAttrs (_: cfg: cfg ? address) profiles);
in
{
  networking.hostName        = hostName;
  networking.hosts           = hostsMap;
  networking.firewall.enable = true;
  services.timesyncd.enable  = true;

  networking.networkmanager = lib.mkIf isNM {
    enable            = true;
    insertNameservers = dns;

    # IP estática via NM si el perfil define address
    ensureProfiles.profiles = lib.mkIf hasAddr {
      "static-eth" = {
        connection = { id = "static-eth"; type = "ethernet"; };
        ipv4 = {
          method    = "manual";
          addresses = "${p.address}/24";
          gateway   = p.gateway;
          dns       = lib.concatStringsSep "," dns;
        };
        ipv6.method = "ignore";
      };
    };
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
