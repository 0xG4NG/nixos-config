{ osConfig, ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks."github.com" = {
      hostname    = "github.com";
      user        = "git";
      identityFile = osConfig.age.secrets.github_ssh.path;
    };
  };
}
