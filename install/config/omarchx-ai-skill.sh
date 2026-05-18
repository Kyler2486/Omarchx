# Place in each assistant's global skills directory so the Omarchx skill is available on first install
mkdir -p ~/.agents/skills ~/.claude/skills ~/.codex/skills ~/.pi/agent/skills
ln -sfn "$OMARCHX_PATH/default/omarchx-skill" ~/.agents/skills/omarchx
ln -sfn "$OMARCHX_PATH/default/omarchx-skill" ~/.claude/skills/omarchx
ln -sfn "$OMARCHX_PATH/default/omarchx-skill" ~/.codex/skills/omarchx
ln -sfn "$OMARCHX_PATH/default/omarchx-skill" ~/.pi/agent/skills/omarchx
