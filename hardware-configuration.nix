{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "tank/system/root";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/1CF8-C538";
      fsType = "vfat";
    };

  fileSystems."/nix" =
    { device = "tank/local/nix";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "tank/user/home";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    { device = "tank/user/persist";
      fsType = "zfs";
      neededForBoot = true;
    };

  fileSystems."/var/lib/docker" =
    { device = "/dev/zvol/tank/local/docker";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  
  fileSystems."/var/lib/docker/volumes" =
    { device = "/dev/zvol/tank/user/docker-volumes";
      fsType = "ext4";
      options = [ "noatime" ];
    };

  #swapDevices =
  #  [ { device = "/dev/disk/by-partuuid/f221bd81-c179-c349-840e-8283c576139a"; randomEncryption.enable = true; }
  #  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
