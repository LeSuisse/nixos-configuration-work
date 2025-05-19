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
              ProtectHostname = lib.mkDefault true;
            };
          }
        )
      );
  };

  config = {
    systemd.services = {
      systemd-hostnamed.serviceConfig.ProtectHostname = false;
      nix-daemon.serviceConfig.ProtectHostname = false;
      docker.serviceConfig.ProtectHostname = false;
    };
  };
}
