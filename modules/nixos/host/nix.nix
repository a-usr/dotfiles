{
  nativeModule = (
    { pkgs, ... }:
    {
      # OOM configuration:
      systemd = {
        # Create a separate slice for nix-daemon that is
        # memory-managed by the userspace systemd-oomd killer
        slices."nix-daemon".sliceConfig = {
          CPUQuota = "1600%";
          MemoryHigh = "55%";
          MemoryMax = "75%";
          MemorySwapMax = "55%";
          MemoryZSwapMax = "75%";
          # ManagedOOMMemoryPressure = "kill";
          # ManagedOOMMemoryPressureLimit = "50%";
        };
        services."nix-daemon".serviceConfig.Slice = "nix-daemon.slice";

        # If a kernel-level OOM event does occur anyway,
        # strongly prefer killing nix-daemon child processes
        services."nix-daemon".serviceConfig.OOMScoreAdjust = 1000;
      };

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.registry = {
        nixpkgs.to = {
          type = "path";
          path = pkgs.path;
          # hello IFD
          narHash = builtins.readFile (
            pkgs.runCommandLocal "get-nixpkgs-hash" {
              nativeBuildInputs = [ pkgs.nix ];
            } "nix-hash --type sha256 --sri ${pkgs.path} > $out"
          );
        };
      };
    }
  );
}
