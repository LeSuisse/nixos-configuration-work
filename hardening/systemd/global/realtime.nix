{ lib, config, ... }:
let
  inherit (lib) mkDefault types;
in
{
  options.systemd.services = lib.mkOption {
    type =
      let
        osConfig = config;
      in
      types.attrsOf (
        lib.types.submodule {
          config.serviceConfig = {
            RestrictRealtime = mkDefault true;
          };
        }

      );
  };

  config = {
    systemd.services = {
      rtkit-daemon.serviceConfig.RestrictRealtime = false;
    };
  };
}
