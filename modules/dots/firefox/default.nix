{ ... }:

{
  programs.firefox = {
    enable = true;

    profiles.default = {
      isDefault = true;

      settings = {
        # --- Wayland / rendimiento ---
        "media.ffmpeg.vaapi.enabled"                  = true;
        "gfx.webrender.all"                           = true;
        "widget.use-xdg-desktop-portal.file-picker"   = 1;

        # --- Muchas tabs: barra compacta y scrollable ---
        "browser.tabs.tabMinWidth"              = 66;
        "browser.tabs.tabClipWidth"             = 83;
        "browser.tabs.closeTabByDblclick"       = true;
        "browser.tabs.warnOnClose"              = false;
        "browser.tabs.warnOnCloseOtherTabs"     = false;
        "browser.tabs.insertAfterCurrent"       = true;

        # --- Teclado ---
        "accessibility.typeaheadfind"           = true;   # / para buscar en página
        "browser.search.openintab"              = true;   # búsquedas abren en nueva tab
        "findbar.highlightAll"                  = true;

        # --- UI limpia ---
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.compactmode.show"              = true;
        "browser.uidensity"                     = 1;      # 1 = compact
        "browser.newtabpage.activity-stream.showSponsored"       = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        # --- Privacidad básica ---
        "privacy.trackingprotection.enabled"            = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "browser.send_pings"                            = false;
        "browser.urlbar.speculativeConnect.enabled"     = false;
        "toolkit.telemetry.enabled"                     = false;
        "toolkit.telemetry.unified"                     = false;
        "datareporting.healthreport.uploadEnabled"      = false;
      };

      userChrome = ''
        /* Tabs más compactas */
        :root { --tab-min-height: 28px !important; }

        /* Ocultar botón de nuevo tab en la barra (se abre con Ctrl+T) */
        #tabs-newtab-button { display: none !important; }
      '';
    };
  };
}
