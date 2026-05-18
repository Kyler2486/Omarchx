echo "Change to openai-codex instead of openai-codex-bin"

if omarchx-pkg-present openai-codex-bin; then
    omarchx-pkg-drop openai-codex-bin
    omarchx-pkg-add openai-codex
fi
