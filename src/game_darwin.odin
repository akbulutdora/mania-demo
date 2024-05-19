package game

import "core:path/filepath"
import "core:fmt"
import "core:os"
import "core:strings"

config_dir :: proc() -> (dir: string) {
	dir = os.get_env("HOME", context.temp_allocator)
	if dir != "" {
		dir, _ = strings.concatenate({dir, "/Library/Application Support"}, context.temp_allocator)
	}
	return
}

settings_filename :: proc() -> string {
	filename :: "settings.sjson"
	cd := filepath.clean(config_dir(), context.temp_allocator)
	return fmt.tprint(cd, "cat-and-onion", filename, sep = filepath.SEPARATOR_STRING)
}

savegame_filename :: proc() -> string {
	filename :: "saved_game.sjson"
	cd := filepath.clean(config_dir(), context.temp_allocator)
	return fmt.tprint(cd, "cat-and-onion", filename, sep = filepath.SEPARATOR_STRING)
}
