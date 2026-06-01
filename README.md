# claude-skills-public

Mirror of reusable Claude Code skills (`~/.claude/skills`, `visibility: public`). Methodology and best-practices, no org secrets.

- **Source of truth** = `~/.claude/skills/<name>/`. Auto-synced by the `skills-git-push.sh` hook. Don't edit here directly.
- **Routing**: a skill lands here when its `SKILL.md` frontmatter has `visibility: public`. A secret-scan blocks any push that contains a credential.
