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
              nixfmt.enable = true;
              stylua.enable = true;
              yamlfmt.enable = true;
              mdformat.enable = true;
            };
          };

          devShells.default = pkgs.mkShell {
            packages = [
              config.treefmt.build.wrapper
            ];
          };

        };
    };
}
