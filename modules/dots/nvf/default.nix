{ config, ... }:

{
  programs.nvf = {
    enable = true;

    settings.vim = {
      theme = {
        enable = true;
        name = "base16";
        style = "dark";
      };

      # Stylix injects colors via base16 — no need to hardcode
      clipboard.registers = "unnamedplus";
      lineNumberMode = "relNumber";

      languages = {
        enableLSP = true;
        enableFormat = true;
        enableTreesitter = true;

        nix.enable = true;
        bash.enable = true;
      };

      statusline.lualine.enable = true;
      telescope.enable = true;
      autocomplete.nvim-cmp.enable = true;
      filetree.neo-tree.enable = true;
      git.enable = true;
    };
  };
}
