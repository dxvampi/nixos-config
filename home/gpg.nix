{ inputs, pkgs, ... }:

let
  bb-auth = inputs.bb-auth.packages.${pkgs.system}.default;
in
{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
  };

  systemd.user.services.bb-auth = {
    Unit = {
      Description = "BB Auth - Unified Authentication Agent";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStartPre = "${bb-auth}/libexec/bb-auth-bootstrap";
      ExecStart = "${bb-auth}/libexec/bb-auth --daemon";
      Restart = "on-failure";
      TimeoutStopSec = 5;
      Slice = "session.slice";

      PrivateTmp = true;
      ProtectSystem = "strict";
      NoNewPrivileges = true;
      CapabilityBoundingSet = "";
      SystemCallFilter = "@system-service";
      SystemCallArchitectures = "native";
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
