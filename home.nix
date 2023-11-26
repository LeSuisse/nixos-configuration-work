{ config, pkgs, unfreePkgs, ... }:
{
  home.packages = [
    pkgs.firefox
    pkgs.chromium
    pkgs.vlc
    unfreePkgs.vscodium-fhs
    unfreePkgs.jetbrains.phpstorm
    pkgs.ripgrep
    pkgs.gnome.gnome-tweaks
    pkgs.vault
    unfreePkgs.terraform
    pkgs.go_1_20
    pkgs.yubikey-manager
    pkgs.libreoffice-fresh
    pkgs.php81
    pkgs.gitFull
    pkgs.dig
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.home-manager.enable = true;
  programs.direnv.enable = true;

  programs.gpg = {
    enable = true;
    settings = {
      no-emit-version = true;
      no-comments = true;
      keyid-format = "0xlong";
      with-fingerprint = true;
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      keyserver-options = "include-revoked";
      personal-cipher-preferences = "AES256 AES192 AES CAST5";
      personal-digest-preferences = "SHA512 SHA384 SHA256 SHA224";
      cert-digest-algo = "SHA512";
      default-preference-list = "SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed";
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  programs.bash = {
    enable = true;
    initExtra = ''

    '';
  };

  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
    ];
  };

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
  };

  dconf.settings = {
    "org/gnome/calculator" = {
      button-mode = "programming";
    };
    "org/gnome/desktop/calendar" = {
      show-weekdate = "true";
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
    "org/gnome/desktop/sound" = {
      event-sounds = "false";
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      mic-mute = [ "<Super>Insert" ];
    };
  };

  home.stateVersion = "21.11";
}
