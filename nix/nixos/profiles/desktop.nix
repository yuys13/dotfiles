{ pkgs, ... }: {
  # Networking via NetworkManager
  networking.networkmanager.enable = true;

  # Display and desktop integration
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.gnome.gnome-keyring.enable = true;

  # Fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      font-awesome
      hackgen-nf-font
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      source-han-sans
      source-han-serif
    ];
  };
}
