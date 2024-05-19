package game

// import "core:math"
// import "core:strings"
// import "core:runtime"
// import "core:reflect"
// import "core:math/linalg"
// import "core:fmt"

// _ :: fmt

// import rl "vendor:raylib"

// DialogueNodeSnapDistance :: 10

// // Dialogue Editor Interaction State
// DEIS_None :: struct {
// }

// DEIS_DragSelection :: struct {
// 	mouse_start: Vec2,
// }

// DEIS_Connecting :: struct {
// 	from: int,
// 	from_choice: int,
// 	to: int,
// }

// DEIS_Select :: struct {
// 	start: Vec2,
// }

// DialogueEditorInteractionState :: union #no_nil {
// 	DEIS_None,
// 	DEIS_DragSelection,
// 	DEIS_Select,
// 	DEIS_Connecting,
// }

// DialogueEditorState :: struct {
// 	offset: Vec2,
// 	deis: DialogueEditorInteractionState,
// 	selection: map[int]struct{},
// }

// DialogueActor :: enum {
// 	Player,
// 	Entity,
// }

// DialogueChoice :: struct {
// 	text: string,
// 	check_progress: bool,
// 	does_not_have_progress: bool,
// 	progress_to_check: bit_set[ProgressFlag],
// 	check_item: bool,
// 	does_not_have_item: bool,
// 	item_to_check: PickupType,
// }

// DialogueNodeVariantNormal :: struct {
// 	text: string,
// 	actor: DialogueActor,
// 	choices: [8]DialogueChoice,
// 	num_choices: int,
// 	override_kind_enable: bool,
// 	override_kind: EntityKind,
// 	dont_animate: bool,
// 	cur_choice: int,
// }

// DialogueNodeVariantStart :: struct {

// }

// DialogueNodeVariantProgressCheck :: struct {
// 	progress_to_check: bit_set[ProgressFlag],
// }

// DialogueNodeVariantSetProgress :: struct {
// 	progress: ProgressFlag,
// }

// DialogueNodeVariantGivePlayerItem :: struct {
// 	item: PickupType,
// }

// DialogueNodeVariantTriggerEvent :: struct {
// 	event: Event,
// }

// DialogueNodeVariantTakeItem :: struct {
// 	item: PickupType,
// }

// DialogueNodeVariantItemCheck :: struct {
// 	item: PickupType,
// }


// DialogueNodeVariant :: union #no_nil {
// 	DialogueNodeVariantNormal,
// 	DialogueNodeVariantStart,
// 	DialogueNodeVariantProgressCheck,
// 	DialogueNodeVariantSetProgress,
// 	DialogueNodeVariantGivePlayerItem,
// 	DialogueNodeVariantTriggerEvent,
// 	DialogueNodeVariantTakeItem,
// 	DialogueNodeVariantItemCheck,
// }

// DialogueNode :: struct {
// 	pos: Vec2,
// 	transient_pos: Vec2,
// 	unused: bool,
// 	variant: DialogueNodeVariant,
// }

// DialogueConnection :: struct {
// 	from: int,
// 	from_choice: int,
// 	to: int,
// }

// DialogueTree :: struct {
// 	name: DialogueName,
// 	nodes: [dynamic]DialogueNode,
// 	connections: [dynamic]DialogueConnection,
// }

// dialogue_editor :: proc(rect: Rect, t: ^DialogueTree, m: ^DialogueEditorState) {
// 	rect := rect

// 	rl.DrawRectangleRec(rect, ColorPanelBackground)

// 	if rl.GetMouseWheelMoveV() != {} {
// 		m.offset -= rl.GetMouseWheelMoveV() * 100 / dpi_scale()
// 	}

// 	if rl.IsMouseButtonDown(.MIDDLE) {
// 		m.offset -= rl.GetMouseDelta() / dpi_scale()
// 	}

// 	offset_movement: Vec2

// 	if ui.active == 0 && rl.IsKeyUp(.LEFT_CONTROL) {
// 		if rl.IsKeyDown(.W) {
// 			offset_movement.y -= 1
// 		}
// 		if rl.IsKeyDown(.S) {
// 			offset_movement.y += 1
// 		}
// 		if rl.IsKeyDown(.A) {
// 			offset_movement.x -= 1
// 		}
// 		if rl.IsKeyDown(.D) {
// 			offset_movement.x += 1
// 		}

// 		if rl.IsKeyDown(.LEFT_SHIFT) {
// 			offset_movement *= 4
// 		}
// 	}

// 	if offset_movement.x != 0 || offset_movement.y != 0 {
// 		m.offset += offset_movement * dt * 300
// 	}

// 	rl.BeginScissorMode(i32(rect.x), i32(rect.y), i32(rect.width), i32(rect.height))

