{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.enableRedistributableFirmware = true;

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev";
  boot.kernelParams = [ "nohibernate" ];

  boot.initrd.postDeviceCommands = lib.mkAfter ''
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
  networking.hostName = "work";
  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr";

  services.xserver.enable = true;
  services.xserver.layout = "fr";

  services.xserver.displayManager.gdm = {
    enable = true;
    autoSuspend = false;
  };
  services.xserver.desktopManager.gnome.enable = true;
  
  environment.gnome.excludePackages = [
    pkgs.gnome.cheese
    pkgs.gnome-photos
    pkgs.gnome.gnome-music
    pkgs.gnome.simple-scan
    pkgs.gnome-connections
    pkgs.gnome.gnome-weather
    pkgs.gnome.totem
    pkgs.gnome.tali
    pkgs.gnome.iagno
    pkgs.gnome.hitori
    pkgs.gnome.atomix
    pkgs.gnome-tour
    pkgs.gnome.geary
    pkgs.gnome.gnome-maps
    pkgs.epiphany
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;

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
      passwordFile = "/persist/passwords/tgerbet";
      group = "tgerbet";
      extraGroups = [ "wheel" "docker" ];
    };
  };

  security.pam.u2f = {
    enable = true;
    authFile = pkgs.writeText "u2f_mappings"
      ''
      tgerbet:Tuz5/+zmD12ghZ1sKbGfbTYbTqaX7wh+ezUEWUdjskSFrB4Izr1D1ehfSLlHiU0nBe0diyWtKg9pflCSGmlflQ==,/FfU0Qz/P2NDigZ9Bp2cokR+vkm9PzBA3WjVWVXL9SeAIEpWwrRTOG/PeWwD+62XcysQWBLGXl0VDmTRLb6pmQ==,es256,+presence
      '';
    control = "sufficient";
    cue = true;
  };
  security.pam.services.auth.u2fAuth = true;

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  environment.systemPackages = [ pkgs.vim pkgs.htop pkgs.git pkgs.pinentry ];

  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
    liveRestore = false;
  };

  systemd.enableUnifiedCgroupHierarchy = false;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "tgerbet" ];

  services.yubikey-agent= {
    enable = true;
    package = pkgs.callPackage ./yubikey-agent.nix { };
  };
  programs.gnupg.agent.pinentryFlavor = "gnome3";

  environment.etc = {
    "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
    adjtime.source = "/persist/etc/adjtime";
    NIXOS.source = "/persist/etc/NIXOS";
    machine-id.source = "/persist/etc/machine-id";
  };
  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
  ];
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  networking.extraHosts = ''
    172.18.0.6 tuleap-web.tuleap-aio-dev.docker
  '';

  system.stateVersion = "21.11";

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.auto-optimise-store = true;
  };
}

