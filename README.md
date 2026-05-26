# Resume Q&A Skill

Standalone flake installer for an AI skill that answers questions from a resume.

## Install

```bash
nix run .#install
```

## Configure

Edit the installed file:

```bash
~/.agents/skills/resume-qna/config/resume-path.txt
```

Put the path to your resume there.

## Use

- OpenCode loads skills from `.agents/skills`
- Pi loads skills from `.agents/skills`

After install, load `resume-qna` in either agent and ask your question.
