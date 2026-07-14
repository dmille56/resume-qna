# Repository Guide

- This repo is a Nix flake that packages the `resume-qna` skill.
- Main sources of truth: `skill-source/resume-qna/SKILL.md`, `skill-source/resume-qna/config/*`, `modules/*.nix`, `flake.nix`.
- Edit skill behavior in `skill-source/resume-qna/SKILL.md`; edit install/module behavior in `modules/*.nix` and `flake.nix`.
- `skill-source/resume-qna/config/resume-path.txt` and `strictness.txt` are seed defaults, not guaranteed user state.
- `CHANGE_ME` means the resume path is unset.
- The skill reads local config first, then falls back to `~/.agents/skills/resume-qna/config/*`.
- PDF resumes need `pdftotext -layout`; Nix modules add Poppler to PATH, but `install-resume-qna.sh` does not.
- `resumeQna.user` or `resumeQna.homeDirectory` must be set for the NixOS module.
- Install or verify with `nix run .#install` or `./install-resume-qna.sh`.
- Format with `nix fmt`.
- There is no repo-local CI, test runner, or task file in this repository.
