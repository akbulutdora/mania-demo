package game

// import "core:fmt"
// import "core:reflect"
// import "core:strconv"
// import "core:strings"
// import "core:unicode/utf8"

// import rl "vendor:raylib"

// gui_entity_picker :: proc(rect: Rect, cur: EntityHandle, entities: HandleArray(Entity, EntityHandle), sample_all_layers: bool, active_layer: int, camera: rl.Camera2D, label: string = "") -> (EntityHandle, bool) #optional_ok {
// 	rect := gui_property_label(rect, label)
// 	res := cur

// 	{
// 		r := cut_rect_right(&rect, 32, 0)
// 		id := ui_next_id()
// 		s := "Pick"
// 		mt := text_size(s)
// 		rl.DrawRectangleRec(r, ColorControlBackground)
// 		mp := mouse_pos()

// 		if rl.CheckCollisionPointRec(mp, r) {
// 			ui.next_hover = id
// 		}

// 		if ui.hover == id {
// 			rl.DrawRectangleRec(r, ColorControlBackgroundHover)

// 			if rl.IsMouseButtonPressed(.LEFT) {
// 				ui.active = id
// 				ui.user_data = EntityHandleNone
// 			}
// 		}

// 		if ui.active == id  {
// 			rl.DrawRectangleRec(r, ColorControlBackgroundActive)

// 			under_cursor := find_entity_under_cursor(entities, sample_all_layers, active_layer, camera, ui.user_data)

// 			if ui.user_data == EntityHandleNone {
// 				ui.user_data = under_cursor
// 			} else {
// 				if under_cursor == EntityHandleNone {
// 					ui.user_data = EntityHandleNone
// 				} else if rl.IsKeyPressed(.N) {
// 					ui.user_data = under_cursor
// 				}
// 			}

// 			if ui.user_data != EntityHandleNone {
// 				e := ha_get_ptr(entities, ui.user_data)
// 				draw_rectangle_lines(entity_picking_rect(e), rl.GREEN, 100)
// 			}

// 			if rl.IsMouseButtonUp(.LEFT) {
// 				ui.active = 0

// 				if ui.user_data != EntityHandleNone {
// 					res = ui.user_data
// 				}
// 			}
// 		}

// 		rl.DrawRectangleLinesEx(r, 1, ColorControlBorder)
// 		text_pos := Vec2{r.x + r.width/2 - mt.x/2, r.y + r.height/2 - mt.y/2}
// 		rl.DrawTextEx(font, "Pick", text_pos, MetricFontHeight, 0, ColorControlText)
// 	}

// 	if e, ok := ha_get(entities, cur); ok {
// 		gui_label(fmt.tprintf("{0}, {1}, {2}", reflect.union_variant_typeid(e.variant), cur.idx, cur.gen), rect)
// 		//gui_label(fmt.tprintf("{0}", cur), rect)
// 	} else {
// 		gui_label("(none)", rect)
// 	}

// 	return res, cur != res
// }


// gui_int_field :: proc(rect: Rect, initial: int, label: string = "") -> (res: int, changed: bool) {
// 	buf: [128]byte

// 	res = initial
// 	initial_str := strconv.itoa(buf[:], initial)

// 	if len(initial_str) > 0 && initial_str[0] == '+' {
// 		initial_str = initial_str[1:]
// 	}

// 	new_str, str_changed := gui_string_field(rect, initial_str, label)

// 	if str_changed {
// 		res = strconv.atoi(new_str)
// 		changed = true
// 	}

// 	return
// }

// gui_vec2_field :: proc(rect: Rect, initial: Vec2, label: string = "") -> (res: Vec2, changed: bool) {
// 	rect := gui_property_label(rect, label)
// 	res = initial

// 	l, r := split_rect_left(rect, rect.width / 2 - 3, 3)

// 	if new_x, x_changed := gui_f32_field(l, res.x); x_changed {
// 		changed = true
// 		res.x = new_x
// 	}

// 	if new_y, y_changed := gui_f32_field(r, res.y); y_changed {
// 		changed = true
// 		res.y = new_y
// 	}

