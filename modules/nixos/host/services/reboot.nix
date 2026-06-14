{ config, lib, ... }:
{
  options.schedule = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    example = "mon *-*-* 02:00:00";
    description = "Schedule a reboot to occur regularily at the configured time";
  };

  config.nativeModule = lib.mkIf (config.schedule != null) (
    args:
    let
      useKexec = args.config.boot.kexec.enable;
      Unit = if useKexec then "systemd-kexec.service" else "systemd-reboot.service";
    in
    {
      systemd.timers.reboot = {
        timerConfig = {
          inherit Unit;
          OnCalendar = config.schedule;
        };
        wantedBy = [ "timers.target" ];
      };
    }
  );
}