// 	NodeWidth :: 300

// 	node_size :: proc(n: DialogueNode) -> Vec2{
// 		#partial switch v in n.variant {
// 			case DialogueNodeVariantNormal:
// 				s := Vec2 {NodeWidth, 54}

// 				for ch_idx in 0..<v.num_choices {
// 					ch := v.choices[ch_idx]
// 					num_lines := count_gui_lines(ch.text, NodeWidth - MetricPropertyLabelWidth - MetricPropertyLabelMargin - MetricControlTextMargin * 2, font, MetricFontHeight)
// 					s.y += f32(max(1, num_lines)) * MetricFontHeight

// 					if ch.check_progress {
// 						s.y += MetricFontHeight + MetricPropertyMargin
// 					}

// 					if ch.check_item {
// 						s.y += MetricFontHeight + MetricPropertyMargin
// 					}
// 				}

// 				s.y += f32(v.num_choices) * MetricPropertyMargin

// 				num_lines := count_gui_lines(v.text, NodeWidth - MetricPropertyLabelWidth - MetricPropertyLabelMargin - MetricControlTextMargin * 2 - 10, font, MetricFontHeight)
// 				s.y += f32(max(1, num_lines)) * MetricPropertyHeight
// 				return s

// 			case DialogueNodeVariantStart:
// 				return {NodeWidth, 30}

// 			case DialogueNodeVariantSetProgress:
// 				return {NodeWidth, 55 }
// 		}
// 		return {NodeWidth, 80}
// 	}

// 	in_slot_rect :: proc(pos: Vec2) -> Rect {
// 		return {
// 			pos.x + NodeWidth/2 - 5,
// 			pos.y - 10,
// 			10, 10,
// 		}
// 	}

// 	out_slot_no_choice_rect :: proc(node: DialogueNode) -> Rect {
// 		return {
// 			node.pos.x + NodeWidth/2 - 5,
// 			node.pos.y + node_size(node).y,
// 			10, 10,
// 		}
// 	}

// 	out_slot_rect :: proc(node: DialogueNode, ch_idx: int) -> Rect {
// 		#partial switch v in node.variant {
// 			case DialogueNodeVariantNormal:
// 				if v.num_choices == 0 || ch_idx < 0 {
// 					return out_slot_no_choice_rect(node)
// 				}

// 				h :: (MetricPropertyHeight + MetricPropertyMargin)
// 				return {
// 					node.pos.x + NodeWidth,
// 					node.pos.y + h*2 + f32(h*ch_idx) + h/2,
// 					10, 10,
// 				}

// 			case DialogueNodeVariantProgressCheck:
// 				h :: (MetricPropertyHeight + MetricPropertyMargin)
// 				return {
// 					node.pos.x + NodeWidth,
// 					node.pos.y + h + f32(h*ch_idx) + h/2,
// 					10, 10,
// 				}

// 			case DialogueNodeVariantItemCheck:
// 				h :: (MetricPropertyHeight + MetricPropertyMargin)
// 				return {
// 					node.pos.x + NodeWidth,
// 					node.pos.y + h + f32(h*ch_idx) + h/2,
// 					10, 10,
// 				}

// 		}

// 		return out_slot_no_choice_rect(node)
// 	}

// 	mouse_over_node: int = -1
// 	mouse_over_node_in: int = -1
// 	mouse_over_node_out: int = -1
// 	mouse_over_node_choice: int = -1

// 	conns_to_delete := make([dynamic]int, context.temp_allocator)

// 	graph_screen_rect :: proc(r: Rect, offset: Vec2) -> Rect {
// 		return rect_add_pos(r, -offset)
// 	}

// 	for &c, c_idx in t.connections {
// 		from := c.from
// 		to := c.to

// 		if from < len(t.nodes) && to < len(t.nodes) {
// 			if t.nodes[from].unused || t.nodes[to].unused {
// 				append(&conns_to_delete, c_idx)
// 				continue
// 			}

// 			from_on_side := false

// 			switch v in t.nodes[from].variant {
// 				case DialogueNodeVariantNormal:
// 					from_on_side = v.num_choices > 0

// 				case DialogueNodeVariantStart:
// 				case DialogueNodeVariantProgressCheck:
// 					from_on_side = true

// 				case DialogueNodeVariantSetProgress:
// 				case DialogueNodeVariantGivePlayerItem:
// 				case DialogueNodeVariantTriggerEvent:
// 				case DialogueNodeVariantTakeItem:
// 				case DialogueNodeVariantItemCheck:
// 					from_on_side = true
// 			}

