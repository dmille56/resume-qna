#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SOURCE_DIR="$ROOT_DIR/skill-source/resume-qna"
TARGET_DIR="$HOME/.agents/skills/resume-qna"

mkdir -p "$TARGET_DIR/config"
cp "$SOURCE_DIR/SKILL.md" "$TARGET_DIR/SKILL.md"
cp "$SOURCE_DIR/config/resume-path.txt" "$TARGET_DIR/config/resume-path.txt"
