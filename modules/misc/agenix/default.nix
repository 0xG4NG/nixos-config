{ config, lib, inputs, ... }:

let
  cfg = config.misc.agenix;
in
{
  options.misc.agenix = {
    secrets = lib.mkOption {
      type        = lib.types.listOf lib.types.str;
      default     = [ ];
      description = "Lista de nombres de secretos (sin extensión .age) que necesita este host.";
      example     = [ "tg-token" "wg-private-key" ];
    };
  };

  config = lib.mkIf (cfg.secrets != [ ]) {
    age.secrets = lib.listToAttrs (map (name: {
      inherit name;
      value.file = "${inputs.self}/secrets/${name}.age";
    }) cfg.secrets);
  };
}
