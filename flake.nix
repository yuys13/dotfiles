{
  description = "DOT ONLY KNOWS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
    }:
    {
      darwinConfigurations."eve24" = nix-darwin.lib.darwinSystem {
        modules = [ ./nix/hosts/eve24/configuration.nix ];
      };
    };
}
