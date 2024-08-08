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
import "core:log"
import "core:math"
import "core:os"
import "core:prof/spall"
import "core:slice"
import "core:strings"
import "core:time"

import rl "vendor:raylib"

PixelWindowHeight :: 180

DEV_MODE :: #config(DEV_MODE, false)
GameProfile :: #config(GameProfile, false)

BASE_PATH :: "./"
ASSET_PATH :: BASE_PATH + "assets/"
LEVELS_PATH :: BASE_PATH + "levels/"

TilesetWidth :: 4
TileHeight :: 16

dt: f32

PlayerMood :: enum {
	None,
	Angry,
	Sad,
	Hopeful,
}

PlayerHudData :: struct {
	text:  string,
	color: rl.Color,
}

GameMemory :: struct {
	player_pos:          rl.Vector2,
	player_vel:          rl.Vector2,
	player_grounded:     bool,
	player_air_jumped:   bool,
	player_flip:         bool,
	player_current_anim: Animation,
	player_idle:         Animation,
	player_run:          Animation,
	player_mood:         PlayerMood,
	platform_texture:    rl.Texture2D,
	player_hud_data:     PlayerHudData,
	world:               World,
	level:               Level,
	level_name:          LevelName,
	load_next_level:     bool,
	editing:             bool,
	debug_draw:          bool,
	clear_color:         rl.Color,
	font:                rl.Font,
	font_bold:           rl.Font,
	dialogue_font:       rl.Font,
	pixel_filter_shader: rl.Shader,
	run:                 bool,
	last_saved_at:       time.Time,
	drawables:           DrawableArray,
	editor_memory:       EditorMemory,

	// This time only counts up when update_default() is run... so it doesnt increase while paused etc
	time:                f64,
	spall_ctx:           spall.Context,
	spall_buffer:        spall.Buffer,
	show_fps:            bool,
	camera_rect:         Rect,
	profiling:           bool,
}

World :: struct {
	tiles: [dynamic]Tile,
}

Tile :: struct {
	tile_idx: int,
	x:        int,
	y:        int,
	layer:    int,
	flip_x:   bool,
	flip_y:   bool,
}

LevelName :: enum {
	IntroDream,
	Planet,
	House,
	Space,
	SpaceHouse,
	PancakeBatterLand,
	MainMenu,
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
	tiles:     []Tile,
}

@(private = "file")
g_mem: ^GameMemory

font: rl.Font

game_camera :: proc() -> rl.Camera2D {
	w := f32(rl.GetScreenWidth())
	h := f32(rl.GetScreenHeight())

	return {zoom = h / PixelWindowHeight, target = g_mem.player_pos, offset = {w / 2, h / 2}}
}

ui_camera :: proc() -> rl.Camera2D {
	return {zoom = f32(rl.GetScreenHeight()) / PixelWindowHeight}
}

