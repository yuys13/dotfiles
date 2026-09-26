{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../core
    inputs.home-manager.darwinModules.home-manager
  ];

  # User Configuration
  users.users.${config.mainUser} = {
    name = config.mainUser;
    home = "/Users/${config.mainUser}";
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
}