// 			p1 := rect_middle(out_slot_rect(t.nodes[from], c.from_choice)) - m.offset
// 			p4 := rect_middle(in_slot_rect(t.nodes[to].pos)) - m.offset
// 			p2 := p1 + {(NodeWidth/2 + 5) * (p4.x > p1.x ? 1 : -1), 0}
// 			p3 := p4 - {(NodeWidth/2 + 5) * (p4.x > p1.x ? 1 : -1), 0}

// 			if from_on_side {
// 				p2 = p1

// 				if p4.y > p1.y {
// 					p2 = p1
// 					p3 = p4
// 				}
// 			} else if math.abs(p4.x - p1.x) < NodeWidth + 10 {
// 				if p4.y > p1.y {
// 					p2 = p1
// 					p3 = p4
// 				} else {
// 					p3 = p4 + {(NodeWidth/2 + 5) * (p4.x > p1.x ? 1 : -1), 0}

// 					if p4.x > p1.x {
// 						xx := max(p2.x, p3.x)
// 						p3.x = xx
// 						p2.x = xx
// 					} else {
// 						xx := min(p2.x, p3.x)
// 						p3.x = xx
// 						p2.x = xx
// 					}
// 				}
// 			}

// 			rl.SetRandomSeed(u32(c_idx))

// 			c := rl.Color {
// 				u8(rl.GetRandomValue(100, 255)),
// 				u8(rl.GetRandomValue(100, 255)),
// 				u8(rl.GetRandomValue(100, 255)),
// 				255,
// 			}

// 			rl.DrawLineEx(p1, p2, 1.5, c)
// 			rl.DrawLineEx(p2, p3, 1.5, c)
// 			rl.DrawLineEx(p3, p4, 1.5, c)
// 		}
// 	}

// 	#reverse for c in conns_to_delete {
// 		unordered_remove(&t.connections, c)
// 	}

// 	mouse_wp := mouse_pos() + m.offset

// 	for &n, n_idx in t.nodes {
// 		if n.unused {
// 			continue
// 		}

// 		r := rect_from_pos_size(n.pos, node_size(n))
// 		r_screen := graph_screen_rect(r, m.offset)
// 		if mouse_in_rect(rect) && point_in_rect(mouse_wp, r) {
// 			mouse_over_node = n_idx
// 		}

// 		rl.DrawRectangleRec(r_screen, ColorControlBackground)
// 		r_props := inset_rect(r_screen, 5, 3)

// 		switch &v in n.variant {
// 			case DialogueNodeVariantNormal:
// 				multi_string_id := ui_next_id()
// 				text_rect := gui_multiline_string_field_rect(pos_from_rect(r_props), r_props.width, v.text, true, multi_string_id)
// 				if new_text, changed := gui_multiline_string_field(text_rect, v.text, "Text", multi_string_id); changed {
// 					delete(v.text)
// 					v.text = strings.clone(new_text)
// 					record_undo()
// 				}

// 				r_props.y += text_rect.height

// 				if new_actor, changed := gui_enum_selector(cut_property_row(&r_props), v.actor, "Actor"); changed {
// 					v.actor = new_actor
// 					record_undo()
// 				}

// 				if v.actor == .Player {
// 					l := rect_top_left(r_screen) + {40, 0.5}
// 					l1 := l
// 					l2 := l+{40, 0}
// 					l3 := l+{10, -30}
// 					rl.DrawTriangle(l, l2, l3,  ColorControlBackground)
// 					rl.DrawTriangleLines(l1, l2, l3, n_idx in m.selection ? ColorSelectedItem : ColorControlBorder)

// 					r := rect_top_right(r_screen) - {40, -0.5}
// 					r1 := r
// 					r2 := r+{-10, -30}
// 					r3 := r+{-40, 0}
// 					rl.DrawTriangle(r1, r2, r3,  ColorControlBackground)
// 					rl.DrawTriangleLines(r1, r2, r3, n_idx in m.selection ? ColorSelectedItem : ColorControlBorder)
// 				}

// 				for ch_idx in 0..<v.num_choices {
// 					c := &v.choices[ch_idx]
// 					cur_str := c.text

// 					row, _ := split_rect_top(r_props, MetricPropertyHeight, MetricPropertyMargin)
// 					left := cut_rect_left(&row, MetricPropertyLabelWidth + MetricPropertyLabelMargin, 0)

// 					if new_idx, changed := gui_int_field(cut_rect_right(&left, 18, 1), ch_idx); changed {
// 						new_idx = clamp(new_idx, 0, v.num_choices - 1)
// 						if new_idx != ch_idx {
// 							cur := c^
// 							replaced := v.choices[new_idx]
// 							v.choices[new_idx] = cur
// 							v.choices[ch_idx] = replaced

