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

PDF resumes are supported. If you use the Nix modules, `pdftotext` from Poppler is put on PATH automatically.
If you use the shell installer, make sure `pdftotext` is available in `PATH` first.

The skill reads the bundled local config first, then falls back to the installed global copy at `~/.agents/skills/resume-qna/config/resume-path.txt`.

## Configure strictness

Edit:

```bash
~/.agents/skills/resume-qna/config/strictness.txt
```

Use one of `Strict`, `Moderate`, or `Loose`. Default is `Moderate`.

The skill reads the bundled local config first, then falls back to the installed global copy at `~/.agents/skills/resume-qna/config/strictness.txt`.

## Optional job text

You can optionally paste job text directly into the same request when you want the answer tailored to a role.
If you do not have job text, just ask the question normally.
The text is not saved anywhere.

Recommended prompt format:

Example:

```text
Job text: (optional)
<paste the job description here>

Question:
How would my background fit this role?
```

Or, without job text:

```text
Question:
How would my background fit this role?
```

The skill uses pasted job text only as temporary context and still treats your resume as the source of truth.

## Use

- OpenCode loads skills from `.agents/skills`
- Pi loads skills from `.agents/skills`

After install, load `resume-qna` in either agent and ask your question.
