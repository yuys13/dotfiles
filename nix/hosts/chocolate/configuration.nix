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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOGJh4ToxAldiT3DvcJYG+b4HJqpHzQRrRFvx9l4z38t yuys13@eve24.local"
    ];
  };

  # Home Manager Configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.yuys13 = import ./home.nix;
  };
}
