{ zen-browser, pkgs, ... }:

{
  programs.zen-browser = {
    enable = true;
    package = zen-browser.packages.${pkgs.system}.default;
    profiles.default = {
      isDefault = true;
      settings = {
        "browser.startup.homepage"                            = "about:newtab";
        "browser.newtabpage.enabled"                         = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Barra arriba, comportamiento convencional
        "zen.tabs.vertical"              = false;
        "zen.sidebar.enabled"            = false;
        "zen.view.compact-mode"          = false;
        "zen.view.use-single-toolbar"    = false;
        "browser.tabs.inTitlebar"        = 0;
      };
    };
  };

  stylix.targets.zen-browser = {
    profileNames = [ "default" ];
  };
}
