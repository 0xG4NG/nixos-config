{ zen-browser, pkgs, ... }:

{
  programs.zen-browser = {
    enable = true;
    package = zen-browser.packages.${pkgs.system}.default;
    profiles.default = {
      isDefault = true;
      settings = {
        "browser.startup.homepage" = "about:newtab";
        "browser.newtabpage.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
  };

  stylix.targets.zen-browser = {
    profileNames = [ "default" ];
  };
}
