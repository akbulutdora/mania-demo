package game

// import rl "vendor:raylib"

// import "core:fmt"

// _ :: fmt

// UIId :: distinct u64

// UIActiveData :: [1024]byte

// UI :: struct {
// 	// Read or write these
// 	next_hover: UIId,
// 	next_hover_in_overlay: UIId,
// 	active: UIId,

// 	// Read, but don't write these
// 	id_counter: UIId,
// 	hover: UIId,
// 	hover_in_overlay: bool,
// 	mouse_down_hover: UIId,
// 	clicked: UIId,
// 	clicked_in_overlay: UIId,

// 	previous_active: UIId,

// 	active_buffer: [dynamic]byte,
// 	user_data: EntityHandle,

// 	overlay: rl.RenderTexture2D,
// 	caret: int,

// 	active_data: UIActiveData,
// }

// ui: UI

// ui_next_id :: proc() -> UIId {
// 	id := ui.id_counter
// 	ui.id_counter += 1
// 	return id
// }

// ui_begin_overlay :: proc() {
// 	rl.BeginTextureMode(ui.overlay)
// }

// ui_end_overlay :: proc() {
// 	rl.EndTextureMode()

// // fix for raylib bug with high DPI scaling
// 	rl.rlLoadIdentity()
// 	dpi_scale := rl.GetWindowScaleDPI()

// 	scl := [16]f32 {
// 		dpi_scale.x, 0, 0, 0,
// 		0, dpi_scale.y, 0, 0,
// 		0, 0, 1, 0,
// 		0, 0, 0, 1,
// 	}

// 	rl.rlMultMatrixf(&scl[0])
// }

// ui_reset :: proc() {
// 	rw := rl.GetRenderWidth()
// 	rh := rl.GetRenderHeight()

// 	if ui.overlay.texture.id == 0 {
// 		ui.overlay = rl.LoadRenderTexture(rw, rh)
// 	} else {
// 		if ui.overlay.texture.width != rw || ui.overlay.texture.height != rh {
// 			rl.UnloadRenderTexture(ui.overlay)
// 			ui.overlay = rl.LoadRenderTexture(rw, rh)
// 		}
// 	}

// 	ui_begin_overlay()
// 	rl.ClearBackground({0,0,0,0})
// 	ui_end_overlay()

// 	ui.id_counter = 1
// 	ui.hover_in_overlay = false

// 	ui.hover = ui.next_hover

// 	if ui.next_hover_in_overlay != 0 {
// 		ui.hover = ui.next_hover_in_overlay
// 		ui.hover_in_overlay = true
// 	}

// 	ui.next_hover = 0
// 	ui.next_hover_in_overlay = 0
// 	ui.clicked = 0
// 	ui.clicked_in_overlay = 0
// 	ui.previous_active = ui.active

// 	if rl.IsMouseButtonUp(.LEFT) {
// 		if ui.mouse_down_hover == ui.hover {
// 			if ui.hover_in_overlay {
// 				ui.clicked_in_overlay = ui.mouse_down_hover
// 			} else {
// 				ui.clicked = ui.mouse_down_hover
// 			}
// 		}

// 		ui.mouse_down_hover = 0
// 	}

// 	if rl.IsMouseButtonPressed(.LEFT) {
// 		if ui.hover != 0 {
// 			ui.mouse_down_hover = ui.hover
// 		}

// 		if ui.active != 0 && ui.hover != ui.active {
// 			ui.active = 0
// 		}
// 	}

// 	if ui.active == 0 && ui.previous_active == 0 {
// 		delete(ui.active_buffer)
// 		ui.active_buffer = {}
// 		ui.user_data = EntityHandleNone
// 	}
// }
