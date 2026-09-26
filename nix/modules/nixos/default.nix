{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../core
    inputs.home-manager.nixosModules.home-manager
    inputs.comin.nixosModules.comin
    ./comin.nix
    ./profiles/headless.nix
    ./profiles/desktop.nix
  ];

  # User Configuration
  users.users.${config.mainUser} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
  };

  # Home Manager Configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      user = config.mainUser;
    };
  };

  # Boot loader
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Time zone and locale
  time.timeZone = "Asia/Tokyo";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "ja_JP.UTF-8";
      LC_IDENTIFICATION = "ja_JP.UTF-8";
      LC_MEASUREMENT = "ja_JP.UTF-8";
      LC_MONETARY = "ja_JP.UTF-8";
      LC_NAME = "ja_JP.UTF-8";
      LC_NUMERIC = "ja_JP.UTF-8";
      LC_PAPER = "ja_JP.UTF-8";
      LC_TELEPHONE = "ja_JP.UTF-8";
      LC_TIME = "ja_JP.UTF-8";
    };
  };

  # Services
  services = {
    tailscale.enable = true;
  };

  # Packages and Environment
  environment = {
    systemPackages = with pkgs; [
      curl
      git
      vim
    ];
  };

  # Programs
  programs.nix-ld.enable = true;
}
