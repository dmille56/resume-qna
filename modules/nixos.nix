{ lib, config, pkgs, skillPackage }:

let
  cfg = config.resumeQna;
  homeDir = if cfg.homeDirectory != null then cfg.homeDirectory else config.users.users.${cfg.user}.home;
  destDir = if cfg.installDir != null then cfg.installDir else "${homeDir}/.agents/skills/resume-qna";
  seedPath = if cfg.resumePath == null then "CHANGE_ME" else cfg.resumePath;
  seedStrictness = cfg.strictness;
in
{
  options.resumeQna = {
    enable = lib.mkEnableOption "resume Q&A skill";

    user = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "NixOS user account that should receive the skill.";
    };

    homeDirectory = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Override the target user's home directory.";
    };

    installDir = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Override the installation directory for the skill.";
    };

    resumePath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Initial resume path written to config/resume-path.txt if it does not already exist.";
    };

    strictness = lib.mkOption {
      type = lib.types.enum [ "Strict" "Moderate" "Loose" ];
      default = "Moderate";
      description = "Initial strictness written to config/strictness.txt if it does not already exist.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.user != "" || cfg.homeDirectory != null;
        message = "resumeQna.user or resumeQna.homeDirectory must be set for the NixOS module.";
      }
    ];

    system.activationScripts.resumeQna.text = ''
      dest=${lib.escapeShellArg destDir}
      mkdir -p "$dest/config"
      cp ${lib.escapeShellArg "${skillPackage}/share/resume-qna/SKILL.md"} "$dest/SKILL.md"

      if [ ! -e "$dest/config/resume-path.txt" ] || [ "$(cat "$dest/config/resume-path.txt")" = "CHANGE_ME" ]; then
        printf '%s\n' ${lib.escapeShellArg seedPath} > "$dest/config/resume-path.txt"
      fi

      if [ ! -e "$dest/config/strictness.txt" ]; then
        printf '%s\n' ${lib.escapeShellArg seedStrictness} > "$dest/config/strictness.txt"
      fi

      chmod u+w "$dest/config/resume-path.txt" 2>/dev/null || true
      chmod u+w "$dest/config/strictness.txt" 2>/dev/null || true
    '';
  };
}