update :: proc() {
	drawables_reset()

	if rl.IsKeyPressed(.F1) {
		g_mem.debug_draw = !g_mem.debug_draw
	}

	if rl.IsKeyPressed(.ONE) {
		g_mem.player_mood = PlayerMood.None
		g_mem.player_hud_data.color = rl.BLACK
		g_mem.player_hud_data.text = ""
	}
	if rl.IsKeyPressed(.TWO) {
		g_mem.player_mood = PlayerMood.Angry
		g_mem.player_hud_data.color = rl.RED
		g_mem.player_hud_data.text = "ANGRY"
	}
	if rl.IsKeyPressed(.THREE) {
		g_mem.player_mood = PlayerMood.Sad
		g_mem.player_hud_data.color = rl.GRAY
		g_mem.player_hud_data.text = "SAD"
	}
	if rl.IsKeyPressed(.FOUR) {
		g_mem.player_mood = PlayerMood.Hopeful
		g_mem.player_hud_data.color = rl.SKYBLUE
		g_mem.player_hud_data.text = "HOPEFUL"
	}

	if rl.IsKeyDown(.A) {
		g_mem.player_vel.x = -100
		g_mem.player_flip = true

		if g_mem.player_current_anim.name != .Run {
			g_mem.player_current_anim = g_mem.player_run
		}
	} else if rl.IsKeyDown(.D) {
		g_mem.player_vel.x = 100
		g_mem.player_flip = false

		if g_mem.player_current_anim.name != .Run {
			g_mem.player_current_anim = g_mem.player_run
		}
	} else {
		g_mem.player_vel.x = 0

		if g_mem.player_current_anim.name != .Idle {
			g_mem.player_current_anim = g_mem.player_idle
		}
	}

	g_mem.player_vel.y += 1000 * rl.GetFrameTime()

	if g_mem.player_grounded && rl.IsKeyPressed(.SPACE) {
		g_mem.player_vel.y = -300
	}

	if g_mem.player_mood == .Hopeful &&
	   rl.IsKeyPressed(.SPACE) &&
	   !g_mem.player_grounded &&
	   !g_mem.player_air_jumped {
		g_mem.player_air_jumped = true
		g_mem.player_vel.y = -300
	}

	if g_mem.player_mood != .None && rl.IsKeyPressed(.E) {
		g_mem.player_mood = .None
		g_mem.player_hud_data.color = rl.BLACK
		g_mem.player_hud_data.text = ""
	}

	g_mem.player_pos += g_mem.player_vel * rl.GetFrameTime()

	player_feet_collider := rl.Rectangle{g_mem.player_pos.x - 4, g_mem.player_pos.y - 4, 8, 4}

	g_mem.player_grounded = false

	for platform in g_mem.level.platforms {
		if rl.CheckCollisionRecs(player_feet_collider, platform_collider(platform)) &&
		   g_mem.player_vel.y > 0 {
			g_mem.player_vel.y = 0
			g_mem.player_pos.y = platform.y
			g_mem.player_grounded = true
			g_mem.player_air_jumped = false
		}
	}

	animation_update(&g_mem.player_current_anim, rl.GetFrameTime())
}

