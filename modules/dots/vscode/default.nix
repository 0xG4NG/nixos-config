{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  stylix.targets.vscode.enable = true;

  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        pkief.material-icon-theme
        bbenoist.nix
      ];
      userSettings = {
        "window.zoomLevel" = 1.5;
        "editor.mouseWheelZoom" = true;

        "workbench.iconTheme" = "material-icon-theme";
        "material-icon-theme.activeIconPack" = "none";
        "material-icon-theme.folders.theme" = "classic";

        # Claude extension
        "claudeCode.preferredLocation" = "panel";
      };
    };
  };
}