// 	return
// }

// gui_f32_field :: proc(rect: Rect, initial: f32, label: string = "") -> (res: f32, changed: bool) {
// 	buf: [128]byte

// 	res = initial
// 	initial_str := strconv.ftoa(buf[:], f64(initial), 'f', 3, 32)

// 	if len(initial_str) > 0 && initial_str[0] == '+' {
// 		initial_str = initial_str[1:]
// 	}

// 	new_str, str_changed := gui_string_field(rect, initial_str, label)

// 	if str_changed {
// 		res = f32(strconv.atof(new_str))
// 		changed = true
// 	}

// 	return
// }

// gui_multiline_string_field_rect :: proc(pos: Vec2, max_width: f32, text: string, has_label: bool, id: UIId) -> Rect {
// 	lines_width := max_width

// 	if has_label {
// 		lines_width -= MetricPropertyLabelWidth + MetricPropertyLabelMargin + MetricControlTextMargin * 2
// 	} else {
// 		lines_width -=  + MetricControlTextMargin * 2
// 	}

// 	num_lines: int

// 	if ui.active == id {
// 		b := strings.Builder { ui.active_buffer }
// 		cur_str := strings.to_string(b)
// 		num_lines = count_gui_lines(cur_str, lines_width, font, MetricFontHeight)
// 	} else {
// 		num_lines = count_gui_lines(text, lines_width, font, MetricFontHeight)
// 	}

// 	return {
// 		x = pos.x,
// 		y = pos.y,
// 		width = max_width,
// 		height = MetricPropertyHeight * f32(max(1, num_lines)),
// 	}
// }

// // by laytan
// insert_rune :: proc(b: ^strings.Builder, i: int, r: rune) {
// 	bytes, n := utf8.encode_rune(r)

// 	// Append the bytes so the buf grows,
// 	// doesn't actually matter what bytes these are cause they will be overwritten.
// 	append(&b.buf, ..bytes[:n])

// 	// Shift the rest of the string over by the size of the rune.
// 	copy(b.buf[i+n:], b.buf[i:len(b.buf)-n])

// 	// Insert the rune.
// 	copy(b.buf[i:i+n], bytes[:n])
// }

// builder_remove_at :: proc(b: ^strings.Builder, i: int) {
// 	copy(b.buf[i-1:], b.buf[i:])
// 	pop(&b.buf)
// }

// gui_multiline_string_field :: proc(r: Rect, initial: string, label: string = "", id: UIId = 0) -> (res: string, changed: bool) {
// 	r := gui_property_label(r, label)
// 	res = initial

// 	rl.DrawRectangleRec(r, ColorControlBackground)
// 	text_pos := pos_from_rect(r) + {MetricControlTextMargin, 0}

// 	id := id
// 	if id == 0 {
// 		id = ui_next_id()
// 	}

// 	if mouse_in_rect(r) {
// 		ui.next_hover = id
// 	}

// 	if ui.hover == id {
// 		rl.DrawRectangleRec(r, ColorControlBackgroundHover)
// 	}

// 	if ui.clicked == id {
// 		ui.active = id
// 		b := strings.builder_make(0)
// 		strings.write_string(&b, initial)
// 		ui.active_buffer = b.buf
// 		ui.caret = len(initial)
// 	}

// 	if ui.active == id {
// 		rl.DrawRectangleRec(r, ColorControlBackgroundActive)

// 		b := strings.Builder { ui.active_buffer }

// 		if rl.IsKeyPressed(.BACKSPACE) {
// 			if rl.IsKeyDown(.LEFT_CONTROL) {
// 				if rl.IsKeyDown(.LEFT_SHIFT) {
// 					strings.builder_reset(&b)
// 				} else {
// 					num_chars := 1

// 					cur_str := strings.to_string(b)
// 					if rl.IsKeyDown(.LEFT_CONTROL) {
// 						for i := ui.caret-1; i >= 0; i -= 1 {
// 							if i == 0 {
// 								num_chars = ui.caret
// 							}
// 							if cur_str[i] == ' ' && i != ui.caret-1 {
// 								num_chars = ui.caret - i - 1
// 								break
// 							}
// 						}
// 					}

