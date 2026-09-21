{ pkgs, ... }: {
  imports = [
    ../../nixos
    ../../nixos/profiles/desktop.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "hyper-nixos";
  system.stateVersion = "24.05";

  # Hyper-V settings
  boot.blacklistedKernelModules = [ "hyperv_fb" ];
  boot.kernel.sysctl."vm.overcommit_memory" = "1";

  # Sway minimal settings
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # Packages
  environment.systemPackages = with pkgs; [
    wlr-randr
  ];

  # User Configuration
  users.users.yuys13 = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOGJh4ToxAldiT3DvcJYG+b4HJqpHzQRrRFvx9l4z38t yuys13@eve24.local"
    ];
  };

  programs.fish.enable = true;

  # Home Manager Configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.yuys13 = import ./home.nix;
  };
}
