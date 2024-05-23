// This file is compiled as part of the `odin.dll` file. It contains the
// procs that `game.exe` will call, such as:
//
// game_init: Sets up the game state
// game_update: Run once per frame
// game_shutdown: Shuts down game and frees memory
// game_memory: Run just before a hot reload, so game.exe has a pointer to the
//		game's memory.
// game_hot_reloaded: Run after a hot reload so that the `g_mem` global variable
//		can be set to whatever pointer it was in the old DLL.

package game

import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:slice"
import "core:time"

import rl "vendor:raylib"

PixelWindowHeight :: 180

BASE_PATH :: "./"
ASSET_PATH :: BASE_PATH + "assets/"
LEVELS_PATH :: BASE_PATH + "levels/"

GameMemory :: struct {
	player_pos:                         rl.Vector2,
	player_vel:                         rl.Vector2,
	player_grounded:                    bool,
	player_flip:                        bool,
	current_anim:                       Animation,
	player_idle:                        Animation,
	player_run:                         Animation,
	platform_texture:                   rl.Texture2D,
	level:                              Level,
	level_name:                         LevelName,
	next_level_name:                    LevelName,
	load_next_level:                    bool,
	editing:                            bool,
	debug_draw:                         bool,
	clear_color:                        rl.Color,
	font:                               rl.Font,
	font_bold:                          rl.Font,
	dialogue_font:                      rl.Font,
	had_active_interactions_this_frame: bool,
	pixel_filter_shader:                rl.Shader,
	run:                                bool,
	selected_action:                    int,
	disable_interaction_until:          f64,
	disable_input_until:                f64,
	last_saved_at:                      time.Time,
	hide_hud:                           bool,
	time:                               f64,
	show_fps:                           bool,
	camera_rect:                        Rect,
	profiling:                          bool,
	drawables:                          DrawableArray,
}

animation_draw :: proc(a: Animation, pos: rl.Vector2, flip: bool) {
	width := f32(a.texture.width)
	height := f32(a.texture.height)

	source := rl.Rectangle {
		x      = f32(a.current_frame) * width / f32(a.num_frames),
		y      = 0,
		width  = width / f32(a.num_frames),
		height = height,
	}

	if flip {
		source.width = -source.width
	}

	dest := rl.Rectangle {
		x      = pos.x,
		y      = pos.y,
		width  = width / f32(a.num_frames),
		height = height,
	}

	draw_texture(a.texture, source, dest, pos)
}

platform_collider :: proc(pos: rl.Vector2) -> rl.Rectangle {
	return {pos.x, pos.y, 96, 16}
}

Animation_Name :: enum {
	Idle,
	Run,
}

Level :: struct {
	platforms: [dynamic]rl.Vector2,
}

UID :: distinct u128

LevelName :: enum {
	IntroDream,
	Planet,
	House,
	Space,
	SpaceHouse,
	PancakeBatterLand,
	MainMenu,
}

@(private = "file")
g_mem: ^GameMemory

game_camera :: proc() -> rl.Camera2D {
	w := f32(rl.GetScreenWidth())
	h := f32(rl.GetScreenHeight())

	return {zoom = h / PixelWindowHeight, target = g_mem.player_pos, offset = {w / 2, h / 2}}
}

ui_camera :: proc() -> rl.Camera2D {
	return {zoom = f32(rl.GetScreenHeight()) / PixelWindowHeight}
}

update :: proc() {
	using g_mem
	drawables_reset()

	if rl.IsKeyDown(.A) {
		player_vel.x = -100
		player_flip = true

		if current_anim.name != .Run {
			current_anim = player_run
		}
	} else if rl.IsKeyDown(.D) {
		player_vel.x = 100
		player_flip = false

		if current_anim.name != .Run {
			current_anim = player_run
		}
	} else {
		player_vel.x = 0

		if current_anim.name != .Idle {
			current_anim = player_idle
		}
	}

	player_vel.y += 1000 * rl.GetFrameTime()

	if player_grounded && rl.IsKeyPressed(.SPACE) {
		player_vel.y = -300
	}

	player_pos += player_vel * rl.GetFrameTime()

	player_feet_collider := rl.Rectangle{player_pos.x - 4, player_pos.y - 4, 8, 4}

	player_grounded = false

	for platform in level.platforms {
		if rl.CheckCollisionRecs(player_feet_collider, platform_collider(platform)) &&
		   player_vel.y > 0 {
			player_vel.y = 0
			player_pos.y = platform.y
			player_grounded = true
		}
	}

	animation_update(&current_anim, rl.GetFrameTime())
}