draw :: proc() {
	rl.ClearBackground({110, 184, 168, 255})

	rl.BeginMode2D(game_camera())
	animation_draw(g_mem.player_current_anim, g_mem.player_pos, g_mem.player_flip)

	for platform in g_mem.level.platforms {
		draw_texture(g_mem.platform_texture, platform)
	}

	all_drawables := drawables_slice()

	slice.sort_by(all_drawables, proc(i, j: Drawable) -> bool {
		iy, jy: f32

		switch d in i {
		case DrawableTexture:
			iy = d.pos.y
		case DrawableRect:

		}
		switch d in j {
		case DrawableTexture:
			jy = d.pos.y
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
			if g_mem.debug_draw {
				rl.DrawCircleV(d.pos, 2, rl.YELLOW)
			}
		case DrawableRect:
		// rl.DrawTextureRec(d.tex, d.source, d.pos, rl.WHITE)
		}
	}

	rl.EndMode2D()

	ui_camera := ui_camera()
	rl.BeginMode2D(ui_camera)
	text := strings.clone_to_cstring(g_mem.player_hud_data.text, context.temp_allocator)
	rl.DrawText(text, 10, PixelWindowHeight - 20, 8, g_mem.player_hud_data.color)
	// rl.DrawText(fmt.ctprintf("player_pos: %v", g_mem.player_pos), 5, 5, 8, rl.WHITE)
	rl.EndMode2D()
}

@(export)
game_update :: proc() -> bool {
	if rl.IsKeyPressed(.F2) {
		if (!g_mem.editing) {
			g_mem.editor_memory.clear_color = g_mem.clear_color
			// fmt.printfln(
			// 	"Entering editor mode. Setting editor clear color (%v) to game_mem color: %v",
			// 	g_mem.clear_color,
			// 	g_mem.editor_memory.clear_color,
			// )
		}

		g_mem.editing = !g_mem.editing
	}

	rl.BeginDrawing()
	// rl.BeginShaderMode(g_mem.pixel_filter_shader)
	// rl.BeginBlendMode(.ALPHA_PREMULTIPLY)

	if g_mem.editing {
		edit_mode_update()
	} else {
		update()
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
		g_mem.player_run = Animation {
			texture      = rl.LoadTexture(ASSET_PATH + "player_run.png"),
			num_frames   = 6,
			frame_length = 0.1,
			name         = .Run,
		}

		g_mem.player_idle = Animation {
			texture      = rl.LoadTexture(ASSET_PATH + "player_idle.png"),
			num_frames   = 1,
			frame_length = 0.5,
			name         = .Idle,
		}

		g_mem.player_current_anim = g_mem.player_idle

		if level_data, ok := os.read_entire_file(
			LEVELS_PATH + "level.json",
			context.temp_allocator,
		); ok {
			if json.unmarshal(level_data, &g_mem.level) != nil {
				append(&g_mem.level.platforms, rl.Vector2{-20, 20})
			}
		} else {
			append(&g_mem.level.platforms, rl.Vector2{-20, 20})
		}

		g_mem.platform_texture = rl.LoadTexture(ASSET_PATH + "platform.png")
		g_mem.editing = false

		g_mem.clear_color = rl.SKYBLUE

		editor_refresh_globals(&g_mem.editor_memory)
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
	delete(g_mem.world.tiles)

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

tile_world_rect :: proc(x, y: int) -> Rect {
	return {f32(x * TileHeight), f32(y * TileHeight), TileHeight, TileHeight}
}

tile_tileset_rect :: proc(x, y: int, px, py: int, flip_x: bool, flip_y: bool) -> Rect {
	return {
		f32(x * TileHeight + px * (2 * x + 1)),
		f32(y * TileHeight + py * (2 * y + 1)),
		flip_x ? -TileHeight : TileHeight,
		flip_y ? -TileHeight : TileHeight,
	}
}

mouse_pos :: proc() -> Vec2 {
	mouse_window := rl.GetMousePosition()

	if g_mem.editing {
		return mouse_window
	}

	return mouse_window - screen_top_left()
}

screen_top_left :: proc() -> Vec2 {
	sw :=
		rl.IsWindowFullscreen() ? f32(rl.GetMonitorWidth(rl.GetCurrentMonitor())) : f32(rl.GetScreenWidth())
	sh :=
		rl.IsWindowFullscreen() ? f32(rl.GetMonitorHeight(rl.GetCurrentMonitor())) : f32(rl.GetScreenHeight())

	war := wanted_ar()

	if current_ar() > war {
		h := sw * war
		return {0, sh / 2 - h / 2}
	} else {
		w := sh * (1 / war)
		return {sw / 2 - w / 2, 0}
	}
}

ar_16_9 :: 9.0 / 16.0
ar_16_10 :: 10.0 / 16.0

AspectRatio :: enum {
	AR16_9,
	AR16_10,
}

wanted_ar_id :: proc() -> AspectRatio {
	cur_ar := current_ar()

	diff_16_9 := math.abs(cur_ar - ar_16_9)
	diff_16_10 := math.abs(cur_ar - ar_16_10)

	return diff_16_9 < diff_16_10 ? .AR16_9 : .AR16_10
}


wanted_ar :: proc() -> f32 {
	switch wanted_ar_id() {
	case .AR16_9:
		return ar_16_9
	case .AR16_10:
		return ar_16_10
	}

	return ar_16_9
}

// NOTE: this is the AR of the window, not of the render texture the game is drawn to
current_ar :: proc() -> f32 {
	if rl.IsWindowFullscreen() {
		return(
			f32(rl.GetMonitorHeight(rl.GetCurrentMonitor())) /
			f32(rl.GetMonitorWidth(rl.GetCurrentMonitor())) \
		)
	} else {
		return f32(rl.GetRenderHeight()) / f32(rl.GetRenderWidth())
	}
}

CameraFollowPlayer :: struct {
	camera_offset:            f32,
	camera_offset_lerp_start: f32,
	camera_offset_lerp_end:   f32,
	camera_lerp_t:            f32,
	player_start_pos:         Vec2,
	player_start_pos_set:     bool,
	// player_side:              CameraFollowPlayerSide,
	y_target:                 f32,
	y_start:                  f32,
	y_lerp_t:                 f32,
}

CameraInVolume :: struct {
	// volume:     EntityHandle,
	start:      Vec2,
	start_zoom: f32,
	lerp_t:     f32,
	fit:        bool,
}

CameraLocked :: struct {}

CameraMode :: union #no_nil {
	CameraFollowPlayer,
	CameraInVolume,
	CameraLocked,
}

CameraState :: struct {
	pause_camera_until: f64,
	pos:                Vec2,
	zoom:               f32,
	target_zoom:        f32,
	shake_until:        f64,
	shake_amp:          f32,
	shake_freq:         f32,
	wanted_y:           f32,
	mode:               CameraMode,
}

screen_height :: proc() -> f32 {
	if g_mem.editing {
		return f32(rl.GetScreenHeight())
	}

	// h := f32(g_mem.main_drawing_tex.texture.height) / dpi_scale()
	h: f32

	if h == 0 {
		log.warn("render tex height 0")
		h = 720
	}

	return h
}

screen_width :: proc() -> f32 {
	if g_mem.editing {
		return f32(rl.GetScreenWidth())
	}

	// w := f32(g_mem.main_drawing_tex.texture.width) / dpi_scale()
	w: f32

	if w == 0 {
		log.warn("render tex width 0")
		w = 1280
	}

	return w
}

screen_size :: proc() -> Vec2 {
	return {screen_width(), screen_height()}
}


get_camera_from_state :: proc(cs: CameraState) -> rl.Camera2D {
	shake_offset := Vec2 {
		cs.shake_amp * f32(math.cos((g_mem.time + 10) * f64(cs.shake_freq))),
		cs.shake_amp * f32(math.sin(g_mem.time * f64(cs.shake_freq))),
	}

	return rl.Camera2D{target = cs.pos + shake_offset, offset = screen_size() / 2, zoom = cs.zoom}
}

get_camera_from_pos_zoom :: proc(pos: Vec2, zoom: f32) -> rl.Camera2D {
	return rl.Camera2D{target = pos, offset = screen_size() / 2, zoom = zoom}
}

get_camera :: proc {
	get_camera_from_state,
	get_camera_from_pos_zoom,
}

default_game_camera_zoom :: proc() -> f32 {
	return screen_height() / PixelWindowHeight
}

dpi_scale :: proc() -> f32 {
	when DEV_MODE {
		return rl.GetWindowScaleDPI().x
	} else {
		return 1
	}
}

rect_from_pos_size :: proc(p: Vec2, s: Vec2) -> rl.Rectangle {
	return rl.Rectangle{p.x, p.y, s.x, s.y}
}

camera_rect :: proc(camera: rl.Camera2D) -> Rect {
	profile_scope()
	pos := rl.GetScreenToWorld2D({}, camera)
	size := screen_size() / camera.zoom
	return rect_from_pos_size(pos, size)
}

when GameProfile {
	@(deferred_none = profile_scope_end)
	profile_scope :: proc(name: string = "", loc := #caller_location) {
		if !g_mem.profiling {
			return
		}

		spall._buffer_begin(&g_mem.spall_ctx, &g_mem.spall_buffer, name, "", loc)
	}

	profile_scope_end :: proc() {
		if !g_mem.profiling {
			return
		}

		spall._buffer_end(&g_mem.spall_ctx, &g_mem.spall_buffer)
	}

	profile_start :: proc(name: string, loc := #caller_location) {
		if !g_mem.profiling {
			return
		}

		spall._buffer_begin(&g_mem.spall_ctx, &g_mem.spall_buffer, name, "", loc)
	}

	profile_end :: proc() {
		if !g_mem.profiling {
			return
		}

		spall._buffer_end(&g_mem.spall_ctx, &g_mem.spall_buffer)
	}
} else {
	profile_scope :: proc(name: string = "") {
	}

	profile_scope_end :: proc() {
	}

	profile_start :: proc(name: string) {
	}

	profile_end :: proc() {
	}
}

button_width :: proc(s: cstring) -> f32 {
	return rl.MeasureTextEx(g_mem.font, s, MetricFontHeight, 0).x + MetricControlTextMargin * 2
}

text_size :: proc(s: string) -> Vec2 {
	sc := strings.clone_to_cstring(s, context.temp_allocator)
	return rl.MeasureTextEx(g_mem.font, sc, MetricFontHeight, 0)
}

TextAlign :: enum {
	Left,
	Center,
	Right,
}
