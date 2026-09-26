{ inputs, self }:
let
  lib = inputs.nixpkgs.lib;
  entries = builtins.readDir ./.;
  hostDirs = lib.filterAttrs (_: type: type == "directory") entries;

  mkDarwinHost =
    hostName: dir:
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs self hostName;
      };
      modules = [
        ../../modules/darwin
        (dir + "/default.nix")
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
lib.mapAttrs (name: _: mkDarwinHost name (./. + "/${name}")) hostDirs
