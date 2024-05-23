package game

import rl "vendor:raylib"

editor_update :: proc() {

}

editor_draw :: proc() {
	rl.ClearBackground({100, 200, 100, 255})

	screen_rect := Rect{0, 0, f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())}
	rl.DrawRectangleRec(screen_rect, rl.RED)
	// camera := game_camera()
	// mp := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera)

	// rl.DrawTextureV(g_mem.platform_texture, mp, rl.WHITE)

	// if rl.IsMouseButtonPressed(.LEFT) {
	// 	append(&g_mem.level.platforms, mp)
	// }

	// if rl.IsMouseButtonPressed(.RIGHT) {
	// 	for p, idx in g_mem.level.platforms {
	// 		if (rl.CheckCollisionPointRec(mp, platform_collider(p))) {
	// 			unordered_remove(&g_mem.level.platforms, idx)
	// 			break
	// 		}
	// 	}
	// }

}
