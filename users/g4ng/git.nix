{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user.name          = "0xg4ng";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };

    # Email vive en /run/secrets/gitconfig (generado por activation script
    # en hosts/toledo/default.nix a partir del secreto agenix git_email).
    includes = [{ path = "/run/secrets/gitconfig"; }];
  };
}
