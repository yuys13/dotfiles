{ inputs, self }:
let
  lib = inputs.nixpkgs.lib;
  entries = builtins.readDir ./.;
  hostDirs = lib.filterAttrs (_: type: type == "directory") entries;

  mkNixosHost =
    hostName: dir:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs self hostName;
      };
      modules = [
        { networking.hostName = hostName; }
        ../../modules/nixos
        (dir + "/default.nix")
      ]
      ++ lib.optionals (builtins.pathExists (dir + "/hardware-configuration.nix")) [
        (dir + "/hardware-configuration.nix")
      ]
      ++ lib.optionals (builtins.pathExists (dir + "/disko.nix")) [
        inputs.disko.nixosModules.disko
        (dir + "/disko.nix")
      ]
      ++ lib.optional (builtins.pathExists (dir + "/home.nix")) (
        { config, ... }: {
          home-manager.users.${config.mainUser} = {
            imports = [
              ../../modules/home-manager
              (dir + "/home.nix")
            ];
          };
        }
      );
    };
in
lib.mapAttrs (name: _: mkNixosHost name (./. + "/${name}")) hostDirs
