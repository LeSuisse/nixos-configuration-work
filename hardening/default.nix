{
  ...
}:
{
  imports = [
    ./systemd
    ./usbguard.nix
  ];

  boot.kernelParams = [
    "nohibernate"
    # Enable page allocator randomization
    "page_alloc.shuffle=1"
    # Don't merge slabs
    "slab_nomerge"
    # Disable debugfs
    "debugfs=off"
  ];
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
}
