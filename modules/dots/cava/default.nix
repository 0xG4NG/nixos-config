{ config, ... }:

let
  c = config.lib.stylix.colors.withHashtag;
in
{
  xdg.configFile."cava/config".text = ''
    [color]
    gradient       = 1
    gradient_count = 4
    gradient_color_1 = '${c.base0D}'
    gradient_color_2 = '${c.base0C}'
    gradient_color_3 = '${c.base0B}'
    gradient_color_4 = '${c.base0A}'
  '';
}
