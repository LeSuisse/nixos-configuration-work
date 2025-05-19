{ lib, config, ... }:
let
  inherit (lib) types mkIf mkDefault;
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
            RestrictSUIDSGID = lib.mkDefault true;
          };
        }

      );
  };

  config = {
    systemd.services = {
      suid-sgid-wrappers.serviceConfig.RestrictSUIDSGID = false;
    };
  };
}
