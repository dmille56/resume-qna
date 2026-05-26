{ lib, config, pkgs, skillPackage }:

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
    home.sessionVariables.PATH = lib.mkAfter [ "${pkgs.poppler}/bin" ];
    home.sessionPath = lib.mkAfter [ "${pkgs.poppler}/bin" ];

    home.activation.resumeQna = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      dest=${lib.escapeShellArg destDir}

      resumePathValue=${lib.escapeShellArg seedPath}
      strictnessValue=${lib.escapeShellArg seedStrictness}

      if [ -e "$dest/config/resume-path.txt" ]; then
        IFS= read -r resumePathValue < "$dest/config/resume-path.txt" || true
      fi

      if [ -e "$dest/config/strictness.txt" ]; then
        IFS= read -r strictnessValue < "$dest/config/strictness.txt" || true
      fi

      if [ -d "$dest" ] && [ ! -w "$dest" ]; then
        rm -rf "$dest"
      fi

      if [ -e "$dest/SKILL.md" ] && [ ! -w "$dest/SKILL.md" ]; then
        rm -f "$dest/SKILL.md"
      fi

      mkdir -p "$dest/config"
      cp ${lib.escapeShellArg "${skillPackage}/share/resume-qna/SKILL.md"} "$dest/SKILL.md"
      chmod u+w "$dest/SKILL.md" 2>/dev/null || true

      printf '%s\n' "$resumePathValue" > "$dest/config/resume-path.txt"
      printf '%s\n' "$strictnessValue" > "$dest/config/strictness.txt"

      chmod u+w "$dest/config/resume-path.txt" 2>/dev/null || true
      chmod u+w "$dest/config/strictness.txt" 2>/dev/null || true
    '';
  };
}
