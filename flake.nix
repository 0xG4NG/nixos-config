{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, disko, stylix, zen-browser, nvf, sops-nix, ... }:
    let
      lib    = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs   = nixpkgs.legacyPackages.${system};

      mkHost = { host, hostSystem ? system }:
        nixpkgs.lib.nixosSystem {
          system = hostSystem;
          specialArgs = { inherit inputs; };
          modules = [
            disko.nixosModules.disko
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            inputs.nix-gaming.nixosModules.platformOptimizations
            inputs.nix-gaming.nixosModules.pipewireLowLatency
            {
              home-manager.sharedModules = [
                zen-browser.homeModules.default
                nvf.homeManagerModules.default
              ];
              home-manager.extraSpecialArgs = { inherit inputs zen-browser; };
            }
            ./hosts/_common
            ./hosts/${host}
          ];
        };

      # Auto-descubrimiento: cualquier subdirectorio en hosts/ que no sea _common
      hostDirs  = builtins.readDir ./hosts;
      hostNames = builtins.attrNames (lib.filterAttrs (name: type:
        type == "directory" && name != "_common"
      ) hostDirs);
    in
    {
      nixosConfigurations = builtins.listToAttrs (map (host: {
        name  = host;
        value = mkHost { inherit host; };
      }) hostNames);

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.just
          pkgs.nh
          pkgs.deadnix
          pkgs.nixfmt-rfc-style
          pkgs.sops
          pkgs.age
        ];
        env.SOPS_AGE_KEY_FILE = "/etc/age/keys.txt";
      };
    };
}
