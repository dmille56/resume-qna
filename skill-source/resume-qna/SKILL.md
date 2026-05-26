---
name: resume-qna
description: Answers questions from a user's resume with concise, natural, hiring-manager-friendly responses. Use when the user asks about their background, experience, fit, or interview prep based on their resume.
compatibility: opencode, pi
metadata:
  resume_path_file: config/resume-path.txt
  strictness_file: config/strictness.txt
---

# Resume Q&A

## Source of truth
- Read the resume path from `config/resume-path.txt` first.
- If that local file is missing, empty, or still contains `CHANGE_ME`, fall back to `~/.agents/skills/resume-qna/config/resume-path.txt`.
- If both are missing, empty, or still contain `CHANGE_ME`, ask the user to set the path before answering.
- The configured resume may be a text file or a PDF.
- Read only the resume content when answering. Do not invent details or rely on memory.

## Strictness
- Read the strictness setting from `config/strictness.txt` first.
- If that local file is missing, empty, or contains an unrecognized value, fall back to `~/.agents/skills/resume-qna/config/strictness.txt`.
- If both are missing, empty, or unrecognized, treat it as `Moderate`.
- Valid values are `Strict`, `Moderate`, and `Loose`.
- `Strict`: only use facts stated directly in the resume. If the resume does not support the answer, say so plainly.
- `Moderate`: stay tightly grounded in the resume, and only make small, clearly supported inferences.
- `Loose`: allow more natural rewriting and synthesis of resume facts, but never add new facts.

## Answer style
- Default to 2-3 sentences.
- Sound human, direct, and not obviously AI-written.
- Keep the tone professional, warm, and relatable to a hiring manager.
- Prefer plain language over buzzwords.
- Use first person when the user is asking as the candidate.
- If the resume does not support a claim, say that briefly and stay factual.

## Response rules
- Be accurate before being polished.
- Do not add achievements, titles, dates, technologies, or outcomes that are not in the resume.
- Match the requested strictness level when deciding how much to infer, condense, or rephrase.
- If the user asks for a longer answer, expand only as much as needed.
- If the question is outside the resume, answer with the closest supported fact and note the gap.

## Workflow
1. Load the configured resume file.
2. If it is a PDF, extract the text with `pdftotext -layout <resume-path> -` before answering.
3. Extract the facts needed to answer the question.
4. Write a concise response that a hiring manager would find credible and easy to read.
