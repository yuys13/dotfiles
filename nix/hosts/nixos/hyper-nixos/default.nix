{ config, pkgs, ... }: {
  profiles.desktop.enable = true;
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
  users.users.${config.mainUser} = {
    extraGroups = [
      "networkmanager"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}
