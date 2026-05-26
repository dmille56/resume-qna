# Resume Q&A Skill

Resume Q&A skill for OpenCode and Pi, with both declarative Nix install and a simple non-Nix fallback.

## Nix install

```bash
nix run .#install
```

### Home Manager

```nix
{ inputs, ... }:
{
  imports = [ inputs.resume-qna.homeManagerModules.resume-qna ];

  resumeQna = {
    enable = true;
    resumePath = "/home/you/path/to/resume.pdf";
  };
}
```

### NixOS

```nix
{ inputs, ... }:
{
  imports = [ inputs.resume-qna.nixosModules.resume-qna ];

  resumeQna = {
    enable = true;
    user = "you";
    resumePath = "/home/you/path/to/resume.pdf";
  };
}
```

## Non-Nix install

```bash
./install-resume-qna.sh
```

## Configure the resume path

Edit the installed file:

```bash
~/.agents/skills/resume-qna/config/resume-path.txt
```

Put the path to your resume there.

## Use

- OpenCode loads skills from `.agents/skills`
- Pi loads skills from `.agents/skills`

After install, load `resume-qna` in either agent and ask your question.