// 							for &conn in t.connections {
// 								if conn.from == n_idx {
// 									if conn.from_choice == ch_idx {
// 										conn.from_choice = new_idx
// 									} else if conn.from_choice == new_idx {
// 										conn.from_choice = ch_idx
// 									}
// 								}
// 							}

// 							record_undo()
// 							break
// 						}
// 					}

// 					if new_val := gui_push_button("c", cut_rect_right(&left, 15, 1), c.check_progress); new_val != c.check_progress {
// 						c.check_progress = new_val
// 						record_undo()
// 					}

// 					if new_val := gui_push_button("i", cut_rect_right(&left, 15, 1), c.check_item); new_val != c.check_item {
// 						c.check_item = new_val
// 						record_undo()
// 					}

// 					if gui_button("-", cut_rect_right(&left, 15, 1)) {
// 						delete(v.choices[ch_idx].text)
// 						v.choices[ch_idx].text = ""
// 						for i in ch_idx..<v.num_choices {
// 							if i + 1 < v.num_choices {
// 								v.choices[i] = v.choices[i + 1]
// 							}
// 						}
// 						v.num_choices -= 1

// 						#reverse for &c, c_idx in t.connections {
// 							if c.from == n_idx {
// 								if c.from_choice > ch_idx {
// 									c.from_choice -= 1
// 								} else if c.from_choice == ch_idx {
// 									unordered_remove(&t.connections, c_idx)
// 								}
// 							}
// 						}

// 						record_undo()
// 						break
// 					}

// 					multi_string_id := ui_next_id()
// 					text_rect := gui_multiline_string_field_rect(pos_from_rect(row), row.width, cur_str, false, multi_string_id)
// 					if new_str, changed := gui_multiline_string_field(text_rect, cur_str, "", multi_string_id); changed {
// 						delete(c.text)
// 						c.text = strings.clone(new_str)
// 						record_undo()
// 					}
// 					r_props.y += text_rect.height + MetricPropertyMargin

// 					if c.check_progress {
// 						row, _ := split_rect_top(r_props, MetricPropertyHeight, MetricPropertyMargin)

// 						if new_val := gui_push_button("not", cut_rect_right(&row, 30, 0), c.does_not_have_progress); new_val != c.does_not_have_progress {
// 							c.does_not_have_progress = new_val
// 							record_undo()
// 						}

// 						r_props.y += row.height + MetricPropertyMargin
// 						if new_progress_res, changed := gui_bitset_dropdown(row, c.progress_to_check, "Progres req."); changed {
// 							c.progress_to_check = new_progress_res
// 							record_undo()
// 						}
// 					}

// 					if c.check_item {
// 						row, _ := split_rect_top(r_props, MetricPropertyHeight, MetricPropertyMargin)

// 						if new_val := gui_push_button("not", cut_rect_right(&row, 30, 0), c.does_not_have_item); new_val != c.does_not_have_item {
// 							c.does_not_have_item = new_val
// 							record_undo()
// 						}

// 						r_props.y += row.height + MetricPropertyMargin
// 						if new_val, changed := gui_enum_dropdown(row, c.item_to_check, "Item"); changed {
// 							c.item_to_check = new_val
// 							record_undo()
// 						}
// 					}
// 				}

// 				add_choice_row := cut_property_row(&r_props)

// 				if v.num_choices < len(v.choices) {
// 					if gui_button("+ Choice", cut_rect_right(&add_choice_row, 80, 0)) {
// 						v.choices[v.num_choices].text = ""
// 						v.num_choices += 1
// 						record_undo()
// 					}
// 				}

// 				if new_val := gui_push_button("DA", cut_rect_left(&add_choice_row, 20, 0), v.dont_animate); new_val != v.dont_animate {
// 					v.dont_animate = new_val
// 					record_undo()
// 				}

// 				if new_val := gui_push_button("OK:", cut_rect_left(&add_choice_row, 22, 5), v.override_kind_enable); new_val != v.override_kind_enable {
// 					v.override_kind_enable = new_val
// 					record_undo()
// 				}

// 				if v.override_kind_enable {
// 					if override_kind, changed := gui_enum_dropdown(cut_rect_left(&add_choice_row, 100, 5), v.override_kind); changed {
// 						v.override_kind = override_kind
// 						record_undo()
// 					}
// 				}

// 				in_slot := in_slot_rect(n.pos)

// 				if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(in_slot, 5, 5)) {
// 					mouse_over_node_in = n_idx
// 				}

// 				rl.DrawRectangleRec(graph_screen_rect(in_slot, m.offset), mouse_over_node_in == n_idx ? ColorSelectedItem : ColorNodeInSlot)

// 				if v.num_choices == 0 {
// 					out_slot := out_slot_no_choice_rect(n)

