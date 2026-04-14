{ ... }:

# Configuración declarativa de COSMIC via xdg.configFile.
# COSMIC almacena su config en ~/.config/cosmic/ con archivos de texto plano.
# OJO: al gestionar estos archivos aquí, los cambios desde la UI de COSMIC
# se perderán en el siguiente rebuild (home-manager los sobreescribe).

let
  panel = "com.system76.CosmicPanel.Panel/v1";
  dock  = "com.system76.CosmicPanel.Dock/v1";
  base  = "com.system76.CosmicPanel/v1";
in
{
  xdg.configFile = {

    # Lista de paneles activos
    "cosmic/${base}/entries".text = ''
      [
          "Panel",
          "Dock",
      ]
    '';

    # ── Panel (barra superior) ────────────────────────────────────────────
    "cosmic/${panel}/name".text           = ''"Panel"'';
    "cosmic/${panel}/anchor".text         = "Top";
    "cosmic/${panel}/anchor_gap".text     = "false";
    "cosmic/${panel}/autohide".text       = "None";
    "cosmic/${panel}/autohover_delay_ms".text = "None";
    "cosmic/${panel}/background".text     = "ThemeDefault";
    "cosmic/${panel}/border_radius".text  = "0";
    "cosmic/${panel}/exclusive_zone".text = "true";
    "cosmic/${panel}/expand_to_edges".text = "true";
    "cosmic/${panel}/keyboard_interactivity".text = "r#None";
    "cosmic/${panel}/layer".text          = "Top";
    "cosmic/${panel}/margin".text         = "4";
    "cosmic/${panel}/opacity".text        = "0.8";
    "cosmic/${panel}/output".text         = "All";
    "cosmic/${panel}/padding".text        = "4";
    "cosmic/${panel}/padding_overlap".text = "0.5";
    "cosmic/${panel}/size".text           = "M";
    "cosmic/${panel}/size_center".text    = "None";
    "cosmic/${panel}/size_wings".text     = "None";
    "cosmic/${panel}/spacing".text        = "0";

    "cosmic/${panel}/plugins_center".text = "None";
    "cosmic/${panel}/plugins_wings".text  = ''
      Some((
          left: [
              "com.system76.CosmicAppletWorkspaces",
          ],
          right: [
              "com.system76.CosmicAppletTime",
              "com.system76.CosmicAppletAudio",
              "com.system76.CosmicAppletBluetooth",
              "com.system76.CosmicAppletNetwork",
              "com.system76.CosmicAppletNotifications",
              "com.system76.CosmicAppletPower",
          ],
      ))
    '';

    # ── Dock (barra inferior — lista de ventanas) ─────────────────────────
    "cosmic/${dock}/name".text            = ''"Dock"'';
    "cosmic/${dock}/anchor".text          = "Bottom";
    "cosmic/${dock}/anchor_gap".text      = "true";
    "cosmic/${dock}/autohide".text        = "None";
    "cosmic/${dock}/autohover_delay_ms".text = "None";
    "cosmic/${dock}/background".text      = "ThemeDefault";
    "cosmic/${dock}/border_radius".text   = "8";
    "cosmic/${dock}/exclusive_zone".text  = "true";
    "cosmic/${dock}/expand_to_edges".text = "false";
    "cosmic/${dock}/keyboard_interactivity".text = "r#None";
    "cosmic/${dock}/layer".text           = "Top";
    "cosmic/${dock}/margin".text          = "4";
    "cosmic/${dock}/opacity".text         = "0.9";
    "cosmic/${dock}/output".text          = "All";
    "cosmic/${dock}/padding".text         = "6";
    "cosmic/${dock}/padding_overlap".text = "0.5";
    "cosmic/${dock}/size".text            = "M";
    "cosmic/${dock}/size_center".text     = "None";
    "cosmic/${dock}/size_wings".text      = "None";
    "cosmic/${dock}/spacing".text         = "0";

    "cosmic/${dock}/plugins_center".text  = ''
      Some([
          "com.system76.CosmicAppletMinimize",
      ])
    '';
    "cosmic/${dock}/plugins_wings".text   = "None";
  };
}
