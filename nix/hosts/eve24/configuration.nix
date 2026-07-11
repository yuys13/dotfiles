{ pkgs, ... }: {
  imports = [
    ../../nix-darwin
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 7;

  # User Configuration
  users.users.yuys13 = {
    name = "yuys13";
    home = "/Users/yuys13";
  };

  # Home Manager Configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.yuys13 = import ./home.nix;
  };
}
