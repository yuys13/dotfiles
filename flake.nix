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
