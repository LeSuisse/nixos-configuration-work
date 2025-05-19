{ lib, config, ... }:
{
  options.systemd.services = lib.mkOption {
    type =
      let
        osConfig = config;
      in
      lib.types.attrsOf (
        lib.types.submodule (
          { config, name, ... }:
          {
            config.serviceConfig = {
              ProtectClock = lib.mkDefault true;
            };
          }
        )
      );
  };

  config = {
    systemd.services = {
      systemd-timesyncd.serviceConfig = {
        ProtectClock = false;
        SystemCallFilter = "@system-service @clock";
      };

      save-hwclock.serviceConfig = {
        ProtectClock = false;
        SystemCallFilter = "@system-service @clock";
      };
    };
  };
}
