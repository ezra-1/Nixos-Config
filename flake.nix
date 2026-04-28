{
  description = "Ezra’s NixOS & Home Manager configuration";

  # ------------------------------------------------------
  # Inputs
  # ------------------------------------------------------
  inputs = {
    # ------------------ Nixpkgs -------------------------
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    # ------------------ Home Manager ---------------------
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ------------------ Better Blur -----------------------
     kwin-effects-better-blur-dx = {
      url = "github:xarblu/kwin-effects-better-blur-dx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ------------------------------------------------------
  # Outputs
  # ------------------------------------------------------
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      # Supported systems (Linux + macOS)
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      # Helper: apply a function to all supported systems
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # ------------------------------------------------------
      # Packages
      # ------------------------------------------------------
      packages = forAllSystems (system: import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; });

      # ------------------------------------------------------
      # Overlays
      # ------------------------------------------------------
      overlays = import ./overlays { inherit inputs; };

      # ------------------------------------------------------
      # NixOS Configurations
      # ------------------------------------------------------
      nixosConfigurations = {
        ezra = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/ezra ];
        };
      };

      # ------------------------------------------------------
      # Home Manager Configurations
      # ------------------------------------------------------
      homeConfigurations = {
        ezra = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home/ezra/ezra.nix
          ];
        };
      };
    };
}