// 					if ui.caret - num_chars < 0 {
// 						num_chars = num_chars + (ui.caret - num_chars)
// 					}

// 					copy(b.buf[ui.caret - num_chars:], b.buf[ui.caret:])
// 					resize(&b.buf, len(b.buf) - num_chars)
// 					ui.caret -= num_chars
// 				}
// 			} else if ui.caret > 0 {
// 				builder_remove_at(&b, ui.caret)
// 				ui.caret -= 1
// 			}
// 		}

// 		if rl.IsKeyPressed(.DELETE) {
// 			if ui.caret < strings.builder_len(b) {
// 				builder_remove_at(&b, ui.caret + 1)
// 			}
// 		}

// 		cp := rl.GetCharPressed()
// 		for cp != 0 {
// 			if ui.caret == strings.builder_len(b) {
// 				strings.write_rune(&b, cp)
// 			} else {
// 				insert_rune(&b, ui.caret, cp)
// 			}

// 			ui.caret += 1
// 			cp = rl.GetCharPressed()
// 		}

// 		cur_str := strings.to_string(b)
// 		ui.active_buffer = b.buf

// 		if rl.IsKeyPressed(.HOME) {
// 			ui.caret = 0
// 		}

// 		if rl.IsKeyPressed(.END) {
// 			ui.caret = len(cur_str)
// 		}

// 		if rl.IsKeyPressed(.LEFT) {
// 			num_chars := 1

// 			if rl.IsKeyDown(.LEFT_CONTROL) {
// 				for i := ui.caret-1; i >= 0; i -= 1 {
// 					if i == 0 {
// 						num_chars = ui.caret
// 					}
// 					if cur_str[i] == ' ' && i != ui.caret-1 {
// 						num_chars = ui.caret - i - 1
// 						break
// 					}
// 				}
// 			}

// 			ui.caret -= num_chars
// 			if ui.caret < 0 {
// 				ui.caret = 0
// 			}
// 		}

// 		if rl.IsKeyPressed(.RIGHT) {
// 			num_chars := 1

// 			if rl.IsKeyDown(.LEFT_CONTROL) {
// 				for i := ui.caret; i < len(cur_str); i += 1 {
// 					if i == len(cur_str) - 1 {
// 						num_chars = len(cur_str) - ui.caret + 1
// 					}

// 					if cur_str[i] == ' ' && i != ui.caret {
// 						num_chars = i - ui.caret
// 						break
// 					}
// 				}
// 			}

// 			ui.caret += num_chars
// 		}

// 		if ui.caret > len(cur_str) {
// 			ui.caret = len(cur_str) > 0 ? len(cur_str) :0
// 		}

// 		lines, _ := get_gui_lines(cur_str, r.width - MetricControlTextMargin * 2, font, MetricFontHeight)

// 		c_idx := 0
// 		for l in lines {
// 			line_len := len(l)

// 			if ui.caret >= c_idx && ui.caret <= c_idx + line_len && (ui.caret-c_idx != line_len || ui.caret == len(cur_str)) {
// 				caret_pos := text_pos + {rl.MeasureTextEx(font, temp_cstring(l[:ui.caret-c_idx]), MetricFontHeight, 0).x, 2}
// 				rl.DrawRectangleV(caret_pos, {1.5, 14}, rl.WHITE)
// 			}

// 			c_idx += line_len

// 			rl.DrawTextEx(font, temp_cstring(l), text_pos, MetricFontHeight, 0, ColorControlText)
// 			text_pos.y += MetricFontHeight
// 		}

// 		if rl.IsKeyPressed(.ENTER) {
// 			changed = true
// 			res = strings.clone(strings.to_string(b), context.temp_allocator)
// 			ui.active = 0
// 		}
// 	} else {
// 		if ui.previous_active == id {
// 			b := strings.Builder { ui.active_buffer }
// 			s := strings.to_string(b)
// 			if s != initial {
// 				changed = true
// 				res = strings.clone(s, context.temp_allocator)
// 			}
// 		}

