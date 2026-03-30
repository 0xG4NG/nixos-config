{ ... }:

# cmatrix solo acepta colores ANSI con nombre, no hex.
# Como stylix ya controla los colores ANSI de ghostty, el color
# que se muestra en pantalla sí es el del esquema stylix.
# blue  → base0D (#8fb2c9)
# cyan  → base0C (#b0d5df)
{
  programs.zsh.shellAliases = {
    cmatrix = "cmatrix -C blue";
  };
}
