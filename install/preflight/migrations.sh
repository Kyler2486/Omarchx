for file in ~/.local/OMARCHX_MIGRATIONS_STATE_PATH=~/.local/state/omarchx/migrations
mkdir -p $OMARCHX_MIGRATIONS_STATE_PATH

for file in ~/.local/share/Omarchx/migrations/*.sh; do
  touch "$OMARCHX_MIGRATIONS_STATE_PATH/$(basename "$file")"
doneshare/omarchx/migrations/*.sh; do