// 					if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(out_slot, 5, 5)) {
// 						mouse_over_node_out = n_idx
// 					}

// 					rl.DrawRectangleRec(graph_screen_rect(out_slot, m.offset), mouse_over_node_out == n_idx ? ColorSelectedItem : ColorNodeInSlot)
// 				} else {
// 					for ch_idx in 0..<v.num_choices {
// 						choice_slot := out_slot_rect(n, ch_idx)

// 						if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(choice_slot, 5, 5)) {
// 							mouse_over_node_choice = ch_idx
// 							mouse_over_node_out = n_idx
// 						}

// 						rl.DrawRectangleRec(graph_screen_rect(choice_slot, m.offset), mouse_over_node_choice == ch_idx ? ColorSelectedItem : ColorNodeInSlot)
// 					}
// 				}

// 			case DialogueNodeVariantStart:
// 				gui_label("Start", cut_property_row(&r_props), .Center)

// 				out_slot := out_slot_no_choice_rect(n)

// 				if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(out_slot, 5, 5)) {
// 					 mouse_over_node_out = n_idx
// 				}

// 				rl.DrawRectangleRec(graph_screen_rect(out_slot, m.offset), mouse_over_node_out == n_idx ? ColorSelectedItem : ColorNodeInSlot)

// 			case DialogueNodeVariantProgressCheck:
// 				gui_label("Progress Check", cut_property_row(&r_props), .Center)

// 				if new_progress_res, changed := gui_bitset_dropdown(cut_property_row(&r_props), v.progress_to_check, "If"); changed {
// 					v.progress_to_check = new_progress_res
// 					record_undo()
// 				}

// 				gui_label("Else", cut_property_row(&r_props), .Right)

// 				in_slot := in_slot_rect(n.pos)

// 				if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(in_slot, 5, 5)) {
// 					mouse_over_node_in = n_idx
// 				}

// 				rl.DrawRectangleRec(graph_screen_rect(in_slot, m.offset), mouse_over_node_in == n_idx ? ColorSelectedItem : ColorNodeInSlot)

// 				true_slot := out_slot_rect(n, 0)
// 				false_slot := out_slot_rect(n, 1)

// 				if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(true_slot, 5, 5)) {
// 					mouse_over_node_out = n_idx
// 					mouse_over_node_choice = 0
// 				}

// 				if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(false_slot, 5, 5)) {
// 					mouse_over_node_out = n_idx
// 					mouse_over_node_choice = 1
// 				}

// 				rl.DrawRectangleRec(graph_screen_rect(true_slot, m.offset), mouse_over_node_choice == 0 ? ColorSelectedItem : ColorNodeInSlot)
// 				rl.DrawRectangleRec(graph_screen_rect(false_slot, m.offset), mouse_over_node_choice == 1 ? ColorSelectedItem : ColorNodeInSlot)

// 			case DialogueNodeVariantSetProgress:
// 				gui_label("Set Progress", cut_property_row(&r_props), .Center)

// 				if progress, changed := gui_enum_dropdown(cut_property_row(&r_props), v.progress, "Set"); changed {
// 					v.progress = progress
// 					record_undo()
// 				}

// 				in_slot := in_slot_rect(n.pos)

// 				if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(in_slot, 5, 5)) {
// 					mouse_over_node_in = n_idx
// 				}

// 				rl.DrawRectangleRec(graph_screen_rect(in_slot, m.offset), mouse_over_node_in == n_idx ? ColorSelectedItem : ColorNodeInSlot)

// 				out_slot := out_slot_no_choice_rect(n)

// 				if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(out_slot, 5, 5)) {
// 					mouse_over_node_out = n_idx
// 				}

// 				rl.DrawRectangleRec(graph_screen_rect(out_slot, m.offset), mouse_over_node_out == n_idx ? ColorSelectedItem : ColorNodeInSlot)

// 			case DialogueNodeVariantGivePlayerItem:
// 				gui_label("Give Item", cut_property_row(&r_props), .Center)

// 				if item, changed := gui_enum_dropdown(cut_property_row(&r_props), v.item, "Item"); changed {
// 					v.item = item
// 					record_undo()
// 				}

// 				in_slot := in_slot_rect(n.pos)

// 				if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(in_slot, 5, 5)) {
// 					mouse_over_node_in = n_idx
// 				}

// 				rl.DrawRectangleRec(graph_screen_rect(in_slot, m.offset), mouse_over_node_in == n_idx ? ColorSelectedItem : ColorNodeInSlot)

// 				out_slot := out_slot_no_choice_rect(n)

// 				if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(out_slot, 5, 5)) {
// 					mouse_over_node_out = n_idx
// 				}

