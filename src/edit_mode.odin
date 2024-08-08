package game

import "core:fmt"
import "core:math/linalg"
import rl "vendor:raylib"

EditorMemory :: struct {
	mode:                  EditMode,
	edit_mode_place_tiles: EditModePlaceTiles,
	selection:             [dynamic]int,
	level_name:            LevelName,
	zoom:                  f32,
	layer:                 int,
	layer_view_mode:       LayerViewMode,
	tileset_padded:        rl.Texture,
	font:                  rl.Font,
	world:                 World,
	camera_pos:            Vec2,
	clear_color:           rl.Color,
}

EditMode :: union {
	^EditModePlaceTiles,
}

EditModePlaceTiles :: struct {
	brush_tile:       int,
	selected_tiles:   map[int]struct {},
	flip_x:           bool,
	flip_y:           bool,
	last_place_pos_x: int,
	last_place_pos_y: int,
	has_placed_tile:  bool,
	has_removed_tile: bool,
}

@(private = "file")
em: ^EditorMemory

editor_refresh_globals :: proc(editor_memory: ^EditorMemory) {
	em = editor_memory
}

edit_mode_update :: proc() {
	if rl.IsKeyPressed(.P) {
		fmt.println(mouse_world_position(get_camera(em.camera_pos, em.zoom)))
	}

	// rl.BeginShaderMode(em.pixel_filter_shader)
	// defer rl.EndShaderMode()
	// rl.BeginBlendMode(.ALPHA_PREMULTIPLY)
	// defer rl.EndBlendMode()

	rl.ClearBackground(em.clear_color)

	{
		ui_camera := ui_camera()

		rl.BeginMode2D(ui_camera)
		defer rl.EndMode2D()

		mouse_pos := rl.GetMousePosition()
		text := fmt.ctprintf("Mouse: %v", mouse_pos)
		rl.DrawText(text, 10, PixelWindowHeight - 20, 8, rl.RED)
	}

	for x in 0 ..= screen_width() / MetricEditorTileSize {
		for y in 1 ..= screen_height() / MetricEditorTileSize + 1 {
			rect := rl.Rectangle {
				f32(x * MetricEditorTileSize),
				f32(screen_height() - y * MetricEditorTileSize),
				MetricEditorTileSize,
				MetricEditorTileSize,
			}
			rl.DrawRectangleLinesEx(rect, 0.5, rl.GRAY)
		}
	}

	window := rect_from_pos_size({0, 0}, screen_size())
	main_toolbar_background := cut_rect_top(&window, MetricToolbarHeight, 0)
	rl.DrawRectangleRec(main_toolbar_background, ColorToolbarBackground)
	// main_toolbar := inset_rect(main_toolbar_background, MetricToolbarPadding, MetricToolbarPadding)
	// mp := mouse_pos()

}

mouse_world_position :: proc(camera: rl.Camera2D) -> Vec2 {
	return linalg.floor(rl.GetScreenToWorld2D(mouse_pos(), camera))
}

LayerViewMode :: enum {
	All,
	CurrentAndBehind,
	Current,
}

layer_view_mode_compatible :: proc(object_layer: int, lvm: LayerViewMode, layer: int) -> bool {
	if lvm == .All {
		return true
	}

	if lvm == .Current && object_layer == layer {
		return true
	}

	if lvm == .CurrentAndBehind && object_layer <= layer {
		return true
	}

	return false
}
