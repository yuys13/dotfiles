{ config, lib, ... }: {
  options.profiles.headless.enable = lib.mkEnableOption "headless profile";

  config = lib.mkIf config.profiles.headless.enable {
    networking.useNetworkd = true;
  };
}
