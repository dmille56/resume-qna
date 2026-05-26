{
  description = "Resume Q&A skill for OpenCode and Pi";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));

      mkSkill = pkgs:
        pkgs.runCommand "resume-qna-skill" { } ''
          mkdir -p "$out/share/resume-qna"
          cp -R ${./skill-source/resume-qna}/. "$out/share/resume-qna/"
        '';

      mkInstaller = pkgs: skill:
        pkgs.writeShellApplication {
          name = "install-resume-qna";
          runtimeInputs = [ pkgs.coreutils ];
          text = ''
            set -eu

            dest="$HOME/.agents/skills/resume-qna"
            mkdir -p "$dest"
            cp "${skill}/share/resume-qna/SKILL.md" "$dest/SKILL.md"
            mkdir -p "$dest/config"

            if [ ! -e "$dest/config/resume-path.txt" ]; then
              cp "${skill}/share/resume-qna/config/resume-path.txt" "$dest/config/resume-path.txt"
            fi

            if [ ! -e "$dest/config/strictness.txt" ]; then
              cp "${skill}/share/resume-qna/config/strictness.txt" "$dest/config/strictness.txt"
            fi

            chmod u+w "$dest/config/resume-path.txt" 2>/dev/null || true
            chmod u+w "$dest/config/strictness.txt" 2>/dev/null || true

            printf '%s\n' "Installed resume-qna to $dest"
            printf '%s\n' "Edit $dest/config/resume-path.txt to point at your resume."
            printf '%s\n' "Edit $dest/config/strictness.txt to set the answer strictness."
          '';
        };
    in
    {
      packages = forAllSystems (pkgs: let skill = mkSkill pkgs; in {
        default = skill;
        resume-qna = skill;
      });

      apps = forAllSystems (pkgs: let
        skill = mkSkill pkgs;
        installer = mkInstaller pkgs skill;
      in {
        default = {
          type = "app";
          program = "${installer}/bin/install-resume-qna";
        };
        install = {
          type = "app";
          program = "${installer}/bin/install-resume-qna";
        };
      });

      homeManagerModules = {
        resume-qna = args@{ pkgs, ... }: import ./modules/home-manager.nix (args // {
          skillPackage = self.packages.${pkgs.system}.resume-qna;
        });
      };

      nixosModules = {
        resume-qna = args@{ pkgs, ... }: import ./modules/nixos.nix (args // {
          skillPackage = self.packages.${pkgs.system}.resume-qna;
        });
      };

      formatter = forAllSystems (pkgs: pkgs.alejandra);
    };
}
