{ config, pkgs, unstablePkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./hardening
    ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.bootspec.enable = true;

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  boot.tmp.cleanOnBoot = true;

  hardware.enableRedistributableFirmware = true;

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev";

  boot.initrd.postResumeCommands = lib.mkAfter ''
    zfs rollback -r tank/system/root@blank
  '';

  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 6;
    hourly = 10;
    daily = 5;
    weekly = 1;
    monthly = 2;
    flags = "-k -p --utc";
  };

  networking.hostId = "1003f3bb";
  networking.hostName = "ENA-LAP-00068";
  time.timeZone = "Europe/Paris";

  boot.kernel.sysctl = {
    # Swap on zram optimization
    "vm.page-cluster" = 0;
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "displaylink"
  ];

  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr";

  services.xserver = {
    enable = true;
    xkb.layout = "fr";
    videoDrivers = [ "displaylink" "modesetting" ];
    displayManager.gdm = {
      enable = true;
      autoSuspend = false;
    };
    desktopManager.gnome.enable = true;
    excludePackages = [
      pkgs.xterm
    ];
  };

  environment.gnome.excludePackages = [
    pkgs.cheese
    pkgs.gnome-photos
    pkgs.gnome-music
    pkgs.simple-scan
    pkgs.gnome-connections
    pkgs.gnome-weather
    pkgs.totem
    pkgs.tali
    pkgs.iagno
    pkgs.hitori
    pkgs.atomix
    pkgs.gnome-tour
    pkgs.geary
    pkgs.gnome-maps
    pkgs.gnome-contacts
    pkgs.yelp
    pkgs.gnome-contacts
    pkgs.gnome-initial-setup
    pkgs.gnome-calendar
    pkgs.gnome-logs
    pkgs.epiphany
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.pulseaudio.enable = false;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gnome ];
  };

  users = {
    mutableUsers = false;
    groups = {
      tgerbet = { gid = 1000; };
    };
    users.tgerbet = {
      isNormalUser = true;
      description = "Thomas Gerbet";
      hashedPasswordFile = "/persist/passwords/tgerbet";
      group = "tgerbet";
      extraGroups = [ "wheel" "docker" ];
    };
  };

  security.pam.u2f = {
    enable = true;
    control = "sufficient";
    settings = {
      authfile = pkgs.writeText "u2f_mappings"
        ''
        tgerbet:MuoDCEJrerjYx28BTsv0FA5QnytTjWP3TJLHYW59GUGpl4DOsueC6cPNufA1IdVDQlZZ/oJrRkU+U/koc9Ituw==,Wy3CPJyT0KSBr33Vv0BBOZBgLprg/lWGmEyVupqIRq1EnfYe0gY0oTiA94FBL3q7XggspqAoGuLo2DGjHtSBRg==,es256,+presence
        '';
      cue = true;
    };
  };
  security.pam.services.auth.u2fAuth = true;

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  services.fwupd.enable = true;

  environment.systemPackages = [ pkgs.vim pkgs.htop pkgs.git ];

  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
    liveRestore = false;
  };

  services.yubikey-agent = {
    enable = true;
  };
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;

  environment.etc = {
    "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
    adjtime.source = "/persist/etc/adjtime";
    NIXOS.source = "/persist/etc/NIXOS";
    machine-id.source = "/persist/etc/machine-id";
    secureboot.source = "/persist/etc/secureboot";
  };
  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
  ];
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  zramSwap.enable = true;

  # CVE-2023-45866
  hardware.bluetooth.input.General.ClassicBondedOnly = true;

  networking.extraHosts = ''
    172.18.0.6 tuleap-web.tuleap-aio-dev.docker
  '';

  services.tailscale = {
    enable = true;
    package = unstablePkgs.tailscale;
    useRoutingFeatures = "client";
  };
  systemd.services.tailscaled.serviceConfig.BindPaths = "/persist/var/lib/tailscale:/var/lib/tailscale";

  system.stateVersion = "25.05";

  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  systemd.services.nix-daemon.serviceConfig.LimitNOFILE = lib.mkForce 1048576;
}

