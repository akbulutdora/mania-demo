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
	// cat:                                EntityHandle,
	// rocket:                             EntityHandle,
	// next_controlled_entity:             EntityHandle,
	// controlled_entity:                  EntityHandle,

	// world: World,
	// serialized_state: SerializedState,

	// asset_storage: AssetStorage,
	editing:                            bool,
	// editor_memory: EditorMemory,

	// camera_state: CameraState,
	debug_draw:                         bool,
	clear_color:                        rl.Color,
	font:                               rl.Font,
	font_bold:                          rl.Font,
	dialogue_font:                      rl.Font,

	// tileset: TextureHandle,

	// to_render: [dynamic]Renderable,
	// text_to_render: [dynamic]RenderText,

	// tileset_padded: rl.Texture,

	// talk_icon: TextureHandle,
	// talk_bg_arrow: TextureHandle,

	// interactable_in_range: EntityHandle,
	// active_interactions: [dynamic]Interaction,
	had_active_interactions_this_frame: bool,

	// progress: bit_set[ProgressFlag],

	// delayed_events: [dynamic]DelayedEvent,
	// next_events: [dynamic]Event,
	// events: []Event,
	pixel_filter_shader:                rl.Shader,
	run:                                bool,

	// inventory: Inventory,
	selected_action:                    int,

	// game_state: GameState,
	// root_state: RootState,

	// settings: Settings,

	// music: MusicState,
	disable_interaction_until:          f64,
	disable_input_until:                f64,

	// show_portrait: Maybe(Portrait),

	// save: SavedGame,
	last_saved_at:                      time.Time,
	hide_hud:                           bool,

	// We render into this tex to keep AR at 16:9
	// main_drawing_tex: rl.RenderTexture2D,

	// This time only counts up when update_default() is run... so it doesnt increase while paused etc
	time:                               f64,

	// sound_state: SoundState,

	// spall_ctx: spall.Context,
	// spall_buffer: spall.Buffer,
	show_fps:                           bool,
	camera_rect:                        Rect,
	profiling:                          bool,
}

// EntityHandle :: distinct Handle

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

	rl.DrawTexturePro(a.texture, source, dest, {dest.width / 2, dest.height}, 0, rl.WHITE)
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

g_mem: ^GameMemory

game_camera :: proc() -> rl.Camera2D {
	screen_height := f32(rl.GetScreenHeight())

	return(
		rl.Camera2D {
			zoom = screen_height / PixelWindowHeight,
			offset = {f32(rl.GetScreenWidth() / 2), screen_height / 2},
			target = g_mem.player_pos,
		} \
	)
	// w := f32(rl.GetScreenWidth())
	// h := f32(rl.GetScreenHeight())

	// return {zoom = h / PixelWindowHeight, target = g_mem.player_pos, offset = {w / 2, h / 2}}
}

ui_camera :: proc() -> rl.Camera2D {
	return {zoom = f32(rl.GetScreenHeight()) / PixelWindowHeight}
}

update :: proc() {
	using g_mem
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

	rl.BeginDrawing()
	rl.ClearBackground({110, 184, 168, 255})

	camera := game_camera()

	rl.BeginMode2D(game_camera())

	animation_draw(current_anim, player_pos, player_flip)
	for platform in level.platforms {
		rl.DrawTextureV(platform_texture, platform, rl.WHITE)
	}

	if rl.IsKeyPressed(.F2) {
		editing = !editing
	}

	if editing {
		mp := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera)

		rl.DrawTextureV(platform_texture, mp, rl.WHITE)

		if rl.IsMouseButtonPressed(.LEFT) {
			append(&level.platforms, mp)
		}

		if rl.IsMouseButtonPressed(.RIGHT) {
			for p, idx in level.platforms {
				if (rl.CheckCollisionPointRec(mp, platform_collider(p))) {
					unordered_remove(&level.platforms, idx)
					break
				}
			}
		}
	}

	rl.EndMode2D()

	rl.BeginMode2D(ui_camera())
	rl.DrawText(fmt.ctprintf("player_pos: %v", g_mem.player_pos), 5, 5, 8, rl.WHITE)
	rl.EndMode2D()

	rl.EndDrawing()
}

@(export)
game_update :: proc() -> bool {
	update()
	draw()
	return !rl.WindowShouldClose()
}

@(export)
game_init_window :: proc() {
	rl.SetConfigFlags({.WINDOW_RESIZABLE})
	rl.InitWindow(1280, 720, "Odin + Raylib + Hot Reload template!")
	rl.SetWindowPosition(200, 200)
	rl.SetTargetFPS(500)
}

@(export)
game_init :: proc() {
	g_mem = new(GameMemory)

	g_mem^ = GameMemory{}

	{
		using g_mem
		player_run = Animation {
			texture      = rl.LoadTexture(ASSET_PATH + "cat_run.png"),
			num_frames   = 4,
			frame_length = 0.1,
			name         = .Run,
		}

		player_idle = Animation {
			texture      = rl.LoadTexture(ASSET_PATH + "cat_idle.png"),
			num_frames   = 2,
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
	using g_mem

	if level_data, err := json.marshal(level, allocator = context.temp_allocator); err == nil {
		os.write_entire_file(LEVELS_PATH + "level.json", level_data)
	}
	delete(level.platforms)

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
}

@(export)
game_force_reload :: proc() -> bool {
	return rl.IsKeyPressed(.F5)
}

@(export)
game_force_restart :: proc() -> bool {
	return rl.IsKeyPressed(.F6)
}