// 		lines, _ := get_gui_lines(initial, r.width - MetricControlTextMargin * 2, font, MetricFontHeight)
// 		for l in lines {
// 			rl.DrawTextEx(font, temp_cstring(l), text_pos, MetricFontHeight, 0, ColorControlText)
// 			text_pos.y += MetricFontHeight
// 		}
// 	}

// 	rl.DrawRectangleLinesEx(r, 1, ColorControlBorder)
// 	return
// }

// gui_string_field :: proc(r: Rect, initial: string, label: string = "") -> (res: string, changed: bool) {
// 	r := gui_property_label(r, label)
// 	res = initial

// 	rl.DrawRectangleRec(r, ColorControlBackground)
// 	text_pos := pos_from_rect(r) + {MetricControlTextMargin, 0}
// 	id := ui_next_id()

// 	if mouse_in_rect(r) {
// 		ui.next_hover = id
// 	}

// 	if ui.hover == id {
// 		rl.DrawRectangleRec(r, ColorControlBackgroundHover)
// 	}

// 	if ui.clicked == id {
// 		ui.active = id
// 		b := strings.builder_make(0)
// 		strings.write_string(&b, initial)
// 		ui.active_buffer = b.buf
// 	}

// 	if ui.active == id {
// 		rl.DrawRectangleRec(r, ColorControlBackgroundActive)

// 		b := strings.Builder { ui.active_buffer }

// 		if rl.IsKeyPressed(.BACKSPACE) {
// 			if rl.IsKeyDown(.LEFT_CONTROL) {
// 				strings.builder_reset(&b)
// 			} else {
// 				strings.pop_rune(&b)
// 			}
// 		}

// 		cp := rl.GetCharPressed()
// 		for cp != 0 {
// 			w, _ := strings.write_rune(&b, cp)
// 			cp = rl.GetCharPressed()
// 		}

// 		cur_str := strings.to_string(b)
// 		ui.active_buffer = b.buf
// 		rl.DrawTextPro(font, temp_cstring(cur_str), text_pos, {}, 0, MetricFontHeight, 1, ColorControlText)

// 		if rl.IsKeyPressed(.ENTER) {
// 			changed = true
// 			res = strings.clone(strings.to_string(b), context.temp_allocator)
// 			ui.active = 0
// 		}
// 	} else {
// 		if ui.previous_active == id {
// 			b := strings.Builder { ui.active_buffer }
// 			s := strings.to_string(b)
// 			if s != initial {
// 				changed = true
// 				res = strings.clone(s, context.temp_allocator)
// 			}
// 		}

// 		rl.DrawTextPro(font, temp_cstring(initial), text_pos, {}, 0, MetricFontHeight, 1, ColorControlText)
// 	}

// 	rl.DrawRectangleLinesEx(r, 1, ColorControlBorder)
// 	return
// }

// gui_button :: proc(s: string, r: rl.Rectangle) -> bool {
// 	id := ui_next_id()
// 	sc := strings.clone_to_cstring(s, context.temp_allocator)
// 	mt := text_size(s)
// 	rl.DrawRectangleRec(r, ColorControlBackground)
// 	mp := mouse_pos()

// 	if rl.CheckCollisionPointRec(mp, r) {
// 		ui.next_hover = id
// 	}

// 	if ui.hover == id {
// 		if ui.mouse_down_hover == id {
// 			rl.DrawRectangleRec(r, ColorControlBackgroundActive)
// 		} else {
// 			rl.DrawRectangleRec(r, ColorControlBackgroundHover)
// 		}
// 	}

// 	rl.DrawRectangleLinesEx(r, 1, ColorControlBorder)

// 	text_pos := Vec2{r.x + r.width/2 - mt.x/2, r.y + r.height/2 - mt.y/2}
// 	rl.DrawTextEx(font, sc, text_pos, MetricFontHeight, 0, ColorControlText)
// 	return ui.clicked == id
// }

