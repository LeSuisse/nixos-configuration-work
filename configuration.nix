{ config, pkgs, unstablePkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.bootspec.enable = true;

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  hardware.enableRedistributableFirmware = true;

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev";
  boot.kernelParams = [
    "nohibernate"
    # Enable page allocator randomization
    "page_alloc.shuffle=1"
    # Don't merge slabs
    "slab_nomerge"
    # Disable debugfs
    "debugfs=off"
  ];

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
  networking.hostName = "ENA-LAP-00068";
  time.timeZone = "Europe/Paris";

  security.protectKernelImage = true;
  boot.kernel.sysctl = {
    # No need for Magic SysRq keys
    "kernel.sysrq" = 0;
    # Hide kptrs even for processes with CAP_SYSLOG
    "kernel.kptr_restrict" = 2;
    # Disable ftrace debugging
    "kernel.ftrace_enabled" = false;
    # Ignore broadcast ICMP (mitigate SMURF)
    "net.ipv4.icmp_echo_ignore_broadcasts" = false;
    # Ignore outgoing ICMP redirects
    "net.ipv4.conf.all.send_redirects" = false;
    "net.ipv4.conf.default.send_redirects" = false;
    # Refuse ICMP redirects (MITM mitigations)
    "net.ipv4.conf.all.accept_redirects" = false;
    "net.ipv4.conf.default.accept_redirects" = false;
    "net.ipv4.conf.all.secure_redirects" = false;
    "net.ipv4.conf.default.secure_redirects" = false;
    "net.ipv6.conf.all.accept_redirects" = false;
    "net.ipv6.conf.default.accept_redirects" = false;
    # Swap on zram optimization
    "vm.page-cluster" = 0;
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
  };
  # See https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix#L52
  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"
    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "hfs"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "ntfs"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "displaylink"
  ];

  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr";

  services.xserver = {
    enable = true;
    layout = "fr";
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
    pkgs.gnome.gnome-contacts
    pkgs.gnome.yelp
    pkgs.gnome.gnome-contacts
    pkgs.gnome.gnome-initial-setup
    pkgs.gnome.gnome-calendar
    pkgs.gnome.gnome-logs
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
      hashedPasswordFile = "/persist/passwords/tgerbet";
      group = "tgerbet";
      extraGroups = [ "wheel" "docker" ];
    };
  };

  security.pam.u2f = {
    enable = true;
    authFile = pkgs.writeText "u2f_mappings"
      ''
      tgerbet:dtYze5ynmnANz+CGvDDmwEXds8ETNwrN3Z4fdv7W5HeQrzHnzydaEAvHXuHRWbZjwypbj/Ossr+rNUR2/ho8Ww==,WeNoJdnRloZPBjBKc11j1Y4Y63YqG+BBXG/f6srwtjQXQW7TCR+x/lNKOvyaxnK+W0K6ptHBP6QtlnXqUeysGA==,es256,+presence
      '';
    control = "sufficient";
    cue = true;
  };
  security.pam.services.auth.u2fAuth = true;

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  services.fwupd.enable = true;

  environment.systemPackages = [ pkgs.vim pkgs.htop pkgs.git pkgs.pinentry-gnome ];

  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
    liveRestore = false;
  };

  systemd.enableUnifiedCgroupHierarchy = false;

  services.yubikey-agent = {
    enable = true;
  };
  programs.gnupg.agent.pinentryFlavor = "gnome3";

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

  system.stateVersion = "21.11";

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.auto-optimise-store = true;
  };
  systemd.services.nix-daemon.serviceConfig.LimitNOFILE = lib.mkForce 1048576;
}

