{
  description = "based on ZaneyOS 2.2";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    wezterm.url = "github:wez/wezterm?dir=nix";

    fine-cmdline = {
      url = "github:VonHeikemen/fine-cmdline.nvim";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    alejandra,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    # system = "x86_64-linux";

    username = "abayoumy";
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      "HTPC" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit outputs;
          inherit username;
          host = "HTPC";
        };
        modules = [
          ./hosts/HTPC/config.nix
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];}
          inputs.stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit username;
              inherit inputs;
              inherit outputs;
              host = "HTPC";
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = import ./hosts/HTPC/home.nix;
          }
        ];
      };
      "NixOS01" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit outputs;
          inherit username;
          host = "NixOS01";
        };
        modules = [
          ./hosts/NixOS01/config.nix
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];}
          inputs.stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit username;
              inherit inputs;
              inherit outputs;
              host = "NixOS01";
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = import ./hosts/NixOS01/home.nix;
          }
        ];
      };
    };
  };
}
