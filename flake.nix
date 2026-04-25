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

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, disko, stylix, nvf, agenix, nur, ... }:
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
            agenix.nixosModules.default
            inputs.nix-gaming.nixosModules.platformOptimizations
            inputs.nix-gaming.nixosModules.pipewireLowLatency
            ./modules/hardware/keyboard/tbk-mini
            {
              home-manager.sharedModules = [
                nvf.homeManagerModules.default
                inputs.noctalia.homeModules.default
              ];
              home-manager.extraSpecialArgs = { inherit inputs; };
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
      packages.${system}.firmware =
        (import ./modules/hardware/keyboard/tbk-mini/nix/firmware.nix {
          keymapSrc = ./modules/hardware/keyboard/tbk-mini/keymap;
        }) { inherit pkgs; };

      nixosConfigurations = builtins.listToAttrs (map (host: {
        name  = host;
        value = mkHost { inherit host; };
      }) hostNames);

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.just
          pkgs.nh
          pkgs.deadnix
          pkgs.nixfmt
          agenix.packages.${system}.default
          pkgs.age
          pkgs.nixos-anywhere
        ];
      };
    };
}
