{ pkgs, ... }: {
  imports = [
    ../../nixos
    ../../nixos/profiles/headless.nix
    ./disko.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "chocolate";
  system.stateVersion = "26.11";

  # User Configuration
  users.users.yuys13 = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
  };

  # Home Manager Configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.yuys13 = import ./home.nix;
  };
}
