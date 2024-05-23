package game

import "core:log"

DrawableTexture :: struct {
	tex:    Texture,
	source: Rect,
	dest:   Rect,
	pos:    Vec2,
}

DrawableRect :: struct {}

Drawable :: union {
	DrawableTexture,
	DrawableRect,
}

DrawableArray :: [4096]Drawable

@(private = "file")
drawables: ^DrawableArray

@(private = "file")
num_drawables: int

drawables_init :: proc(d: ^DrawableArray) {
	drawables = d
}

drawables_slice :: proc() -> []Drawable {
	return drawables[:num_drawables]
}

drawables_reset :: proc() {
	num_drawables = 0
}

add_drawable :: proc(d: Drawable) {
	if num_drawables == len(drawables) {
		log.error("Out of drawables")
		return
	}

	drawables[num_drawables] = d
	num_drawables += 1
}

draw_texture_rec :: proc(tex: Texture, source: Rect, pos: Vec2) {
	add_drawable(DrawableTexture{tex = tex, source = source, pos = pos})
}

draw_texture_rec_dest :: proc(tex: Texture, source: Rect, dest: Rect, pos: Vec2) {
	add_drawable(DrawableTexture{tex = tex, source = source, dest = dest, pos = pos})
}

draw_texture_pos :: proc(tex: Texture, pos: Vec2) {
	add_drawable(DrawableTexture{tex = tex, pos = pos})
}

draw_texture :: proc {
	draw_texture_pos,
	draw_texture_rec,
	draw_texture_rec_dest,
}
