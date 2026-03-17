{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "0xg4ng";
        email = "ruben@g4ng.es";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };
}
