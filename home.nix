{ config, pkgs, unfreePkgs, ... }:
{
  home.packages = [
    pkgs.firefox
    pkgs.chromium
    pkgs.vlc
    unfreePkgs.vscodium-fhs
    unfreePkgs.jetbrains.phpstorm
    pkgs.ripgrep
    pkgs.gnome-tweaks
    pkgs.gnome-boxes
    unfreePkgs.vault-bin
    unfreePkgs.terraform
    pkgs.go_1_23
    pkgs.yubikey-manager
    pkgs.libreoffice-fresh
    pkgs.php84
    pkgs.dig
    pkgs.rdap
    pkgs.whois
    pkgs.jq
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

  programs.bash = {
    enable = true;
    initExtra = ''

    '';
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        identityAgent = "/run/user/1000/yubikey-agent/yubikey-agent.sock";
        identityFile = "/home/tgerbet/.ssh/yubikey-agent.pub";
      };
    };
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Thomas Gerbet";
    userEmail = "thomas.gerbet@enalean.com";
    signing = {
      format = "ssh";
      key = "/home/tgerbet/.ssh/yubikey.pub";
    };
    extraConfig = {
      push.default = "simple";
    };
    lfs.enable = true;
    difftastic = {
      enable = true;
      background = "dark";
      display = "inline";
    };
  };

  programs.mergiraf.enable = true;

  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
    ];
    daemon.enable = true;
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

  home.stateVersion = "25.05";
}
