{
  description = "DOT ONLY KNOWS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://yuys13.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "yuys13.cachix.org-1:t6ghTZgSjyY/d4310E7ZxICuAAOLWjY4bWEdcVw7sl8="
    ];
  };

  outputs =
    {
      self,
      flake-parts,
      home-manager,
      nix-darwin,
      treefmt-nix,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      imports = [
        treefmt-nix.flakeModule
      ];

      flake = {
        darwinConfigurations."eve24" = nix-darwin.lib.darwinSystem {
          modules = [
            ./nix/hosts/eve24/configuration.nix
            home-manager.darwinModules.home-manager
          ];
        };

        nixosConfigurations."chocolate" = inputs.nixpkgs.lib.nixosSystem {
          modules = [
            inputs.disko.nixosModules.disko
            inputs.comin.nixosModules.comin
            ./nix/hosts/chocolate/configuration.nix
            home-manager.nixosModules.home-manager
          ];
        };
      };

      perSystem =
        { config, pkgs, ... }:
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              mdformat.enable = true;
              nixfmt.enable = true;
              shfmt = {
                enable = true;
                useEditorConfig = true;
              };
              stylua.enable = true;
              taplo.enable = true;
              yamlfmt.enable = true;
            };

            settings.global.excludes = [
              "_sources/*"
              "home/XDG_CONFIG_HOME/nvim/lazy-lock.json"
            ];
          };

          devShells.default = pkgs.mkShell {
            packages = [
              config.treefmt.build.wrapper
            ];
          };

        };
    };
}