// gui_push_button :: proc(s: string, r: rl.Rectangle, active: bool) -> bool {
// 	id := ui_next_id()
// 	sc := strings.clone_to_cstring(s, context.temp_allocator)
// 	mt := text_size(s)
// 	rl.DrawRectangleRec(r, ColorControlBackground)
// 	rl.DrawRectangleLinesEx(r, 1, ColorControlBorder)
// 	mp := mouse_pos()

// 	if rl.CheckCollisionPointRec(mp, r) {
// 		ui.next_hover = id
// 	}

// 	if ui.hover == id {
// 		if ui.mouse_down_hover == id {
// 			rl.DrawRectangleRec(r, ColorControlBackgroundActive)
// 		} else {
// 			rl.DrawRectangleRec(r, ColorControlBackgroundHover)
// 		}

// 		rl.DrawRectangleLinesEx(r, 1, ColorControlBorder)
// 	}

// 	if active {
// 		rl.DrawRectangleRec(r, ColorControlBackgroundActive)
// 		rl.DrawRectangleLinesEx(r, 1, ColorControlBorder)
// 	}

// 	text_pos := Vec2{r.x + r.width/2 - mt.x/2, r.y + r.height/2 - mt.y/2}
// 	rl.DrawTextEx(font, sc, text_pos, MetricFontHeight, 0, ColorControlText)
// 	if ui.clicked == id {
// 		return !active
// 	}

// 	return active
// }

// gui_label :: proc(s: string, r: rl.Rectangle, align: TextAlign = .Left){
// 	sc := strings.clone_to_cstring(s, context.temp_allocator)
// 	mt := text_size(s)
// 	text_pos: Vec2

// 	switch align {
// 		case .Left:
// 			text_pos = Vec2{r.x, r.y + r.height/2 - mt.y/2}

// 		case .Center:
// 			text_pos = Vec2{r.x + r.width/2 - mt.x/2, r.y + r.height/2 - mt.y/2}

// 		case .Right:
// 			text_pos = Vec2{r.x + r.width - mt.x, r.y + r.height/2 - mt.y/2}
// 	}
// 	rl.DrawTextEx(font, sc, text_pos, MetricFontHeight, 0, ColorControlText)
// }

// gui_text_box :: proc(s: string, p: Vec2) {
// 	sc := strings.clone_to_cstring(s, context.temp_allocator)
// 	mt := rl.MeasureTextEx(rl.GetFontDefault(), sc, 30, 0)
// 	rl.DrawRectangleLinesEx(rect_from_pos_size(p, mt), 1, rl.RED)
// 	rl.DrawTextEx(rl.GetFontDefault(), sc, p, 30, 0, rl.WHITE)
// }

// gui_bitset_dropdown :: proc(rect: Rect, cur: bit_set[ProgressFlag], label: string = "") -> (bit_set[ProgressFlag], bool) #optional_ok {
// 	T :: ProgressFlag
// 	names := reflect.enum_field_names(typeid_of(T))
// 	values: [len(T)]T
// 	n := 0

// 	for v in reflect.enum_field_values(typeid_of(T)) {
// 		values[n] = T(v)
// 		n += 1
// 	}

// 	rect := gui_property_label(rect, label)

// 	rl.DrawRectangleRec(rect, ColorControlBackground)
// 	rl.DrawRectangleLinesEx(rect, 1, ColorControlBorder)

// 	cur_text: string

// 	for v, v_idx in values {
// 		if v in cur {
// 			cur_text = len(cur_text) > 0 ? fmt.tprintf("{0}, {1}", cur_text, names[v_idx]) : names[v_idx]
// 		}
// 	}

// 	rl.DrawTextPro(font, temp_cstring(cur_text), pos_from_rect(rect) + {MetricControlTextMargin, 0}, {}, 0, MetricFontHeight, 0, ColorControlText)
// 	rl.DrawTextPro(font, "v", pos_from_rect(rect) + {rect.width - 10, 0}, {}, 0, MetricFontHeight, 0, ColorControlText)

// 	id := ui_next_id()

// 	if mouse_in_rect(rect) {
// 		ui.next_hover = id
// 	}

