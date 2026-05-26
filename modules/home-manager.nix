{ lib, config, skillPackage }:

let
  cfg = config.resumeQna;
  destDir = cfg.installDir;
  seedPath = if cfg.resumePath == null then "CHANGE_ME" else cfg.resumePath;
  seedStrictness = cfg.strictness;
in
{
  options.resumeQna = {
    enable = lib.mkEnableOption "resume Q&A skill";

    installDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.agents/skills/resume-qna";
      description = "Directory where the skill is installed.";
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
    home.activation.resumeQna = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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
