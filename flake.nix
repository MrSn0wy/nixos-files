{
  description = "Init SnowFlake";
 
  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    #  nixpkgs-chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    
    spicetify-flake.url = "github:yuu-fur/spicetify-flake";
    
    flatpak-flake.url = "github:gmodena/nix-flatpak";
    hyprland-flake.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    aagl-flake = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, spicetify-flake, home-manager, aagl-flake, hyprland-flake, flatpak-flake }:
   
  let
    system = "x86_64-linux";

    pkgs-stable = import nixpkgs-stable {
      inherit system;

      config.allowUnfree = true;
    };

    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true; 
    };

    snow-sddm = pkgs-stable.libsForQt5.callPackage ./snow-sddm.nix { };

  in {
    nixosConfigurations.SnowFlake = nixpkgs-stable.lib.nixosSystem {

      specialArgs = {inherit pkgs-stable; inherit pkgs-unstable; inherit hyprland-flake; inherit snow-sddm; };

      modules = [
        ./configuration.nix # Main configuration
        ./hardware-configuration.nix # Hardware configuration
        ./hyprland.nix # hyprland, duh
        {
          imports = [ aagl-flake.nixosModules.default ];
          nix.settings = aagl-flake.nixConfig; # Set up Cachix

          programs.anime-game-launcher.enable = true;
          programs.honkers-railway-launcher.enable = true;
          programs.sleepy-launcher.enable = true;

          environment.systemPackages = [ snow-sddm ];
        }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit pkgs-stable; inherit pkgs-unstable; inherit aagl-flake; inherit spicetify-flake; };
          
          # flatpak-flake.nixosModules.flatpak-flake;
          # flatpak-flake.remotes 

          home-manager.users.snowy.imports = [
            flatpak-flake.homeManagerModules.nix-flatpak
            ./home.nix
          ];

          home-manager.users.snowy.home.stateVersion = "24.05";
        }
      ];
    };
  };
}