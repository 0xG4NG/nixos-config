{ pkgs, lib, ... }:

{
  qt = {
    enable = true;
    platformTheme.name = lib.mkForce "kvantum";
    style.name = lib.mkForce "kvantum";
  };

  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
  ];

  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=KvGnomeDark
  '';

  systemd.user.sessionVariables = {
    QT_QPA_PLATFORMTHEME = lib.mkForce "kvantum";
    QT_STYLE_OVERRIDE    = lib.mkForce "kvantum";
  };
}