// 	if ui.active == id  {
// 		if ui.clicked == id || (ui.clicked_in_overlay == id && !rl.IsKeyDown(.LEFT_CONTROL)) {
// 			ui.active = 0
// 		}

// 		drect := rect
// 		drect.y += drect.height
// 		drect.height = f32(len(names) * 20 + (len(names) - 1) * 2)
// 		ui_begin_overlay()
// 		rl.DrawRectangleRec(drect, ColorControlBackground)

// 		if mouse_in_rect(drect) {
// 			ui.next_hover_in_overlay = id
// 		}

// 		for n, n_idx in names {
// 			row := cut_rect_top(&drect, 20, n_idx == 0 ? 0 : 2)

// 			if values[n_idx] in cur {
// 				rl.DrawRectangleRec(row, ColorControlBackgroundActive)
// 			} else {
// 				if mouse_in_rect(row) {
// 					rl.DrawRectangleRec(row, ColorControlBackgroundHover)
// 				}
// 			}

// 			if mouse_in_rect(row) {
// 				if rl.IsMouseButtonPressed(.LEFT) {
// 					ui_end_overlay()
// 					if values[n_idx] in cur {
// 						return cur - {values[n_idx]}, true
// 					} else {
// 						return cur + {values[n_idx]}, true
// 					}
// 				}
// 			}

// 			rl.DrawTextPro(font, temp_cstring(n), pos_from_rect(row)+ {MetricControlTextMargin, 0}, {}, 0, MetricFontHeight, 0, ColorControlText)
// 		}

// 		ui_end_overlay()
// 	} else if ui.clicked == id {
// 		ui.active = id
// 	}

// 	return cur, false
// }

// gui_enum_dropdown :: proc(rect: Rect, cur: $T, label: string = "") -> (T, bool) #optional_ok {
// 	names := reflect.enum_field_names(typeid_of(T))
// 	values: [len(T)]T
// 	n := 0

// 	for v in reflect.enum_field_values(typeid_of(T)) {
// 		values[n] = T(v)
// 		n += 1
// 	}

// 	return gui_dropdown(rect, values[:], names[:], cur, label)
// }

// gui_enum_selector :: proc(rect: Rect, cur: $T, label: string = "") -> (T, bool) #optional_ok {
// 	names := reflect.enum_field_names(typeid_of(T))
// 	values: [len(T)]T
// 	n := 0

// 	for v in reflect.enum_field_values(typeid_of(T)) {
// 		values[n] = T(v)
// 		n += 1
// 	}

// 	//cut_rect_left(rect, gui_state_selector_width(names[:]), 0)
// 	return gui_state_selector(rect, values[:], names[:], cur, label)
// }

// gui_state_selector_width :: proc(state_names: []string) -> f32 {
// 	total_width: f32

// 	for s in state_names {
// 		total_width += rl.MeasureTextEx(font, temp_cstring(s), MetricFontHeight, 0).x + MetricControlTextMargin*2
// 	}

// 	return total_width
// }

// gui_state_selector :: proc(rect: rl.Rectangle, states: []$T, state_names: []string, cur_state: T, label: string = "") -> (T, bool) #optional_ok {
// 	rect := gui_property_label(rect, label)

// 	if len(states) == 0 {
// 		return cur_state, false
// 	}

// 	if len(states) != len(state_names) {
// 		return cur_state, false
// 	}

// 	r := rect
// 	rl.DrawRectangleRec(r, ColorControlBackground)
// 	new_state := cur_state
// 	changed := false

// 	needed_width := gui_state_selector_width(state_names)

// 	extra_button_width: f32
// 	if rect.width > needed_width {
// 		extra_button_width = (rect.width - needed_width)/f32(len(states))
// 	}

// 	for s, s_idx in states {
// 		id := ui_next_id()
// 		name := temp_cstring(state_names[s_idx])
// 		button_size := rl.MeasureTextEx(font, name, MetricFontHeight, 0)
// 		button_rect := cut_rect_left(&r, button_size.x + MetricControlTextMargin * 2 + extra_button_width, 0)

// 		if mouse_in_rect(button_rect) {
// 			ui.next_hover = id
// 		}

