{ pkgs, ... }: {
  imports = [
    ../nix.nix
  ];
  environment = {
    systemPackages = with pkgs; [
      nh
    ];
    variables = {
      NH_SHOW_ACTIVATION_LOGS = "1";
    };
  };
}
