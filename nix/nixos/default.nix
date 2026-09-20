{ pkgs, ... }: {
  imports = [
    ../nix.nix
    ./comin.nix
  ];

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Time zone and locale
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";

  # Services
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  services.tailscale.enable = true;

  # Networking
  networking.useDHCP = pkgs.lib.mkDefault true;

  # Packages and Environment
  environment = {
    systemPackages = with pkgs; [
      curl
      git
      nh
      vim
    ];
    variables = {
      NH_SHOW_ACTIVATION_LOGS = "1";
    };
  };

  # Security / Sudo
  security.sudo.wheelNeedsPassword = false;

  # Programs
  programs.nix-ld.enable = true;
}