// 		if ui.hover == id {
// 			if ui.mouse_down_hover == id {
// 				rl.DrawRectangleRec(button_rect, ColorControlBackgroundActive)
// 			} else {
// 				rl.DrawRectangleRec(button_rect, ColorControlBackgroundHover)
// 			}
// 		}

// 		if cur_state == s {
// 			rl.DrawRectangleRec(button_rect, ColorControlBackgroundActive)
// 		}

// 		if ui.clicked == id {
// 			if new_state != s {
// 				changed = true
// 				new_state = s
// 			}
// 		}

// 		rl.DrawTextPro(font, name, pos_from_rect(button_rect) + {MetricControlTextMargin, 0} + {extra_button_width/2, 0}, {}, 0, MetricFontHeight, 0, ColorControlText)
// 	}

// 	rl.DrawRectangleLinesEx(rect, 1, ColorControlBorder)
// 	return new_state, changed
// }

// gui_property_label :: proc(rect: Rect, label: string) -> (remaining: Rect) {
// 	if label == "" {
// 		remaining = rect
// 		return
// 	}

// 	l, h := split_rect_left(rect, MetricPropertyLabelWidth, 0)
// 	gui_label(label, l, .Right)
// 	_, remaining = split_rect_left(h, MetricPropertyLabelMargin, 0)
// 	return
// }

// gui_dropdown :: proc(rect: Rect, values: []$T, names: []string, cur: T, label: string = "") -> (T, bool) #optional_ok {
// 	rect := gui_property_label(rect, label)

// 	rl.DrawRectangleRec(rect, ColorControlBackground)
// 	rl.DrawRectangleLinesEx(rect, 1, ColorControlBorder)

// 	cur_idx := -1

// 	for v, v_idx in values {
// 		if v == cur {
// 			cur_idx = v_idx
// 		}
// 	}

// 	id := ui_next_id()

// 	if cur_idx != -1 {
// 		n := names[cur_idx]
// 		rl.DrawTextPro(font, temp_cstring(n), pos_from_rect(rect) + {MetricControlTextMargin, 0}, {}, 0, MetricFontHeight, 0, ColorControlText)

// 		rl.DrawTextPro(font, "v", pos_from_rect(rect) + {rect.width - 10, 0}, {}, 0, MetricFontHeight, 0, ColorControlText)
// 	}

// 	if mouse_in_rect(rect) {
// 		ui.next_hover = id
// 	}

// 	if ui.active == id  {
// 		if ui.clicked_in_overlay == id || ui.clicked == id {
// 			ui.active = 0
// 		}

// 		active_data := transmute(^DropdownActiveData)(&ui.active_data[0])

// 		drect := rect
// 		drect.y += drect.height
// 		drect.height = f32(len(names) * 20 + (len(names) - 1) * 2)

// 		mwm := rl.GetMouseWheelMove()

// 		if mwm != 0 {
// 			active_data.scroll_offset += mwm * 5
// 		}

// 		drect.y += active_data.scroll_offset

// 		if drect.y + drect.height > f32(rl.GetScreenHeight()) {
// 			drect.y -= drect.height + 20
// 		}

// 		ui_begin_overlay()
// 		rl.DrawRectangleRec(drect, ColorControlBackground)

// 		if mouse_in_rect(drect) {
// 			ui.next_hover_in_overlay = id
// 		}

// 		for n, n_idx in names {
// 			row := cut_rect_top(&drect, 20, n_idx == 0 ? 0 : 2)

// 			if n_idx == cur_idx {
// 				rl.DrawRectangleRec(row, ColorControlBackgroundActive)
// 			} else {
// 				if mouse_in_rect(row) {
// 					rl.DrawRectangleRec(row, ColorControlBackgroundHover)
// 				}
// 			}

// 			if mouse_in_rect(row) {
// 				if rl.IsMouseButtonPressed(.LEFT) {
// 					ui_end_overlay()
// 					ui.active = 0
// 					return values[n_idx], true
// 				}
// 			}