// 				rl.DrawRectangleRec(graph_screen_rect(out_slot, m.offset), mouse_over_node_out == n_idx ? ColorSelectedItem : ColorNodeInSlot)

// 			case DialogueNodeVariantTriggerEvent:
// 				gui_label("Send Event", cut_property_row(&r_props), .Center)

// 				{
// 					type_names := make([dynamic]string, context.temp_allocator)
// 					types := make([dynamic]typeid, context.temp_allocator)
// 					append(&type_names, "(none)")
// 					append(&types, nil)
// 					type_info := runtime.type_info_base(type_info_of(Event))

// 					if osu_info, ok := type_info.variant.(runtime.Type_Info_Union); ok {
// 						for v in osu_info.variants {
// 							if named, ok := v.variant.(runtime.Type_Info_Named); ok {
// 								append(&type_names, named.name[len("Event"):])
// 								append(&types, v.id)
// 							}
// 						}
// 					}

// 					if new_val, changed := gui_dropdown(cut_property_row(&r_props), types[:], type_names[:], reflect.union_variant_typeid(v.event), "Event"); changed {
// 						reflect.set_union_variant_typeid(v.event, new_val)
// 						record_undo()
// 					}
// 				}

// 				#partial switch &e in v.event {
// 					case EventFadeEntityWithTag:
// 						if new_tag, changed := gui_enum_dropdown(cut_property_row(&r_props), e.tag, "Tag"); changed {
// 							e.tag = new_tag
// 							record_undo()
// 						}

// 					case EventDestroyEntityWithTag:
// 						if new_tag, changed := gui_enum_dropdown(cut_property_row(&r_props), e.tag, "Tag"); changed {
// 							e.tag = new_tag
// 							record_undo()
// 						}
// 				}

// 				in_slot := in_slot_rect(n.pos)

// 				if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(in_slot, 5, 5)) {
// 					mouse_over_node_in = n_idx
// 				}

// 				rl.DrawRectangleRec(graph_screen_rect(in_slot, m.offset), mouse_over_node_in == n_idx ? ColorSelectedItem : ColorNodeInSlot)

// 				out_slot := out_slot_no_choice_rect(n)

// 				if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(out_slot, 5, 5)) {
// 					mouse_over_node_out = n_idx
// 				}

// 				rl.DrawRectangleRec(graph_screen_rect(out_slot, m.offset), mouse_over_node_out == n_idx ? ColorSelectedItem : ColorNodeInSlot)

// 			case DialogueNodeVariantTakeItem:
// 				gui_label("Take Item", cut_property_row(&r_props), .Center)

// 				if new_val, changed := gui_enum_dropdown(cut_property_row(&r_props), v.item, "Item"); changed {
// 					v.item = new_val
// 					record_undo()
// 				}

// 				in_slot := in_slot_rect(n.pos)

// 				if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(in_slot, 5, 5)) {
// 					mouse_over_node_in = n_idx
// 				}

// 				rl.DrawRectangleRec(graph_screen_rect(in_slot, m.offset), mouse_over_node_in == n_idx ? ColorSelectedItem : ColorNodeInSlot)

// 				out_slot := out_slot_no_choice_rect(n)

// 				if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(out_slot, 5, 5)) {
// 					mouse_over_node_out = n_idx
// 				}

// 				rl.DrawRectangleRec(graph_screen_rect(out_slot, m.offset), mouse_over_node_out == n_idx ? ColorSelectedItem : ColorNodeInSlot)

// 			case DialogueNodeVariantItemCheck:
// 				gui_label("Item Check", cut_property_row(&r_props), .Center)

// 				if new_val, changed := gui_enum_dropdown(cut_property_row(&r_props), v.item, "Item"); changed {
// 					v.item = new_val
// 					record_undo()
// 				}

// 				gui_label("Else", cut_property_row(&r_props), .Right)

// 				in_slot := in_slot_rect(n.pos)

// 				if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(in_slot, 5, 5)) {
// 					mouse_over_node_in = n_idx
// 				}

// 				rl.DrawRectangleRec(graph_screen_rect(in_slot, m.offset), mouse_over_node_in == n_idx ? ColorSelectedItem : ColorNodeInSlot)

// 				true_slot := out_slot_rect(n, 0)
// 				false_slot := out_slot_rect(n, 1)

// 				if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(true_slot, 5, 5)) {
// 					mouse_over_node_out = n_idx
// 					mouse_over_node_choice = 0
// 				}

// 				if mouse_in_rect(rect) && point_in_rect(mouse_wp, pad_rect(false_slot, 5, 5)) {
// 					mouse_over_node_out = n_idx
// 					mouse_over_node_choice = 1
// 				}

