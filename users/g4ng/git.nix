{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user.name          = "0xg4ng";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };

    # Email comes from sops secret to keep it out of the nix store
    includes = [{ path = "/run/secrets/gitconfig"; }];
  };
}
