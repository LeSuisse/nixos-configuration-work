{ config, pkgs, unfreePkgs, ... }:
{
  home.packages = [
    (pkgs.symlinkJoin {
      name = "firefox";
      paths = [ pkgs.firefox-wayland ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/firefox --set GTK_THEME Adwaita:light
      '';
    })
    pkgs.chromium
    pkgs.vlc
    unfreePkgs.vscode-fhs
    (unfreePkgs.jetbrains.phpstorm.overrideAttrs (old: rec {
      name = "phpstorm-${version}";
      version = "2022.3";
      src = pkgs.fetchurl {
        url = "https://download.jetbrains.com/webide/PhpStorm-${version}.tar.gz";
        sha256 = "sha256-91+eg58SCqbwJtLDikxRH9K46TfQcdE40Io+FFGJWa4=";
      };
    }))
    unfreePkgs.jetbrains.goland
    pkgs.ripgrep
    pkgs.gnome.gnome-tweaks
    pkgs.vault
    pkgs.terraform
    pkgs.go_1_19
    pkgs.yubikey-manager
    pkgs.fwupd
    pkgs.libreoffice-fresh
    pkgs.php81
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

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
  };

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/calculator" = {
      button-mode = "programming";
    };
  };

  home.stateVersion = "21.11";
}
