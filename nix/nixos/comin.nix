{
  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/yuys13/dotfiles.git";
        branches.main.name = "main";
      }
    ];
  };
}
