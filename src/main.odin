package game

import "core:fmt"
import "core:log"
import "core:mem"
import rl "vendor:raylib"

BASE_PATH :: "./"
ASSET_PATH :: BASE_PATH + "assets/"
LEVELS_PATH :: BASE_PATH + "levels/"

PixelWindowHeight :: 180

Level :: struct {
	platforms: [dynamic]rl.Vector2,
}

platform_collider :: proc(pos: rl.Vector2) -> rl.Rectangle {
	return {pos.x, pos.y, 96, 16}
}

main :: proc() {
	context.logger = log.create_console_logger()

	track: mem.Tracking_Allocator
	mem.tracking_allocator_init(&track, context.allocator)
	context.allocator = mem.tracking_allocator(&track)

	game_init_window()
	game_init(0)

	window_open := true
	for window_open {
		window_open = game_update()
		free_all(context.temp_allocator)
	}

	free_all(context.temp_allocator)
	game_shutdown()

	fmt.printfln("Total of %v entries in the allocation map", len(track.allocation_map))
	for _, entry in track.allocation_map {
		fmt.eprintf("%v leaked %v bytes\n", entry.location, entry.size)
	}

	for entry in track.bad_free_array {
		fmt.eprintf("%v bad free\n", entry.location)
	}

	game_shutdown_window()
	mem.tracking_allocator_destroy(&track)
}
