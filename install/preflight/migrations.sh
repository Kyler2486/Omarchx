OMARCHX_MIGRATIONS_STATE_PATH=~/.local/state/Omarchx/migrations
mkdir -p $OMARCHX_MIGRATIONS_STATE_PATH

for file in ~/.local/share/Omarchx/migrations/*.sh; do
  [[ -f "$file" ]] || continue
  touch "$OMARCHX_MIGRATIONS_STATE_PATH/$(basename "$file")"
done