// 			rl.DrawTextPro(font, temp_cstring(n), pos_from_rect(row)+ {MetricControlTextMargin, 0}, {}, 0, MetricFontHeight, 0, ColorControlText)
// 		}

// 		ui_end_overlay()
// 	} else if ui.clicked == id {
// 		ui.active = id
// 		ui.active_data = {}
// 	}

// 	return cur, false
// }

// DropdownActiveData :: struct {
// 	scroll_offset: f32,
// }

// count_gui_lines :: proc(text: string, max_width: f32, font: rl.Font, font_size: f32) -> int {
// 	num_lines: int
// 	word_start: int
// 	line_start: int

// 	for r, i in text {
// 		is_last := i == len(text) - 1
// 		if is_last {
// 			line := text[line_start:i + 1]
// 			line_width := rl.MeasureTextEx(font, temp_cstring(line), font_size, 0).x

// 			if line_width > max_width {
// 				num_lines += 1
// 			}

// 			num_lines += 1
// 		} else if r == ' ' {
// 			word := text[word_start:is_last ? i + 1 : i]
// 			line := text[line_start:is_last ? i + 1 : i]
// 			word_width := rl.MeasureTextEx(font, temp_cstring(word), font_size, 0).x
// 			line_width := rl.MeasureTextEx(font, temp_cstring(line), font_size, 0).x

// 			if line_width > max_width {
// 				num_lines += 1
// 				// Corner case for very long words...
// 				if word_width > max_width {
// 					line_start = i + 1
// 				} else {
// 					line_start = word_start
// 				}
// 			}

// 			word_start = i + 1
// 		}
// 	}

// 	return num_lines
// }

// get_gui_lines :: proc(text: string, max_width: f32, font: rl.Font, font_size: f32) -> (lines: [dynamic]string, max_line_width: f32) {
// 	lines = make([dynamic]string, context.temp_allocator)
// 	word_start: int
// 	line_start: int

// 	for r, i in text {
// 		is_last := i == len(text) - 1
// 		if is_last {
// 			word := text[word_start:i + 1]
// 			line := text[line_start:i + 1]
// 			word_width := rl.MeasureTextEx(font, temp_cstring(word), font_size, 0).x
// 			line_width := rl.MeasureTextEx(font, temp_cstring(line), font_size, 0).x

// 			if line_width > max_width {
// 				if word_width > max_width {
// 					append(&lines, word)
// 					line_start = i + 1

// 					if word_width > max_line_width {
// 						max_line_width = word_width
// 					}
// 				} else {
// 					line_to_add := text[line_start:word_start]
// 					line_to_add_width := rl.MeasureTextEx(font, temp_cstring(line_to_add), font_size, 0).x
// 					append(&lines, line_to_add)
// 					line_start = word_start

// 					if line_to_add_width > max_line_width {
// 						max_line_width = line_to_add_width
// 					}
// 				}
// 			}

// 			line = text[line_start:i + 1]
// 			line_width = rl.MeasureTextEx(font, temp_cstring(line), font_size, 0).x
// 			append(&lines, line)

// 			if line_width > max_line_width {
// 				max_line_width = line_width
// 			}
// 		} else if r == ' ' {
// 			word := text[word_start:is_last ? i + 1 : i]
// 			line := text[line_start:is_last ? i + 1 : i]
// 			word_width := rl.MeasureTextEx(font, temp_cstring(word), font_size, 0).x
// 			line_width := rl.MeasureTextEx(font, temp_cstring(line), font_size, 0).x
// 			if line_width > max_width {
// 				if word_width > max_width {
// 					append(&lines, word)
// 					line_start = i + 1

// 					if word_width > max_line_width {
// 						max_line_width = word_width
// 					}
// 				} else {
// 					line_to_add := text[line_start:word_start]
// 					line_to_add_width := rl.MeasureTextEx(font, temp_cstring(line_to_add), font_size, 0).x
// 					append(&lines, line_to_add)
// 					line_start = word_start

// 					if line_to_add_width > max_line_width {
// 						max_line_width = line_to_add_width
// 					}
// 				}
// 			}
// 			word_start = i + 1
// 		}
// 	}

// 	return
// }