draw :: proc() {
	using g_mem

	rl.ClearBackground({110, 184, 168, 255})

	rl.BeginMode2D(game_camera())
	animation_draw(current_anim, player_pos, player_flip)

	for platform in level.platforms {
		draw_texture(platform_texture, platform)
	}

	all_drawables := drawables_slice()

	slice.sort_by(all_drawables, proc(i, j: Drawable) -> bool {
		iy, jy: f32

		switch d in i {
		case DrawableTexture:
			iy = d.pos.y
		case DrawableRect:

		}
		switch d in y {
		case DrawableTexture:
			j = d.pos.y
		case DrawableRect:

		}
		return iy < jy
	})

	for drawable in all_drawables {
		switch d in drawable {
		case DrawableTexture:
			if d.source.width == 0 || d.source.height == 0 {
				rl.DrawTextureV(d.tex, d.pos, rl.WHITE)
			} else if d.dest.width == 0 || d.dest.height == 0 {
				rl.DrawTextureRec(d.tex, d.source, d.pos, rl.WHITE)
			} else {
				rl.DrawTexturePro(
					d.tex,
					d.source,
					d.dest,
					{d.dest.width / 2, d.dest.height},
					0,
					rl.WHITE,
				)
			}
		case DrawableRect:
		// rl.DrawTextureRec(d.tex, d.source, d.pos, rl.WHITE)
		}
	}

	rl.EndMode2D()

	rl.BeginMode2D(ui_camera())
	rl.DrawText(fmt.ctprintf("player_pos: %v", g_mem.player_pos), 5, 5, 8, rl.WHITE)
	rl.EndMode2D()
}

@(export)
game_update :: proc() -> bool {
	if rl.IsKeyPressed(.F2) {
		g_mem.editing = !g_mem.editing
	}

	rl.BeginDrawing()
	// rl.BeginShaderMode(g_mem.pixel_filter_shader)
	// rl.BeginBlendMode(.ALPHA_PREMULTIPLY)

	if g_mem.editing {
		editor_update()
	} else {
		update()
	}

	if g_mem.editing {
		editor_draw()
	} else {
		draw()
	}

	// rl.EndBlendMode()
	// rl.EndShaderMode()
	rl.EndDrawing()

	return !rl.WindowShouldClose()
}

@(export)
game_init_window :: proc() {
	rl.SetConfigFlags({.WINDOW_RESIZABLE})
	rl.InitWindow(1280, 720, "Odin + Raylib + Hot Reload template!")
	// rl.SetWindowPosition(200, 200)
	rl.SetTargetFPS(500)
}

@(export)
game_init :: proc() {
	g_mem = new(GameMemory)

	g_mem^ = GameMemory{}

	{
		using g_mem
		player_run = Animation {
			texture      = rl.LoadTexture(ASSET_PATH + "player_run.png"),
			num_frames   = 6,
			frame_length = 0.1,
			name         = .Run,
		}

		player_idle = Animation {
			texture      = rl.LoadTexture(ASSET_PATH + "player_idle.png"),
			num_frames   = 1,
			frame_length = 0.5,
			name         = .Idle,
		}

		current_anim = player_idle

		if level_data, ok := os.read_entire_file(
			LEVELS_PATH + "level.json",
			context.temp_allocator,
		); ok {
			if json.unmarshal(level_data, &level) != nil {
				append(&level.platforms, rl.Vector2{-20, 20})
			}
		} else {
			append(&level.platforms, rl.Vector2{-20, 20})
		}

		platform_texture = rl.LoadTexture(ASSET_PATH + "platform.png")
		editing = false
	}

	game_hot_reloaded(g_mem)
}

@(export)
game_shutdown :: proc() {
	rl.UnloadTexture(g_mem.player_run.texture)
	rl.UnloadTexture(g_mem.player_idle.texture)
	rl.UnloadTexture(g_mem.platform_texture)

	if level_data, err := json.marshal(g_mem.level, allocator = context.temp_allocator);
	   err == nil {
		os.write_entire_file(LEVELS_PATH + "level.json", level_data)
	}
	delete(g_mem.level.platforms)

	free(g_mem)
	g_mem = nil
}

@(export)
game_shutdown_window :: proc() {
	rl.CloseWindow()
}

@(export)
game_memory :: proc() -> rawptr {
	return g_mem
}

@(export)
game_memory_size :: proc() -> int {
	return size_of(GameMemory)
}

@(export)
game_hot_reloaded :: proc(mem: rawptr) {
	g_mem = (^GameMemory)(mem)
	drawables_init(&g_mem.drawables)
}

@(export)
game_force_reload :: proc() -> bool {
	return rl.IsKeyPressed(.F5)
}

@(export)
game_force_restart :: proc() -> bool {
	return rl.IsKeyPressed(.F6)
}
