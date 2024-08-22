{ config, pkgs, pkgs-stable, pkgs-unstable, hyprland-flake, ... }:

{
  programs.hyprland = {
    enable = true;
    package = hyprland-flake.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    #package = pkgs-unstable.hyprland;
    xwayland.enable = true;
  };

  environment.sessionVariables = {

    # XDG_CURRENT_DESKTOP = "Hyprland";
    # XDG_SESSION_DESKTOP = "Hyprland";
    # XDG_SESSION_TYPE = "wayland";
    GTK_USE_PORTAL = 1;
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    # QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    # MOZ_ENABLE_WAYLAND = "0";
    
    GDK_BACKEND = "wayland,x11,*";
    SDL_VIDEODRIVER = "wayland,x11,windows";
    CLUTTER_BACKEND = "wayland,x11,*";
    OZONE_PLATFORM = "wayland";

    GBM_BACKEND = "nvidia-drm";
    GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  fonts.packages = with pkgs-stable; [
      font-awesome
      meslo-lgs-nf
  ];

  environment.systemPackages = with pkgs-unstable; [
    rofi-wayland
    libsForQt5.polkit-kde-agent
    wl-clipboard
    cliphist
    hyprpicker
    hyprshot
    hyprpaper
    dbus

    kdePackages.kwallet
    kdePackages.kwallet-pam
    kdePackages.kwalletmanager

    lxqt.pavucontrol-qt
    playerctl
    eww
    # wezterm
    catppuccin-kvantum
    mako
    #dunst

    # QT Themeing
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct

    kdePackages.qt6ct
    kdePackages.qtstyleplugin-kvantum

    libsForQt5.kio-extras

    libsForQt5.qt5.qtsvg
    kdePackages.qtsvg
    libsForQt5.qt5.qtwayland
    kdePackages.qtwayland
    tela-icon-theme
  ];

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-kde
      ];
      config = {
        hyprland = {
          # default = [ "hyprland" "kde" ];
          default = [ "kde" "hyprland" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
          "org.freedesktop.portal.FileChooser" = [ "kde" ];
        };
      };
    };
  };
}