// 				rl.DrawRectangleRec(graph_screen_rect(true_slot, m.offset), mouse_over_node_choice == 0 ? ColorSelectedItem : ColorNodeInSlot)
// 				rl.DrawRectangleRec(graph_screen_rect(false_slot, m.offset), mouse_over_node_choice == 1 ? ColorSelectedItem : ColorNodeInSlot)
// 		}


// 		rl.DrawRectangleLinesEx(r_screen, 1, n_idx in m.selection ? ColorSelectedItem : ColorControlBorder)
// 	}

// 	add_node :: proc($T: typeid, pos: Vec2, t: ^DialogueTree, m: ^DialogueEditorState) -> int {
// 		new_node := DialogueNode{ pos = pos }
// 		new_node.variant = T {}

// 		reused := false
// 		new_node_idx: int

// 		for n, idx in t.nodes {
// 			if n.unused {
// 				t.nodes[idx] = new_node
// 				reused = true
// 				new_node_idx = idx
// 				break
// 			}
// 		}

// 		if !reused {
// 			new_node_idx = len(t.nodes)
// 			append(&t.nodes, new_node)
// 		}

// 		clear(&m.selection)
// 		m.selection[new_node_idx] = {}
// 		return new_node_idx
// 	}

// 	switch s in m.deis {
// 		case DEIS_None:
// 			if ui.hover == 0 && ui.active == 0 && ui.previous_active == 0 {
// 				if mouse_over_node >= 0 {
// 					if rl.IsMouseButtonPressed(.LEFT) {
// 						if rl.IsKeyDown(.LEFT_CONTROL) {
// 							m.selection[mouse_over_node] = {}
// 						} else {
// 							if !(mouse_over_node in m.selection) {
// 								clear(&m.selection)
// 								m.selection[mouse_over_node] = {}
// 							}

// 							m.deis = DEIS_DragSelection {  }

// 							for n_idx in m.selection {
// 								t.nodes[n_idx].transient_pos = linalg.floor(t.nodes[n_idx].pos/DialogueNodeSnapDistance)*DialogueNodeSnapDistance
// 							}
// 						}
// 					}
// 				} else if mouse_over_node_in >= 0 {
// 					if rl.IsMouseButtonPressed(.LEFT) {
// 						m.deis = DEIS_Connecting { from = -1, to = mouse_over_node_in, from_choice = -1 }
// 					} else if rl.IsMouseButtonPressed(.RIGHT) {
// 						#reverse for c, c_idx in t.connections {
// 							if c.to == mouse_over_node_in {
// 								unordered_remove(&t.connections, c_idx)
// 								break
// 							}
// 						}
// 					}
// 				} else if mouse_over_node_out >= 0 {
// 					if rl.IsMouseButtonPressed(.LEFT) {
// 						m.deis = DEIS_Connecting { from = mouse_over_node_out, from_choice = mouse_over_node_choice, to = -1 }
// 					} else if rl.IsMouseButtonPressed(.RIGHT) {
// 						#reverse for c, c_idx in t.connections {
// 							if c.from == mouse_over_node_out && (mouse_over_node_choice == -1 || c.from_choice == mouse_over_node_choice) {
// 								unordered_remove(&t.connections, c_idx)
// 								break
// 							}
// 						}
// 					}
// 				} else {
// 					if mouse_in_rect(rect) {
// 						if rl.IsKeyPressed(.SPACE) {
// 							add_node(DialogueNodeVariantNormal, mouse_wp, t, m)
// 							record_undo()
// 						} else if rl.IsKeyPressed(.ENTER) {
// 							add_node(DialogueNodeVariantStart, mouse_wp, t, m)
// 							record_undo()
// 						} else if rl.IsKeyPressed(.BACKSPACE) {
// 							add_node(DialogueNodeVariantProgressCheck, mouse_wp, t, m)
// 							record_undo()
// 						} else if rl.IsKeyPressed(.P) {
// 							add_node(DialogueNodeVariantSetProgress, mouse_wp, t, m)
// 							record_undo()
// 						} else if rl.IsKeyPressed(.I) {
// 							add_node(DialogueNodeVariantGivePlayerItem, mouse_wp, t, m)
// 							record_undo()
// 						} else if rl.IsKeyPressed(.E) {
// 							add_node(DialogueNodeVariantTriggerEvent, mouse_wp, t, m)
// 							record_undo()
// 						} else if rl.IsKeyPressed(.T) {
// 							add_node(DialogueNodeVariantTakeItem, mouse_wp, t, m)
// 							record_undo()
// 						} else if rl.IsKeyPressed(.C) {
// 							add_node(DialogueNodeVariantItemCheck, mouse_wp, t, m)
// 							record_undo()
// 						}

