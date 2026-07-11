{ pkgs, ... }: {
  nix = {
    channel.enable = false;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
    settings = {
      auto-optimise-store = pkgs.stdenv.hostPlatform.isLinux;
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://yuys13.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "yuys13.cachix.org-1:t6ghTZgSjyY/d4310E7ZxICuAAOLWjY4bWEdcVw7sl8="
      ];
      trusted-users = [
        "root"
        "@wheel"
      ]
      ++ pkgs.lib.optional pkgs.stdenv.hostPlatform.isDarwin "@admin";
      warn-dirty = false;
    };
  };
}