// 						if rl.IsMouseButtonPressed(.LEFT) {
// 							clear(&m.selection)
// 							m.deis = DEIS_Select{start = mouse_wp}
// 						}
// 					}
// 				}
// 			}

// 			if ui.active == 0 &&  rl.IsKeyPressed(.DELETE) {
// 				for idx, _ in m.selection {
// 					if idx < len(t.nodes) {
// 						t.nodes[idx] = DialogueNode { unused = true }
// 					}
// 				}

// 				clear(&m.selection)

// 				record_undo()
// 			}

// 		case DEIS_DragSelection:
// 			for n_idx in m.selection {
// 				t.nodes[n_idx].transient_pos += rl.GetMouseDelta() / dpi_scale()
// 				t.nodes[n_idx].pos = linalg.floor(t.nodes[n_idx].transient_pos / DialogueNodeSnapDistance) * DialogueNodeSnapDistance
// 			}

// 			if rl.IsMouseButtonReleased(.LEFT) {
// 				m.deis = DEIS_None{}
// 				record_undo()
// 			}

// 		case DEIS_Connecting:
// 			if s.from == -1 {
// 				from_pos := mouse_pos()
// 				if mouse_over_node_out >= 0 {
// 					from_pos = rect_middle(out_slot_rect(t.nodes[mouse_over_node_out], mouse_over_node_choice)) - m.offset
// 				}

// 				rl.DrawLineEx(from_pos, rect_middle(in_slot_rect(t.nodes[s.to].pos)) - m.offset, 3, ColorSelectedItem)
// 			} else {
// 				to_pos := mouse_pos()
// 				if mouse_over_node_in >= 0 {
// 					to_pos = rect_middle(in_slot_rect(t.nodes[mouse_over_node_in].pos)) - m.offset
// 				}

// 				rl.DrawLineEx(rect_middle(out_slot_rect(t.nodes[s.from], s.from_choice)) - m.offset, to_pos, 3, ColorSelectedItem)
// 			}

// 			if rl.IsMouseButtonReleased(.LEFT) {
// 				if s.from == -1 {
// 					if mouse_over_node_out >= 0 {
// 						append(&t.connections, DialogueConnection { from = mouse_over_node_out, from_choice = mouse_over_node_choice, to = s.to })
// 						record_undo()
// 					} else {
// 						new_node_idx := add_node(DialogueNodeVariantNormal, mouse_wp, t, m)
// 						out_slot_r := out_slot_no_choice_rect(t.nodes[new_node_idx])
// 						t.nodes[new_node_idx].pos -= rect_middle(out_slot_r) - t.nodes[new_node_idx].pos
// 						append(&t.connections, DialogueConnection { from = new_node_idx, from_choice = -1, to = s.to })
// 						record_undo()
// 					}
// 				} else {
// 					if mouse_over_node_in >= 0 {
// 						append(&t.connections, DialogueConnection { from = s.from, from_choice = s.from_choice, to = mouse_over_node_in })
// 						record_undo()
// 					} else {
// 						new_node_idx := add_node(DialogueNodeVariantNormal, mouse_wp, t, m)
// 						in_slot_r := in_slot_rect(t.nodes[new_node_idx].pos)
// 						t.nodes[new_node_idx].pos -= rect_middle(in_slot_r) - t.nodes[new_node_idx].pos
// 						append(&t.connections, DialogueConnection { from = s.from, from_choice = s.from_choice, to = new_node_idx })
// 						record_undo()
// 					}
// 				}

// 				m.deis = DEIS_None{}
// 			}

// 		case DEIS_Select:
// 			r := fix_negative_rect(rect_from_pos_size(s.start, mouse_wp - s.start))
// 			rl.DrawRectangleRec(graph_screen_rect(r, m.offset), color_a(rl.GREEN.rgb, 50))

// 			for n in t.nodes {
// 				if n.unused {
// 					continue
// 				}

// 				nr := rect_from_pos_size(n.pos, node_size(n))

// 				if rl.CheckCollisionRecs(r, nr) {
// 					rl.DrawRectangleLinesEx(graph_screen_rect(nr, m.offset), 1, ColorSelectedItem)
// 				}
// 			}

// 			if rl.IsMouseButtonReleased(.LEFT) {
// 				m.deis = DEIS_None{}

// 				for n, n_idx in t.nodes {
// 					if n.unused {
// 						continue
// 					}

// 					nr := rect_from_pos_size(n.pos, node_size(n))

// 					if rl.CheckCollisionRecs(r, nr) {
// 						m.selection[n_idx] = {}
// 					}
// 				}
// 			}
// 	}


// 	rl.EndScissorMode()
// }
