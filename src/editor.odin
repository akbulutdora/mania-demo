package game

// import "core:fmt"
// import "core:math"
// import "core:math/linalg"
// import "core:slice"
// import "core:strings"
// import "core:reflect"
// import "core:runtime"
// import "core:intrinsics"
// import "core:os"
// import "core:log"

// import "core:encoding/json"
// import rl "vendor:raylib"

// UndoStackSize :: 100

// EditorMemory :: struct {
// 	mode: EditMode,
// 	edit_mode_place_tiles: EditModePlaceTiles,
// 	edit_mode_place_entities: EditModePlaceEntities,
// 	edit_mode_entity_properties: EditModeEntityProperties,
// 	edit_mode_edit_entity_types: EditModeEditEntityTypes,
// 	edit_mode_move: EditModeMove,
// 	dialogue_editor_state: DialogueEditorState,
// 	entity_textures: []TextureHandle,
// 	selection: [dynamic]int,
// 	zoom: f32,
// 	snapping: bool,
// 	checker_texture: TextureHandle,
// 	layer: int,
// 	layer_view_mode: LayerViewMode,
// 	sample_all_layers: bool,
// 	level_name: LevelName,
// 	tileset: TextureHandle,
// 	tileset_padded: rl.Texture,
// 	font: rl.Font,
// 	pixel_filter_shader: rl.Shader,

// 	world: World,
// 	undo_stack: [UndoStackSize]SerializedState,
// 	undo_stack_first_idx: int,
// 	undo_stack_last_idx: int,
// 	current_undo_step: int,

// 	camera_pos: Vec2,

// 	clear_color: rl.Color,

// 	saved_at: f64,
// 	hide_extras: bool,
// 	save_error: bool,

// 	edited_dialogue: DialogueName,
// }

// EditorObjectTexture :: struct {
// 	name: Hash,
// 	tex: TextureHandle,
// }

// LayerViewMode :: enum {
// 	All,
// 	CurrentAndBehind,
// 	Current,
// }

// EditMode :: union {
// 	^EditModePlaceTiles,
// 	^EditModePlaceEntities,
// 	^EditModeEntityProperties,
// 	^EditModeEditEntityTypes,
// 	^EditModeMove,
// 	^DialogueEditorState,
// }

// EditModePlaceTiles :: struct {
// 	brush_tile: int,
// 	selected_tiles: map[int]struct{},
// 	flip_x: bool,
// 	flip_y: bool,
// 	last_place_pos_x: int,
// 	last_place_pos_y: int,
// 	has_placed_tile: bool,
// 	has_removed_tile: bool,
// }

// EditModePlaceEntities :: struct {
// 	selected_type: int,
// 	dragging: bool,
// 	drag_start: Vec2,
// 	flip_x: bool,
// }

// // EditModeEntityProperties

// EMEPStateDefault :: struct {}

// EMEPStateEditSpline :: struct {
// 	selected_point: int,
// }

// EMEPStateDragSplinePointType :: enum {
// 	Point,
// 	ControlIn,
// 	ControlOut,
// }

// EMEPStateMouseDownSplinePoint :: struct {
// 	idx: int,
// 	type: EMEPStateDragSplinePointType,
// 	mouse_start: Vec2,
// }

// EMEPStateDragSplinePoint :: struct {
// 	idx: int,
// 	type: EMEPStateDragSplinePointType,
// }

// EditModeEntityProperties :: struct {
// 	edited: EntityHandle,

// 	state: union #no_nil {
// 		EMEPStateDefault,
// 		EMEPStateEditSpline,
// 		EMEPStateMouseDownSplinePoint,
// 		EMEPStateDragSplinePoint,
// 	},
// }

// EditModeEditEntityTypes :: struct {
// 	edited_type: EntityTypeHandle,
// 	camera_pos: Vec2,
// 	camera_zoom: f32,
// 	dragging: bool,
// 	drag_start: Vec2,

// 	preview_anim: AnimationInstance,
// }

// EMEState_Default :: struct {
// }

// EMEState_Selecting :: struct {
// 	start: Vec2,
// }

// EMEState_Moving :: struct {
// 	selected_entities: []EntityHandle,
// 	selected_tiles: []int,
// }

// EditModeMove :: struct {
// 	state: union #no_nil {
// 		EMEState_Default,
// 		EMEState_Selecting,
// 		EMEState_Moving,
// 	},
// }


// reload_editor_entity_textures :: proc(em: ^EditorMemory) {
// 	delete(em.entity_textures)
// 	entity_textures: [dynamic]TextureHandle

// 	for t, name in all_textures {
// 		if strings.has_prefix(t.path, "object_art/") {
// 			if th := get_texture_handle(name); th != HandleNone {
// 				append(&entity_textures, th)
// 			} else {
// 				append(&entity_textures, load_texture(t.path, t.path_hash))
// 			}
// 		}
// 	}

// 	em.entity_textures = entity_textures[:]
// }

// editor_refresh_globals :: proc(editor_memory: ^EditorMemory) {
// 	em = editor_memory
// }

// @(private="file")
// em: ^EditorMemory

// record_undo :: proc() {
// 	s := serialize_world(em.world)
// 	em.current_undo_step += 1

// 	if em.current_undo_step == UndoStackSize {
// 		em.current_undo_step = 0
// 	}

// 	em.undo_stack_last_idx = em.current_undo_step

// 	if em.current_undo_step == em.undo_stack_first_idx {
// 		em.undo_stack_first_idx += 1

// 		if em.undo_stack_first_idx == UndoStackSize {
// 			em.undo_stack_first_idx = 0
// 		}
// 	}

// 	delete_serialized_state(em.undo_stack[em.current_undo_step])
// 	em.undo_stack[em.current_undo_step] = s
// }

// perform_undo :: proc() {
// 	if em.current_undo_step == em.undo_stack_first_idx {
// 		return
// 	}

// 	em.current_undo_step -= 1

// 	if em.current_undo_step == -1 {
// 		em.current_undo_step = UndoStackSize - 1
// 	}

// 	s := em.undo_stack[em.current_undo_step]
// 	delete_world(em.world)
// 	em.world = create_world(s)
// }

// perform_redo :: proc() {
// 	if em.current_undo_step == em.undo_stack_last_idx {
// 		return
// 	}

// 	em.current_undo_step += 1

// 	if em.current_undo_step == UndoStackSize {
// 		em.current_undo_step = 0
// 	}

// 	s := em.undo_stack[em.current_undo_step]
// 	delete_world(em.world)
// 	em.world = create_world(s)
// }

// create_entity_reference :: proc(e: EntityHandle) -> EntityReference {
// 	if e, ok := ha_get(em.world.entities, e); ok {
// 		return EntityReference(e.id)
// 	}
// 	return EntityReferenceNone
// }

// Level :: struct {
// 	tiles: []Tile,
// 	entities: []Entity,
// }

// event_property :: proc(e: ^Event, r: ^Rect, label: string) {
// 	w := &em.world
// 	camera := get_camera(em.camera_pos, em.zoom)
// 	type_names := make([dynamic]string, context.temp_allocator)
// 	types := make([dynamic]typeid, context.temp_allocator)
// 	append(&type_names, "(none)")
// 	append(&types, nil)
// 	type_info := runtime.type_info_base(type_info_of(Event))

// 	if osu_info, ok := type_info.variant.(runtime.Type_Info_Union); ok {
// 		for v in osu_info.variants {
// 			if named, ok := v.variant.(runtime.Type_Info_Named); ok {
// 				append(&type_names, named.name[len("Event"):])
// 				append(&types, v.id)
// 			}
// 		}
// 	}

// 	before := reflect.union_variant_typeid(e^)
// 	cur, changed := gui_dropdown(cut_property_row(r), types[:], type_names[:], before, label)

// 	if changed {
// 		reflect.set_union_variant_typeid(e^, cur)
// 		record_undo()
// 	}

// 	#partial switch &ev in e {
// 		case EventAnimateAlongSpline:
// 			if new_entity, changed := gui_entity_picker(cut_property_row(r), ev.entity, w.entities, em.sample_all_layers, em.layer, camera, "Entity"); changed {
// 				ev.entity = new_entity
// 				record_undo()
// 			}

// 			if new_entity, changed := gui_entity_picker(cut_property_row(r), ev.spline, w.entities, em.sample_all_layers, em.layer, camera, "Spline"); changed {
// 				ev.spline = new_entity
// 				record_undo()
// 			}
// 		case EventSetProgressFlag:
// 			if new_progress_res, changed := gui_enum_dropdown(cut_property_row(r), ev.flag, "Progress Flag"); changed {
// 				ev.flag = new_progress_res
// 				record_undo()
// 			}

// 		case EventRocketSplineDone:
// 			if new_entity, changed := gui_entity_picker(cut_property_row(r), ev.spline, w.entities, em.sample_all_layers, em.layer, camera, "Spline"); changed {
// 				ev.spline = new_entity
// 				record_undo()
// 			}

// 		case EventTeleportEntity:
// 			if new_entity, changed := gui_entity_picker(cut_property_row(r), ev.entity, w.entities, em.sample_all_layers, em.layer, camera, "Entity"); changed {
// 				ev.entity = new_entity
// 				record_undo()
// 			}

// 			if new_entity, changed := gui_entity_picker(cut_property_row(r), ev.target, w.entities, em.sample_all_layers, em.layer, camera, "Target"); changed {
// 				ev.target = new_entity
// 				record_undo()
// 			}
// 	}
// }

// serialize_world :: proc(w: World) -> SerializedState {
// 	num_entity_types := 0
// 	et_iter := ha_make_iter(w.entity_types)
// 	for et in ha_iter(&et_iter) {
// 		if !is_builtin_entity_type(et) && et.variant != nil {
// 			num_entity_types += 1
// 		}
// 	}

// 	entity_types := make([]EntityType, num_entity_types, context.temp_allocator)
// 	et_written := 0

// 	et_iter = ha_make_iter(w.entity_types)
// 	for et in ha_iter(&et_iter) {
// 		if is_builtin_entity_type(et) || et.variant == nil {
// 			continue
// 		}

// 		entity_types[et_written] = et
// 		et_written += 1
// 	}

// 	ser: Ser
// 	ser_init_writer(&ser)
// 	assert(ser_slice(&ser, &entity_types))
// 	serialized_entity_types := ser.root

// 	entities := make([dynamic]Entity, context.temp_allocator)

// 	e_iter := ha_make_iter(w.entities)
// 	for e in ha_iter(&e_iter) {
// 		append(&entities, e)
// 	}

// 	//slice.sort_by(entities[:], proc(i, j: Entity) -> bool { return i.id < j.id })

// /*	slice.sort_by(tiles, proc(i, j: Tile) -> bool {
// 		if i.x == j.x {
// 			if i.y == j.y {
// 				return i.layer < j.layer
// 			} else {
// 				return i.y < j.y
// 			}
// 		} else {
// 			return i.x < j.x
// 		}
// 	})*/

// 	level := Level {
// 		tiles = w.tiles[:],
// 		entities = entities[:],
// 	}

// 	ser_init_writer(&ser)
// 	assert(ser_level(&ser, &level))
// 	serialized_level := ser.root

// 	ser_init_writer(&ser)
// 	dialogue_trees := w.dialogue_trees
// 	assert(ser_fixed_array(&ser, &dialogue_trees))
// 	serialized_dialogue_trees := ser.root

// 	return SerializedState {
// 		entity_types = serialized_entity_types,
// 		level = serialized_level,
// 		dialogue_trees = serialized_dialogue_trees,
// 	}
// }

// DataMarshalOptions := json.Marshal_Options {
// 	spec = .Bitsquid,
// 	pretty = true,
// 	use_spaces = true,
// 	spaces = 4,
// 	mjson_keys_use_equal_sign = true,
// 	sort_maps_by_key = true,
// }

// save :: proc() {
// 	em.saved_at = rl.GetTime()
// 	em.save_error = false
// 	state := serialize_world(em.world)
// 	level_filename := level_filename_from_level_name(em.level_name)

// 	if level_filename == "" {
// 		log.error("Bad level name")
// 		return
// 	}

// 	if entity_types, err := json.marshal(state.entity_types, DataMarshalOptions, context.temp_allocator); err == nil {
// 		if !os.write_entire_file(EntityTypesFilename, entity_types) {
// 			log.errorf("Failed to write to {0}", EntityTypesFilename)
// 			em.save_error = true
// 		}
// 	} else {
// 		log.errorf("Failed to convert entity types to text: {0}", err)
// 		em.save_error = true
// 	}

// 	if level, err := json.marshal(state.level, DataMarshalOptions, context.temp_allocator); err == nil {
// 		if !os.write_entire_file(level_filename, level) {
// 			log.errorf("Failed to write to {0}", level_filename)
// 			em.save_error = true
// 		}
// 	} else {
// 		log.error("Failed to convert level to text: {0}", err)
// 		em.save_error = true
// 	}

// 	if dialogue_trees, err := json.marshal(state.dialogue_trees, DataMarshalOptions, context.temp_allocator); err == nil {
// 		if !os.write_entire_file(DialoguesFilename, dialogue_trees) {
// 			log.errorf("Failed to write to {0}", DialoguesFilename)
// 			em.save_error = true
// 		}
// 	} else {
// 		log.errorf("Failed to convert dialogues to text: {0}", err)
// 		em.save_error = true
// 	}

// 	delete_serialized_state(state)
// }

// mouse_world_position :: proc(camera: rl.Camera2D) -> Vec2 {
// 	return linalg.floor(rl.GetScreenToWorld2D(mouse_pos(), camera))
// }

// any_modifier_held :: proc() -> bool {
// 	return rl.IsKeyDown(.LEFT_SHIFT) &&
// 		   rl.IsKeyDown(.LEFT_CONTROL) &&
// 		   rl.IsKeyDown(.LEFT_ALT) &&
// 		   rl.IsKeyDown(.LEFT_SUPER) &&
// 		   rl.IsKeyDown(.RIGHT_SHIFT) &&
// 		   rl.IsKeyDown(.RIGHT_CONTROL) &&
// 		   rl.IsKeyDown(.RIGHT_ALT) &&
// 		   rl.IsKeyDown(.RIGHT_SUPER)
// }

// draw_spline :: proc(rens: ^[dynamic]Renderable, p: Vec2, s: Spline) {
// 	for p_idx in 0..<len(s.points) {
// 		cur := s.points[p_idx]

// 		append(rens, Renderable {
// 			variant = RenderableCircle {
// 				pos = cur.point + p,
// 				radius = 0.8,
// 				color = rl.YELLOW,
// 			},

// 			layer = 100,
// 		})

// 		append(rens, Renderable {
// 			variant = RenderableCircle {
// 				pos = cur.point + p,
// 				radius = 1,
// 				color = rl.BLACK,
// 			},

// 			layer = 99,
// 		})

// 		append(rens, Renderable {
// 			variant = RenderableCircle {
// 				pos = cur.control_in + p,
// 				radius = 1,
// 				color = rl.RED,
// 			},

// 			layer = 100,
// 		})

// 		append(rens, Renderable {
// 			variant = RenderableCircle {
// 				pos = cur.control_out + p,
// 				radius = 1,
// 				color = rl.RED,
// 			},

// 			layer = 100,
// 		})

// 		append(rens, Renderable {
// 			variant = RenderableLine {
// 				start = cur.point + p,
// 				end = cur.control_in + p,
// 				color = color_a(rl.WHITE.rgb, 255),
// 			},
// 			layer = 100,
// 		})

// 		append(rens, Renderable {
// 			variant = RenderableLine {
// 				start = cur.point + p,
// 				end = cur.control_out + p,
// 				color = color_a(rl.WHITE.rgb, 255),
// 			},
// 			layer = 100,
// 		})

// 		if p_idx != len(s.points) - 1 {
// 			next := s.points[p_idx + 1]
// 			append(rens, Renderable {
// 				variant = RenderableLineBezierCubic {
// 					start = cur.point + p,
// 					end = next.point + p,
// 					start_control = cur.control_out + p,
// 					end_control = next.control_in + p,
// 					color = rl.BLACK,
// 				},

// 				layer = 100,
// 			})
// 		}
// 	}
// }

// get_entity_kind_placeholder_tex :: proc(et: EntityKind) -> (tex: rl.Texture, sr: Rect) {
// 	name: TextureName

// 	switch et {
// 		case .Legacy: return {}, {}
// 		case .RockWall: name = .RockWall
// 		case .Butter: name = .Butter
// 		case .RootCellarDoor: name = .RootCellarDoorAnim
// 		case .FlourTree: name = .FlourTree
// 		case .Stone: name = .NpcStone
// 		case .Waterfall: name = .Waterfall
// 		case .BaseballBat: name = .Mallet
// 		case .Bird: name = .Bird
// 		case .OnionSeed: name = .OnionSeed
// 		case .Soil: name = .Soil
// 		case .Rocket: name = .SpaceOnionTalk
// 		case .AngryDoor: name = .InsideDoor
// 		case .Egg: name = .Egg
// 		case .FrontDoor: name = .FrontDoor
// 		case .Cat: name = .CatIdle
// 		case .Squirrel: name = .Squirrel
// 		case .Acorn: name = .Acorn
// 		case .AcornAnimator:
// 		case .Hatch: name = .Hatch
// 		case .BatterBowl: name = .BatterBowl
// 		case .DrawBindingLeft: name = .BindingLeft
// 		case .DrawBindingJump: name = .BindingUp
// 		case .DrawBindingJumpHold: name = .BindingUpHold
// 		case .Opening: name = .Opening
// 		case .HiddenOpening: name = .OpeningHidden
// 		case .NarrowOpening: name = .ButterReturn
// 		case .KluckePortrait: name = .KluckePortrait
// 		case .DrawBindingUse: name = .BindingUse
// 		case .DrawBindingRight: name = .BindingRight
// 		case .LakritsPortrait: name = .LakritsPortrait
// 		case .LillemorPortrait: name = .LillemorPortrait
// 		case .SmallEggShell: name = .EggShell
// 		case .Easel: name = .Easel
// 		case .PontusPortrait: name = .PontusPortrait
// 		case .PontusPlanet: name = .PontusPlanet
// 		case .CatCloud: name = .CatCloud
// 		case .PancakeStack: name = .Pancake
// 		case .Globe: name = .Globe
// 		case .CaveFace: name = .CaveFace
// 		case .UseAbilityTutorial: name = .AbilityTutorial

// 		case .Unused:
// 	}


// 	if name != .None {
// 		nf := animation_num_frames(name)
// 		tex = get_texture_by_name(name)
// 		sr = draw_texture_source_rect(tex, false)

// 		if nf > 1 {
// 			sr.width /= f32(nf)
// 		}
// 	}

// 	return
// }

// get_entity_type_placeholder_tex :: proc(et: EntityType) -> (tex: rl.Texture, sr: Rect) {
// 	switch etv in et.variant {
// 		case EntityTypeStaticObject:
// 			tex = get_texture(etv.texture)
// 			sr = { 0, 0, f32(tex.width), f32(tex.height) }
// 		case EntityTypeAnimatedObject:
// 			tex = get_texture(etv.texture)
// 			sr = { 0, 0, f32(int(tex.width) / max(etv.num_frames, 1)), f32(tex.height) }
// 		case EntityTypeBuiltin:
// 			#partial switch etv.variant {
// 				case .None:

// 				case .Trigger:
// 					tex = get_texture_by_name(.Trigger)
// 					sr = { 0, 0, f32(int(tex.width) / 1), f32(tex.height) }

// 				case .Interactable:
// 					tex = get_texture_by_name(.Position)
// 					sr = { 0, 0, f32(int(tex.width) / 1), f32(tex.height) }

// 				case .Spline:
// 					tex = get_texture_by_name(.Spline)
// 					sr = { 0, 0, f32(int(tex.width) / 1), f32(tex.height) }

// 				case .Collider:
// 					tex = get_texture_by_name(.Collider)
// 					sr = { 0, 0, f32(int(tex.width) / 1), f32(tex.height) }
// 			}
// 	}

// 	return
// }

// entity_picking_rect :: proc(e: ^Entity) -> Rect {
// 	if e.kind == .Legacy {
// 		#partial switch &v in e.variant {
// 			case Trigger:
// 				if em.hide_extras {
// 					return {}
// 				}

// 				return trigger_world_rect(entity_inst(e, &v))

// 			case StaticCollider:
// 				if em.hide_extras {
// 					return {}
// 				}

// 				return rect_add_pos(v.collider, e.pos)

// 			case PlayerCat, Rocket, UNPC, Pickup, StaticObject, AnimatedObject, Spline, Usable, SplineEvaluator:
// 				if et, ok := ha_get(em.world.entity_types, e.type); ok {
// 					_, r := get_entity_type_placeholder_tex(et)
// 					s := Vec2 { r.width, r.height }

// 					return rect_from_pos_size(e.pos + parallax_offset(e.parallax, camera_middle(get_camera(em.camera_pos, em.zoom)), e.parallax_y_lock) - s * 0.5, s)
// 				}
// 		}
// 	} else {
// 		_, r := get_entity_kind_placeholder_tex(e.kind)
// 		s := Vec2 { r.width, r.height }
// 		return rect_from_pos_size(e.pos + parallax_offset(e.parallax, camera_middle(get_camera(em.camera_pos, em.zoom)), e.parallax_y_lock) - s * 0.5, s)
// 	}

// 	return {}
// }

// find_entity_under_cursor :: proc(entities: HandleArray(Entity, EntityHandle), sample_all_layers: bool, active_layer: int, camera: rl.Camera2D, cur: EntityHandle) -> EntityHandle {
// 	hits := make([dynamic]EntityHandle, context.temp_allocator)

// 	e_iter := ha_make_iter(entities)
// 	for e, eh in ha_iter_ptr(&e_iter) {
// 		if !sample_all_layers && e.layer != active_layer {
// 			continue
// 		}

// 		r := screen_rect(entity_picking_rect(e), camera)

// 		if mouse_in_rect(r) {
// 			append(&hits, eh)
// 		}
// 	}

// 	if len(hits) == 0 {
// 		return EntityHandleNone
// 	}

// 	slice.sort_by(hits[:], proc(i, j: EntityHandle) -> bool { return i.idx < j.idx })

// 	if cur != EntityHandleNone {
// 		for h, h_idx in hits {
// 			if h == cur {
// 				cur_hidx := h_idx + 1

// 				if cur_hidx >= len(hits) {
// 					cur_hidx = 0
// 				}

// 				return hits[cur_hidx]
// 			}
// 		}
// 	}

// 	return slice.last(hits[:])
// }

// edit_mode_init :: proc(ss_in: SerializedState, level_name: LevelName) {
// 	em.edit_mode_entity_properties.state = EMEPStateDefault {}

// 	ss := clone_serialized_state(ss_in)
// 	em.undo_stack[0] = ss
// 	em.current_undo_step = 0
// 	em.undo_stack_first_idx = 0
// 	em.undo_stack_last_idx = 0
// 	em.world = create_world(ss)

// 	if em.mode == nil {
// 		em.mode = &em.edit_mode_place_tiles
// 	}

// 	em.snapping = true
// 	em.level_name = level_name
// }

// edit_mode_shutdown :: proc() {
// 	delete_world(em.world)

// 	for &s in em.undo_stack {
// 		delete_serialized_state(s)
// 	}

// 	em.undo_stack = {}

// 	if m, ok := em.edit_mode_move.state.(EMEState_Moving); ok {
// 		delete(m.selected_tiles)
// 		delete(m.selected_entities)
// 	}

// 	delete(em.dialogue_editor_state.selection)
// 	em.dialogue_editor_state = {}

// 	em.edit_mode_move.state = EMEState_Default{}
// }

// parallax_offset :: proc(parallax: f32, camera_pos: Vec2, lock_y: bool) -> Vec2 {
// 	offset := camera_pos * parallax

// 	if lock_y {
// 		offset.y = 0
// 	}

// 	return offset
// }

// camera_middle :: proc(cam: rl.Camera2D) -> Vec2 {
// 	return rl.GetScreenToWorld2D(cam.offset, cam)
// }

// PlaceableEntityTypes :: union {
// 	EntityKind, EntityType,
// }

// get_all_placeable_entity_types :: proc(entity_types: HandleArray(EntityType, EntityTypeHandle)) -> []PlaceableEntityTypes {
// 	pet := make([dynamic]PlaceableEntityTypes, context.temp_allocator)

// 	for k in EntityKind {
// 		append(&pet, k)
// 	}

// 	et_iter := ha_make_iter(entity_types)
// 	for et in ha_iter(&et_iter) {
// 		append(&pet, et)
// 	}

// 	return pet[:]
// }

// edit_mode_update :: proc() {
// 	ui_reset()

// 	if rl.IsKeyPressed(.Z) && rl.IsKeyDown(.LEFT_CONTROL) {
// 		perform_undo()
// 	}

// 	if rl.IsKeyPressed(.Y) && rl.IsKeyDown(.LEFT_CONTROL) {
// 		perform_redo()
// 	}

// 	if rl.IsKeyPressed(.P) {
// 		fmt.println(mouse_world_position(get_camera(em.camera_pos, em.zoom)))
// 	}

// 	rl.BeginShaderMode(em.pixel_filter_shader)
// 	rl.BeginBlendMode(.ALPHA_PREMULTIPLY)

// 	rl.ClearBackground(em.clear_color)

// 	edit_mode_draw_world :: proc(em: ^EditorMemory, rect: Rect) {
// 		in_rect := mouse_in_rect(rect)
// 		world := &em.world

// 		if in_rect {
// 			mwm := rl.GetMouseWheelMove()

// 			if mwm != 0 {
// 				em.zoom += mwm

// 				if em.zoom < 1 {
// 					em.zoom = 1
// 				}
// 			}
// 		}

// 		if em.zoom == 0 {
// 			em.zoom = default_game_camera_zoom()
// 		}

// 		cam_movement: Vec2

// 		if ui.active == 0 && rl.IsKeyUp(.LEFT_CONTROL) {
// 			if rl.IsKeyDown(.W) {
// 				cam_movement.y -= 1
// 			}
// 			if rl.IsKeyDown(.S) {
// 				cam_movement.y += 1
// 			}
// 			if rl.IsKeyDown(.A) {
// 				cam_movement.x -= 1
// 			}
// 			if rl.IsKeyDown(.D) {
// 				cam_movement.x += 1
// 			}

// 			if rl.IsKeyDown(.LEFT_SHIFT) {
// 				cam_movement *= 4
// 			}
// 		}

// 		if cam_movement.x != 0 || cam_movement.y != 0 {
// 			em.camera_pos += cam_movement * dt * 150
// 		}

// 		if rl.IsMouseButtonDown(.MIDDLE) {
// 			em.camera_pos -= rl.GetMouseDelta() / (dpi_scale()*em.zoom)
// 		}

// 		camera := get_camera(em.camera_pos, em.zoom)
// 		cr := camera_rect(camera)
// 		rens := make([dynamic]Renderable, context.temp_allocator)

// 		for t in world.tiles {
// 			if !layer_view_mode_compatible(t.layer, em.layer_view_mode, em.layer) {
// 				continue
// 			}

// 			dest_rect := tile_world_rect(t.x, t.y)

// 			if !rl.CheckCollisionRecs(cr, dest_rect) {
// 				continue
// 			}

// 			i := t.tile_idx
// 			x := i % TilesetWidth
// 			y := i / TilesetWidth

// 			tex := em.tileset_padded

// 			append(&rens, Renderable {
// 				variant = RenderableTexture {
// 					texture = tex,
// 					texture_rect = tile_tileset_rect(x, y, 1, 1, t.flip_x, t.flip_y),
// 					dest_rect = tile_world_rect(t.x, t.y),
// 				},
// 				layer = t.layer,
// 			})
// 		}

// 		default_renderable :: proc(e: Entity) -> (Renderable, bool) {
// 			tex: rl.Texture2D
// 			sr: Rect

// 			if e.kind == .Legacy {
// 				if et, et_ok := ha_get(em.world.entity_types, e.type); et_ok {
// 					tex, sr = get_entity_type_placeholder_tex(et)
// 				}
// 			} else {
// 				tex, sr = get_entity_kind_placeholder_tex(e.kind)
// 			}

// 			if tex.id == 0 {
// 				return {}, false
// 			}

// 			pos := e.pos + parallax_offset(e.parallax, camera_middle(get_camera(em.camera_pos, em.zoom)), e.parallax_y_lock)

// 			dr := rl.Rectangle {
// 				pos.x, pos.y,
// 				sr.width, sr.height,
// 			}

// 			if e.flip_x {
// 				sr.width = -sr.width
// 			}

// 			return {
// 				variant = RenderableTexture {
// 					texture = tex,
// 					texture_rect = sr,
// 					dest_rect = dr,
// 					origin = linalg.floor(rect_local_middle(dr)),
// 					rotation = e.rot,
// 				},
// 				layer = e.layer,
// 			}, true
// 		}

// 		e_iter := ha_make_iter(world.entities)
// 		for e in ha_iter_ptr(&e_iter) {
// 			if e.kind == .Legacy {
// 				if v, ok := e.variant.(Trigger); ok {
// 					if em.hide_extras {
// 						continue
// 					}
// 					append(&rens, Renderable {
// 						variant = RenderableRect {
// 							rect = trigger_world_rect(entity_inst(e, &v)),
// 							color = color_a(rl.GREEN.rgb, 100),
// 						},
// 					})
// 				} else if v, ok := e.variant.(StaticCollider); ok {
// 					if em.hide_extras {
// 						continue
// 					}
// 					append(&rens, Renderable {
// 						variant = RenderableRect {
// 							rect = rect_add_pos(v.collider, e.pos),
// 							color = color_a(rl.RED.rgb, 100),
// 						},
// 					})
// 				} else {
// 					if r, ok := default_renderable(e^); ok {
// 						append(&rens, r)
// 					}
// 				}
// 			} else {
// 				if r, ok := default_renderable(e^); ok {
// 					append(&rens, r)
// 				}
// 			}
// 		}

// 		switch m in em.mode {
// 			case ^EditModePlaceTiles:

// 			case ^EditModePlaceEntities:
// 				pet := get_all_placeable_entity_types(world.entity_types)
// 				if in_rect && m.selected_type < len(pet) {
// 					set := pet[m.selected_type]

// 					tex: rl.Texture2D
// 					sr: Rect

// 					switch et in set {
// 						case EntityKind:
// 							tex, sr = get_entity_kind_placeholder_tex(et)

// 						case EntityType:
// 							tex, sr = get_entity_type_placeholder_tex(et)

// 					}

// 					if tex.id != 0 && !rl.IsKeyDown(.LEFT_SHIFT) {
// 						grid_size: f32 = 16
// 						mouse_pos_wp := rl.GetScreenToWorld2D(mouse_pos(), camera)
// 						mouse_pos_wp_grid := linalg.floor(mouse_pos_wp)

// 						if em.snapping {
// 							mouse_pos_wp_grid = linalg.floor(mouse_pos_wp / grid_size) * grid_size
// 						}

// 						dr := rl.Rectangle {
// 							mouse_pos_wp_grid.x, mouse_pos_wp_grid.y,
// 							sr.width, sr.height,
// 						}

// 						if m.flip_x {
// 							sr.width = -sr.width
// 						}

// 						append(&rens, Renderable {
// 							variant = RenderableTexture {
// 								texture = tex,
// 								texture_rect = sr,
// 								dest_rect = dr,
// 								origin = {},
// 							},
// 							layer = em.layer,
// 						})
// 					}
// 				}

// 			case ^EditModeEntityProperties:
// 				if e, ok := ha_get(em.world.entities, m.edited); ok {
// 					append(&rens, Renderable {
// 						variant = RenderableRectLines {
// 							rect = entity_picking_rect(&e),
// 							color = rl.YELLOW,
// 						},
// 						layer = 100,
// 					})

// 					if s, ok := e.variant.(Spline); ok {
// 						draw_spline(&rens, e.pos, s)

// 						if st, ok := m.state.(EMEPStateEditSpline); ok {
// 							if st.selected_point != -1 && st.selected_point < len(s.points) {
// 								p := s.points[st.selected_point]

// 								r := Rect  {
// 									x = e.pos.x + p.x - 2,
// 									y = e.pos.y + p.y - 2,
// 									width = 4,
// 									height = 4,
// 								}

// 								append(&rens, Renderable {
// 									variant = RenderableRectLines {
// 										rect = r,
// 										color = rl.PURPLE,
// 									},
// 									layer = 100,
// 								})
// 							}
// 						}
// 					}
// 				}

// 			case ^EditModeEditEntityTypes:

// 			case ^EditModeMove:

// 			case ^DialogueEditorState:

// 		}


// 		append(&rens, ..get_to_render())
// 		slice.sort_by(rens[:], proc(i, j: Renderable) -> bool { return i.layer < j.layer })

// 		rl.BeginMode2D(camera)

// 		level_based_drawing()
// 		for r in rens {
// 			#partial switch v in r.variant {
// 				case RenderableTexture:
// 					rl.DrawTexturePro(v.texture, v.texture_rect, v.dest_rect, v.origin, v.rotation, v.tint ? v.tint_color : rl.WHITE)
// 			}
// 		}

// 		for r in rens {
// 			#partial switch &v in r.variant {
// 				case RenderableCircle:
// 					rl.DrawCircleV(v.pos, v.radius, v.color)

// 				case RenderableRect:
// 					render_rectangle(v.rect, v.color)

// 				case RenderableLine:
// 					rl.DrawLineV(v.start, v.end, v.color)

// 				case RenderableRectLines:
// 					rl.DrawRectangleLinesEx(v.rect, 2/default_game_camera_zoom(), v.color)

// 				case RenderableLineBezierCubic:
// 					rl.DrawSplineBezierCubic(&v.start, 4, 0.2, v.color)
// 			}
// 		}
// 		rl.EndMode2D()
// 	}

// 	window := rect_from_pos_size({0, 0}, screen_size())
// 	main_toolbar_background := cut_rect_top(&window, MetricToolbarHeight, 0)
// 	rl.DrawRectangleRec(main_toolbar_background, ColorToolbarBackground)
// 	main_toolbar := inset_rect(main_toolbar_background, MetricToolbarPadding, MetricToolbarPadding)
// 	mp := mouse_pos()
// 	rl.CheckCollisionPointRec(mp, main_toolbar_background)

// 	if gui_button("Save", cut_rect_left(&main_toolbar, button_width("Save"), 0)) {
// 		save()
// 	}

// 	if rl.IsKeyDown(.LEFT_CONTROL) && rl.IsKeyPressed(.S) {
// 		save()
// 	}

// 	states : []EditMode = {&em.edit_mode_place_tiles, &em.edit_mode_place_entities, &em.edit_mode_entity_properties, &em.edit_mode_edit_entity_types, &em.edit_mode_move, &em.dialogue_editor_state}
// 	state_names : []string = {"Tiles", "Place Entities", "Entity Properties", "Entity Types", "Move", "Dialogue"}

// 	em.mode = gui_state_selector(
// 		cut_rect_left(&main_toolbar, gui_state_selector_width(state_names), MetricToolbarSpacing),
// 		states,
// 		state_names,
// 		em.mode)

// 	if ui.active == 0 && rl.IsKeyUp(.LEFT_SHIFT) {
// 		if rl.IsKeyDown(.ONE) {
// 			em.mode = states[0]
// 		}
// 		if rl.IsKeyDown(.TWO) {
// 			em.mode = states[1]
// 		}
// 		if rl.IsKeyDown(.THREE) {
// 			em.mode = states[2]
// 		}
// 		if rl.IsKeyDown(.FOUR) {
// 			em.mode = states[3]
// 		}
// 		if rl.IsKeyDown(.FIVE) {
// 			em.mode = states[4]
// 		}
// 		if rl.IsKeyDown(.SIX) {
// 			em.mode = states[5]
// 		}
// 	}

// 	em.snapping = gui_push_button("Snapping", cut_rect_left(&main_toolbar, button_width("Snapping"), MetricToolbarSpacing), em.snapping)

// 	if ui.active == 0 && rl.IsKeyPressed(.G) {
// 		em.snapping = !em.snapping
// 	}

// 	layer_text := fmt.tprintf("Layer: {0}", em.layer)
// 	gui_label(layer_text, cut_rect_left(&main_toolbar, text_size(layer_text).x, MetricToolbarSpacing))

// 	if ui.active == 0 && rl.IsKeyPressed(.Q) {
// 		em.layer -= 1
// 	}

// 	if ui.active == 0 && rl.IsKeyPressed(.E) {
// 		em.layer += 1
// 	}

// 	gui_label("Layer view mode: ", cut_rect_left(&main_toolbar, text_size("Layer view mode: ").x, MetricToolbarSpacing))
// 	vwm_r := cut_rect_left(&main_toolbar, gui_state_selector_width(reflect.enum_field_names(typeid_of(LayerViewMode))), 0)
// 	em.layer_view_mode = gui_enum_selector(vwm_r, em.layer_view_mode)

// 	em.sample_all_layers = gui_push_button("Sample all layers", cut_rect_left(&main_toolbar, button_width("Sample all layers"), MetricToolbarSpacing), em.sample_all_layers)

// 	if ui.active == 0 && rl.IsKeyPressed(.T) {
// 		em.sample_all_layers = !em.sample_all_layers
// 	}

// 	em.hide_extras = gui_push_button("Hide extras", cut_rect_left(&main_toolbar, button_width("Hide extras"), MetricToolbarSpacing), em.hide_extras)

// 	if ui.active == 0 && rl.IsKeyPressed(.H) {
// 		em.hide_extras = !em.hide_extras
// 	}

// 	edit_mode_place_tiles :: proc(rect: Rect, em: ^EditorMemory, m: ^EditModePlaceTiles) {
// 		world := &em.world
// 		rect := rect
// 		side_panel := cut_rect_right(&rect, MetricEditorTileSize*4, 0)
// 		rl.DrawRectangleRec(side_panel, ColorPanelBackground)

// 		select_random_block :: proc(m: ^EditModePlaceTiles) {
// 			random_sel := int(rl.GetRandomValue(0, i32(len(m.selected_tiles) - 1)))

// 			for block_idx in m.selected_tiles {
// 				if random_sel == 0 {
// 					m.brush_tile = block_idx
// 					break
// 				}

// 				random_sel -= 1
// 			}
// 		}

// 		ts: f32 = MetricEditorTileSize
// 		//row := cut_rect_top(&side_panel, ts, 0)
// 		checker_tex := get_texture(em.checker_texture)

// 		tileset := get_texture(em.tileset)
// 		nx := TilesetWidth
// 		ny := int(tileset.height / TileHeight)

// 		for i in 0..= (nx * ny-1) {
// 			x := i % nx
// 			y := i / nx
// 			r := Rect {
// 				side_panel.x + f32(x) * ts,
// 				side_panel.y + f32(y) * ts,
// 				ts,
// 				ts,
// 			}

// 			rl.DrawTexturePro(checker_tex, draw_texture_source_rect(checker_tex, false), r, 0, 0, rl.WHITE)
// 		}

// 		rl.DrawTexturePro(tileset, draw_texture_source_rect(tileset, false), draw_texture_dest_rect_scl(tileset, pos_from_rect(side_panel), ts / TileHeight), 0, 0, rl.WHITE)

// 		for i in 0..=(nx * ny-1) {
// 			x := i % nx
// 			y := i / nx
// 			r := Rect {
// 				side_panel.x + f32(x) * ts,
// 				side_panel.y + f32(y) * ts,
// 				ts,
// 				ts,
// 			}

// 			id := ui_next_id()

// 			if mouse_in_rect(r) {
// 				ui.next_hover = id
// 			}

// 			if ui.hover == id {
// 				rl.DrawRectangleLinesEx(r, MetricTileHoverBorder, ColorTileHoverBorder)
// 			}

// 			if ui.clicked == id {
// 				if rl.IsKeyDown(.LEFT_SHIFT) {
// 					m.selected_tiles[i] = {}
// 				} else {
// 					clear(&m.selected_tiles)
// 					m.selected_tiles[i] = {}
// 				}

// 				select_random_block(m)
// 			}

// 			if i in m.selected_tiles {
// 				rl.DrawRectangleLinesEx(r, MetricTileHoverBorder, ColorTileSelectedBorder)
// 			}
// 		}

// 		rl.BeginScissorMode(i32(rect.x), i32(rect.y), i32(rect.width), i32(rect.height))
// 		tile_under_cursor := -1
// 		camera := get_camera(em.camera_pos, em.zoom)

// 		if mouse_in_rect(rect) {
// 			for &t, t_idx in world.tiles {
// 				wr := tile_world_rect(t.x, t.y)

// 				if !em.sample_all_layers && t.layer != em.layer {
// 					continue
// 				}

// 				under_cursor := mouse_in_rect(screen_rect(wr, camera))

// 				if under_cursor {
// 					tile_under_cursor = t_idx
// 					break
// 				}
// 			}

// 			x := m.brush_tile % nx
// 			y := m.brush_tile / nx

// 			mouse_pos_wp := rl.GetScreenToWorld2D(mouse_pos(), camera)
// 			grid_size: f32 = 16

// 			mouse_pos_wp_grid := linalg.floor(mouse_pos_wp / grid_size) * grid_size
// 			mouse_pos_sp_grid := rl.GetWorldToScreen2D(mouse_pos_wp_grid, camera)

// 			dr := rl.Rectangle {
// 				mouse_pos_wp_grid.x + 8, mouse_pos_wp_grid.y + 8,
// 				TileHeight,
// 				TileHeight,
// 			}

// 			render_texture_pro(em.tileset, tile_tileset_rect(x, y, 0, 0, m.flip_x, m.flip_y), dr, 100)

// 			if rl.IsMouseButtonDown(.LEFT) {
// 				x := int(math.round(mouse_pos_wp_grid.x/grid_size))
// 				y := int(math.round(mouse_pos_wp_grid.y/grid_size))

// 				in_use := false
// 				if tile_under_cursor >= 0 && tile_under_cursor < len(world.tiles) {
// 					uc := world.tiles[tile_under_cursor]
// 					if uc.x == x && uc.y == y && uc.layer == em.layer {
// 						in_use = true
// 					}
// 				}

// 				if !in_use && (x != m.last_place_pos_x || y != m.last_place_pos_y) {
// 					t := Tile {
// 						tile_idx = m.brush_tile,
// 						x = x,
// 						y = y,
// 						layer = em.layer,
// 						flip_x = m.flip_x,
// 						flip_y = m.flip_y,
// 					}

// 					append(&world.tiles, t)
// 					select_random_block(m)
// 					m.last_place_pos_x = x
// 					m.last_place_pos_y = y
// 					m.has_placed_tile = true
// 				}
// 			}

// 			if rl.IsMouseButtonReleased(.LEFT) && m.has_placed_tile {
// 				m.has_placed_tile = false
// 				record_undo()
// 			}

// 			if rl.IsMouseButtonReleased(.LEFT) {
// 				m.last_place_pos_x = -100000000
// 				m.last_place_pos_y = -100000000
// 			}

// 			if rl.IsMouseButtonDown(.RIGHT) && tile_under_cursor != -1 && tile_under_cursor < len(world.tiles){
// 				unordered_remove(&world.tiles, tile_under_cursor)
// 				m.has_removed_tile = true
// 			}

// 			if rl.IsMouseButtonReleased(.RIGHT) && m.has_removed_tile {
// 				m.has_removed_tile = false
// 				record_undo()
// 			}


// 			if rl.IsMouseButtonPressed(.RIGHT) {
// 				select_random_block(m)
// 			}
// 		}

// 		if rl.IsKeyPressed(.X) {
// 			if tile_under_cursor >= 0 && rl.IsKeyDown(.LEFT_SHIFT) {
// 				t := &world.tiles[tile_under_cursor]
// 				t.flip_x = !t.flip_x
// 				record_undo()
// 			} else {
// 				m.flip_x = !m.flip_x
// 			}
// 		}

// 		if rl.IsKeyPressed(.Y) && !any_modifier_held() {
// 			if tile_under_cursor >= 0 && rl.IsKeyDown(.LEFT_SHIFT) {
// 				t := &world.tiles[tile_under_cursor]
// 				t.flip_y = !t.flip_y
// 				record_undo()
// 			} else {
// 				m.flip_y = !m.flip_y
// 			}
// 		}

// 		edit_mode_draw_world(em, rect)

// 		if rl.IsKeyDown(.K) {
// 			if tile_under_cursor >= 0 {
// 				if rl.IsKeyPressed(.J) {
// 					world.tiles[tile_under_cursor].layer -= 1
// 					record_undo()
// 				}

// 				if rl.IsKeyPressed(.L) {
// 					world.tiles[tile_under_cursor].layer += 1
// 					record_undo()
// 				}
// 			}

// 			rl.BeginMode2D(camera)
// 			for t in &world.tiles {
// 				wr := tile_world_rect(t.x, t.y)
// 				rl.DrawTextPro(em.font, fmt.ctprintf("{0}", t.layer), pos_from_rect(wr), {-7, -4}, 0, 10, 0, rl.RED)
// 			}
// 			rl.EndMode2D()
// 		}

// 		rl.EndScissorMode()
// 	}

// 	edit_mode_place_entities :: proc(rect_in: Rect, em: ^EditorMemory, m: ^EditModePlaceEntities) {
// 		rect := rect_in
// 		side_panel := cut_rect_right(&rect, MetricEditorTileSize*6, 0)
// 		rl.DrawRectangleRec(side_panel, ColorPanelBackground)
// 		checker_tex := get_texture(em.checker_texture)
// 		ts: f32 = MetricEditorTileSize
// 		row := cut_rect_top(&side_panel, ts, 0)

// 		w := &em.world
// 		pet := get_all_placeable_entity_types(w.entity_types)

// 		pet_drawn := 0
// 		pet_loop: for etu, etu_idx in pet {
// 			tex: rl.Texture
// 			sr: Rect
// 			dr: Rect
// 			switch et in etu {
// 				case EntityKind:
// 					if et == .Legacy {
// 						continue pet_loop
// 					}

// 					tex, sr = get_entity_kind_placeholder_tex(et)

// 				case EntityType:
// 					tex, sr = get_entity_type_placeholder_tex(et)

// 					if tex.id == 0 {
// 						continue pet_loop
// 					}
// 			}

// 			dr = cut_rect_left(&row, ts, 0)

// 			if (pet_drawn + 1) % 6 == 0 {
// 				row = cut_rect_top(&side_panel, ts, 0)
// 			}

// 			rl.DrawTexturePro(checker_tex, sr, dr, 0, 0, rl.WHITE)

// 			if tex.id != 0 {
// 				rl.DrawTexturePro(tex, sr, dr, 0, 0, rl.WHITE)
// 			}

// 			if rl.CheckCollisionPointRec(mouse_pos(), dr) {
// 				rl.DrawRectangleLinesEx(dr, 4, color_a(rl.RED.rgb, 150))

// 				if rl.IsMouseButtonPressed(.LEFT) {
// 					m.selected_type = etu_idx
// 				}
// 			}

// 			if m.selected_type == etu_idx {
// 				rl.DrawRectangleLinesEx(dr, 4, rl.YELLOW)
// 			}

// 			pet_drawn += 1
// 		}

// 		rl.BeginScissorMode(i32(rect.x), i32(rect.y), i32(rect.width), i32(rect.height))
// 		camera := get_camera(em.camera_pos, em.zoom)
// 		under_cursor := find_entity_under_cursor(w.entities, em.sample_all_layers, em.layer, camera, EntityHandleNone)

// 		in_rect := rl.CheckCollisionPointRec(mouse_pos(), rect)

// 		if in_rect && ha_valid(w.entities, under_cursor) {
// 			if rl.IsKeyDown(.LEFT_SHIFT) && rl.IsKeyPressed(.X) {
// 				e := ha_get_ptr(w.entities, under_cursor)
// 				e.flip_x = !e.flip_x
// 				record_undo()
// 			}

// 			if rl.IsMouseButtonPressed(.RIGHT) {
// 				destroy_entity(&em.world, under_cursor)
// 				record_undo()
// 			}
// 		}

// 		if in_rect && m.selected_type < len(pet) {
// 			spet := pet[m.selected_type]

// 			switch et in spet {
// 				case EntityKind:
// 					tex, sr := get_entity_kind_placeholder_tex(et)

// 					grid_size: f32 = 16
// 					mouse_pos_wp := rl.GetScreenToWorld2D(mouse_pos(), camera)
// 					spawn_pos := linalg.floor(mouse_pos_wp)

// 					if em.snapping {
// 						spawn_pos = linalg.floor(mouse_pos_wp / grid_size) * grid_size
// 					}

// 					spawn_pos += linalg.floor(Vec2{sr.width/2, sr.height/2})

// 					if rl.IsMouseButtonPressed(.LEFT) {
// 						e := create_entity_from_entity_kind(et)
// 						e.pos = spawn_pos
// 						e.layer = em.layer
// 						e.flip_x = m.flip_x
// 						ha_add(&w.entities, e)
// 						record_undo()
// 					}

// 				case EntityType:
// 					tex, sr := get_entity_type_placeholder_tex(et)

// 					grid_size: f32 = 16
// 					mouse_pos_wp := rl.GetScreenToWorld2D(mouse_pos(), camera)
// 					mouse_pos_wp_grid := linalg.floor(mouse_pos_wp)

// 					if em.snapping {
// 						mouse_pos_wp_grid = linalg.floor(mouse_pos_wp / grid_size) * grid_size
// 					}

// 					spawn_pos := mouse_pos_wp_grid + linalg.floor(Vec2{sr.width/2, sr.height/2})

// 					switch v in et.variant {
// 						case EntityTypeStaticObject:
// 							if rl.IsMouseButtonPressed(.LEFT) {
// 								e := create_entity(et, spawn_pos, em.layer)
// 								e.flip_x = m.flip_x
// 								ha_add(&w.entities, e)
// 								record_undo()
// 							}

// 						case  EntityTypeAnimatedObject:
// 							if rl.IsMouseButtonPressed(.LEFT) {
// 								e := create_entity(et, spawn_pos, em.layer)
// 								ha_add(&w.entities, e)
// 								record_undo()
// 							}

// 						case EntityTypeBuiltin:
// 							#partial switch v.variant {
// 								case .None:

// 								case .Trigger:
// 									mp := mouse_pos()

// 									if rl.IsMouseButtonPressed(.LEFT) && in_rect {
// 										m.dragging = true
// 										m.drag_start = mp
// 									}

// 									rl.BeginMode2D(camera)
// 									if m.dragging {
// 										start_wp := linalg.floor(rl.GetScreenToWorld2D(m.drag_start, camera))
// 										wp := linalg.floor(rl.GetScreenToWorld2D(mp, camera))
// 										r := Rect {
// 											x = start_wp.x,
// 											y = start_wp.y,
// 											width = wp.x - start_wp.x,
// 											height = wp.y - start_wp.y,
// 										}

// 										if r.width < 0 {
// 											r.x += r.width
// 											r.width = -r.width
// 										}

// 										if r.height < 0 {
// 											r.y += r.height
// 											r.height = -r.height
// 										}

// 										rl.DrawRectangleRec(r, color_a(rl.YELLOW.rgb, 60))

// 										if rl.IsMouseButtonReleased(.LEFT) {
// 											m.dragging = false

// 											if r.width != 0 && r.height != 0 {
// 												e := Entity {
// 													pos = {r.x, r.y},
// 													layer = em.layer,
// 													type = et.handle,
// 													variant = Trigger {
// 														rect = { width = r.width, height = r.height },
// 													},
// 												}

// 												ha_add(&w.entities, e)
// 												record_undo()
// 											}
// 										}
// 									}
// 									rl.EndMode2D()

// 								case .Collider:
// 									mp := mouse_pos()

// 									if rl.IsMouseButtonPressed(.LEFT) && in_rect {
// 										m.dragging = true
// 										m.drag_start = mp
// 									}

// 									rl.BeginMode2D(camera)
// 									if m.dragging {
// 										start_wp := linalg.floor(rl.GetScreenToWorld2D(m.drag_start, camera))
// 										wp := linalg.floor(rl.GetScreenToWorld2D(mp, camera))
// 										r := Rect {
// 											x = start_wp.x,
// 											y = start_wp.y,
// 											width = wp.x - start_wp.x,
// 											height = wp.y - start_wp.y,
// 										}

// 										if r.width < 0 {
// 											r.x += r.width
// 											r.width = -r.width
// 										}

// 										if r.height < 0 {
// 											r.y += r.height
// 											r.height = -r.height
// 										}

// 										draw_rectangle(r, color_a(rl.YELLOW.rgb, 60), 100)

// 										if rl.IsMouseButtonReleased(.LEFT) {
// 											m.dragging = false

// 											if r.width != 0 && r.height != 0 {
// 												e := Entity {
// 													pos = {r.x, r.y},
// 													layer = em.layer,
// 													type = et.handle,
// 													variant = StaticCollider {
// 														collider = { width = r.width, height = r.height },
// 													},
// 												}

// 												ha_add(&w.entities, e)
// 												record_undo()
// 											}
// 										}
// 									}
// 									rl.EndMode2D()

// 								case:
// 									if rl.IsMouseButtonPressed(.LEFT) {
// 										e := create_entity(et, spawn_pos, em.layer)
// 										ha_add(&w.entities, e)
// 										record_undo()
// 									}
// 							}
// 					}
// 				}
// 		}

// 		edit_mode_draw_world(em, rect)

// 		if rl.IsKeyDown(.K) {
// 			if uc := ha_get_ptr(w.entities, under_cursor); uc != nil {
// 				if rl.IsKeyPressed(.J) {
// 					uc.layer -= 1
// 					record_undo()
// 				}

// 				if rl.IsKeyPressed(.L) {
// 					uc.layer += 1
// 					record_undo()
// 				}
// 			}

// 			rl.BeginMode2D(camera)
// 			e_iter := ha_make_iter(w.entities)
// 			for e in ha_iter(&e_iter) {
// 				rl.DrawTextPro(em.font, fmt.ctprintf("{0}", e.layer), e.pos, {-7, -4}, 0, 10, 0, rl.RED)
// 			}
// 			rl.EndMode2D()
// 		}


// 		if rl.IsKeyPressed(.X) {
// 			m.flip_x = !m.flip_x
// 		}

// 		rl.EndScissorMode()
// 	}

// 	edit_mode_entity_properties :: proc(rect: Rect, em: ^EditorMemory, m: ^EditModeEntityProperties) {
// 		rect := rect
// 		side_panel := cut_rect_right(&rect, MetricEditorSidePanelWidth, 0)
// 		rl.DrawRectangleRec(side_panel, ColorPanelBackground)
// 		side_panel = inset_rect(side_panel, MetricWindowPadding, MetricWindowPadding)
// 		w := &em.world

// 		camera := get_camera(em.camera_pos, em.zoom)

// 		if union_type(m.state) == EMEPStateDefault && mouse_in_rect(rect) {
// 			under_cursor := find_entity_under_cursor(w.entities, em.sample_all_layers, em.layer, camera, m.edited)

// 			if under_cursor != EntityHandleNone {
// 				if rl.IsMouseButtonPressed(.LEFT) {
// 					m.edited = under_cursor
// 				}
// 			}
// 		}

// 		if e := ha_get_ptr(w.entities, m.edited); e != nil {
// 			disabled := gui_push_button("Disabled", cut_property_row(&side_panel), e.disabled)

// 			if e.disabled != disabled {
// 				e.disabled = disabled
// 				record_undo()
// 			}

// 			if new_val, changed := gui_f32_field(cut_property_row(&side_panel), e.rot, "Rotation"); changed {
// 				e.rot = new_val
// 				record_undo()
// 			}

// 			if new_val, changed := gui_int_field(cut_property_row(&side_panel), e.layer, "Layer"); changed {
// 				e.layer = new_val
// 				record_undo()
// 			}

// 			if new_tag, changed := gui_enum_dropdown(cut_property_row(&side_panel), e.tag, "Tag"); changed {
// 				e.tag = new_tag
// 				record_undo()
// 			}

// 			if new_facing, changed := gui_enum_dropdown(cut_property_row(&side_panel), e.facing, "Facing"); changed {
// 				e.facing = new_facing
// 				record_undo()
// 			}

// 			if new_val, changed := gui_f32_field(cut_property_row(&side_panel), e.parallax, "Parallax"); changed {
// 				old_val := e.parallax
// 				cam_mid := camera_middle(camera)
// 				old_offset := parallax_offset(old_val, cam_mid, e.parallax_y_lock)
// 				new_offset := parallax_offset(new_val, cam_mid, e.parallax_y_lock)
// 				e.pos = e.pos + old_offset - new_offset
// 				e.parallax = new_val
// 				record_undo()
// 			}

// 			parallax_y_lock := gui_push_button("Parallax Y lock", cut_property_row(&side_panel), e.parallax_y_lock)

// 			if e.parallax_y_lock != parallax_y_lock {
// 				e.parallax_y_lock = parallax_y_lock
// 				record_undo()
// 			}

// 			if new_val, changed := gui_enum_dropdown(cut_property_row(&side_panel), e.dialogue_name, "Dialogue"); changed {
// 				e.dialogue_name = new_val
// 				record_undo()
// 			}

// 			#partial switch &v in e.variant {
// 				case StaticCollider:
// 					one_direction := gui_push_button("One Direciton", cut_property_row(&side_panel), v.one_direction)

// 					if one_direction != v.one_direction {
// 						v.one_direction = one_direction
// 						record_undo()
// 					}


// 				case Trigger:
// 					if new_name, changed := gui_enum_dropdown(cut_property_row(&side_panel), v.name, "Name"); changed {
// 						v.name = new_name
// 						record_undo()
// 					}

// 					if new_entity, changed := gui_entity_picker(cut_property_row(&side_panel), v.target, w.entities, em.sample_all_layers, em.layer, camera, "Target"); changed {
// 						v.target = new_entity
// 						record_undo()
// 					}

// 					{
// 						type_names := make([dynamic]string, context.temp_allocator)
// 						types := make([dynamic]int, context.temp_allocator)


// 						type_info := runtime.type_info_base(type_info_of(PlayerState))
// 						if osu_info, ok := type_info.variant.(runtime.Type_Info_Union); ok {
// 							if !osu_info.no_nil {
// 								append(&type_names, "nil")
// 								append(&types, 0)
// 							}

// 							for v, v_idx in osu_info.variants {
// 								if named, ok := v.variant.(runtime.Type_Info_Named); ok {
// 									append(&type_names, named.name[len("PlayerState"):])
// 									append(&types, osu_info.no_nil ? v_idx : v_idx + 1)
// 								}
// 							}
// 						}

// 						if new_variant, changed := gui_dropdown(cut_property_row(&side_panel), types[:], type_names[:], v.required_state, "Player State"); changed {
// 							v.required_state = new_variant
// 							record_undo()
// 						}
// 					}

// 					event_property(&v.event, &side_panel, "Event")

// 					destroy_on_trigger := gui_push_button("Destroy on trigger", cut_property_row(&side_panel), v.destroy_on_trigger)

// 					if destroy_on_trigger != v.destroy_on_trigger {
// 						v.destroy_on_trigger = destroy_on_trigger
// 						record_undo()
// 					}

// 				case Rocket:
// 					if new_state, changed := gui_enum_dropdown(cut_property_row(&side_panel), v.state, "Initial state"); changed {
// 						v.state = new_state
// 						record_undo()
// 					}


// 				case Usable:
// 					if new_icon, changed := gui_enum_dropdown(cut_property_row(&side_panel), v.icon, "Icon"); changed {
// 						v.icon = new_icon
// 						record_undo()
// 					}

// 					if new_progress_res, changed := gui_enum_dropdown(cut_property_row(&side_panel), v.progress_required, "Progres req."); changed {
// 						v.progress_required = new_progress_res
// 						record_undo()
// 					}

// 					if new_val, changed := gui_enum_dropdown(cut_property_row(&side_panel), v.item_required, "Must use item"); changed {
// 						v.item_required = new_val
// 						record_undo()
// 					}

// 					not_interactable := gui_push_button("Not interactable", cut_property_row(&side_panel), v.not_interactable)
// 					if not_interactable != v.not_interactable {
// 						v.not_interactable = not_interactable
// 						record_undo()
// 					}

// 					for &au, idx in v.actions {
// 						cut_rect_top(&side_panel, 10, 0)

// 						{
// 							type_names := make([dynamic]string, context.temp_allocator)
// 							types := make([dynamic]typeid, context.temp_allocator)
// 							append(&type_names, "(none)")
// 							append(&types, nil)
// 							type_info := runtime.type_info_base(type_info_of(Action))

// 							if osu_info, ok := type_info.variant.(runtime.Type_Info_Union); ok {
// 								for v in osu_info.variants {
// 									if named, ok := v.variant.(runtime.Type_Info_Named); ok {
// 										append(&type_names, named.name[len("Action"):])
// 										append(&types, v.id)
// 									}
// 								}
// 							}

// 							before := reflect.union_variant_typeid(au)
// 							cur, changed := gui_dropdown(cut_property_row(&side_panel), types[:], type_names[:], before, "Action")

// 							if changed {
// 								reflect.set_union_variant_typeid(au, cur)
// 								record_undo()
// 							}
// 						}

// 						switch &a in au {
// 							case ActionPlayAnimation:
// 								if new_entity, changed := gui_entity_picker(cut_property_row(&side_panel), a.entity, w.entities, em.sample_all_layers, em.layer, camera, "Entity"); changed {
// 									a.entity = new_entity
// 									record_undo()
// 								}

// 								oneshot := gui_push_button("One shot", cut_property_row(&side_panel), a.oneshot)

// 								if oneshot != a.oneshot {
// 									a.oneshot = oneshot
// 									record_undo()
// 								}

// 							case ActionDisableCollision:
// 								if new_entity, changed := gui_entity_picker(cut_property_row(&side_panel), a.entity, w.entities, em.sample_all_layers, em.layer, camera, "Entity"); changed {
// 									a.entity = new_entity
// 									record_undo()
// 								}

// 							case ActionPickup:

// 							case ActionDeleteEntity:
// 								if new_entity, changed := gui_entity_picker(cut_property_row(&side_panel), a.entity, w.entities, em.sample_all_layers, em.layer, camera, "Entity"); changed {
// 									a.entity = new_entity
// 									record_undo()
// 								}

// 							case ActionEnableEntity:
// 								if new_entity, changed := gui_entity_picker(cut_property_row(&side_panel), a.entity, w.entities, em.sample_all_layers, em.layer, camera, "Entity"); changed {
// 									a.entity = new_entity
// 									record_undo()
// 								}

// 							case ActionLoadLevel:
// 								if level_name, changed := gui_enum_dropdown(cut_property_row(&side_panel), a.level_name, "Level name"); changed {
// 									a.level_name = level_name
// 									record_undo()
// 								}

// 							case ActionStartDialogue:
// 								if new_val, changed := gui_enum_dropdown(cut_property_row(&side_panel), a.dialogue_name, "Dialogue Name"); changed {
// 									a.dialogue_name = new_val
// 									record_undo()
// 								}

// 								if new_entity, changed := gui_entity_picker(cut_property_row(&side_panel), a.entity, w.entities, em.sample_all_layers, em.layer, camera, "Target"); changed {
// 									a.entity = new_entity
// 									record_undo()
// 								}

// 								auto_advance := gui_push_button("Auto advance", cut_property_row(&side_panel), a.auto_advance)

// 								if auto_advance != a.auto_advance {
// 									a.auto_advance = auto_advance
// 									record_undo()
// 								}

// 							case ActionMoveAlongSpline:
// 								if new_entity, changed := gui_entity_picker(cut_property_row(&side_panel), a.entity, w.entities, em.sample_all_layers, em.layer, camera, "Entity"); changed {
// 									a.entity = new_entity
// 									record_undo()
// 								}

// 								if new_spline, changed := gui_entity_picker(cut_property_row(&side_panel), a.spline, w.entities, em.sample_all_layers, em.layer, camera, "Spline"); changed {
// 									a.spline = new_spline
// 									record_undo()
// 								}

// 								if new_val, changed := gui_entity_picker(cut_property_row(&side_panel), a.done_interactable, w.entities, em.sample_all_layers, em.layer, camera, "On Done"); changed {
// 									a.done_interactable = new_val
// 									record_undo()
// 								}

// 							case ActionPlayerJump:
// 								override_velocity := gui_push_button("Override velocity", cut_property_row(&side_panel), a.override_velocity)

// 								if override_velocity != a.override_velocity {
// 									a.override_velocity = override_velocity
// 									record_undo()
// 								}

// 								if new_val, changed := gui_vec2_field(cut_property_row(&side_panel), a.velocity, "Velocity"); changed {
// 									a.velocity = new_val
// 									record_undo()
// 								}

// 							case ActionSetInteractionEnabled:
// 								if new_val, changed := gui_entity_picker(cut_property_row(&side_panel), a.target, w.entities, em.sample_all_layers, em.layer, camera, "Target"); changed {
// 									a.target = new_val
// 									record_undo()
// 								}

// 								enabled := gui_push_button("Enabled", cut_property_row(&side_panel), a.enabled)

// 								if enabled != a.enabled {
// 									a.enabled = enabled
// 									record_undo()
// 								}

// 							case ActionFocusCamera:
// 								if new_val, changed := gui_entity_picker(cut_property_row(&side_panel), a.target, w.entities, em.sample_all_layers, em.layer, camera, "Target"); changed {
// 									a.target = new_val
// 									record_undo()
// 								}

// 								if new_val, changed := gui_f32_field(cut_property_row(&side_panel), a.time, "Time"); changed {
// 									a.time = new_val
// 									record_undo()
// 								}

// 						}

// 						if gui_button("Remove", cut_property_row(&side_panel)) {
// 							ordered_remove(&v.actions, idx)
// 							record_undo()
// 							break
// 						}
// 					}

// 					cut_rect_top(&side_panel, 10, 0)

// 					if gui_button("+", cut_property_row(&side_panel)) {
// 						append_nothing(&v.actions)
// 						record_undo()
// 					}

// 				case Spline:
// 					if new_name, changed := gui_string_field(cut_property_row(&side_panel), v.name, "Name"); changed {
// 						delete(v.name)
// 						v.name = strings.clone(new_name)
// 						record_undo()
// 					}

// 					edit_active := false

// 					switch s in m.state {
// 						case EMEPStateEditSpline, EMEPStateDragSplinePoint, EMEPStateMouseDownSplinePoint:
// 							edit_active = true

// 						case EMEPStateDefault:
// 					}

// 					event_property(&v.on_done_event, &side_panel, "On Done")

// 					dont_scale := gui_push_button("Don't scale", cut_property_row(&side_panel), v.dont_scale)

// 					if dont_scale != v.dont_scale {
// 						v.dont_scale = dont_scale
// 						record_undo()
// 					}

// 					edit_active = gui_push_button("Edit Path", cut_property_row(&side_panel), edit_active)

// 					if gui_button("Clear", cut_property_row(&side_panel)) {
// 						clear(&v.points)
// 					}

// 					switch &s in m.state {
// 						case EMEPStateDefault:
// 							if edit_active {
// 								m.state = EMEPStateEditSpline{}
// 							}

// 						case EMEPStateEditSpline:
// 							if !edit_active {
// 								m.state = EMEPStateDefault{}
// 								break
// 							}

// 							if s.selected_point != -1 && s.selected_point < len(v.points) {
// 								gui_label("Point specifics", cut_property_row(&side_panel, 5))
// 								p := &v.points[s.selected_point]

// 								if new_val, changed := gui_f32_field(cut_property_row(&side_panel), p.speed, "Speed"); changed {
// 									p.speed = new_val
// 									record_undo()
// 								}

// 								if gui_button("Use for all", cut_property_row(&side_panel)) {
// 									for &pp in v.points {
// 										pp.speed = p.speed
// 									}
// 									record_undo()
// 								}

// 								new_custom_rotation := gui_push_button("Custom rotation", cut_property_row(&side_panel), p.custom_rotation)

// 								if new_custom_rotation != p.custom_rotation {
// 									p.custom_rotation = new_custom_rotation
// 									record_undo()
// 								}

// 								if new_val, changed := gui_f32_field(cut_property_row(&side_panel), p.rotation, "Rotation"); changed {
// 									p.rotation = new_val
// 									record_undo()
// 								}

// 								if new_val, changed := gui_f32_field(cut_property_row(&side_panel), p.scale, "Scale"); changed {
// 									p.scale = new_val
// 									record_undo()
// 								}
// 							}

// 							if mouse_in_rect(rect) {
// 								spline_point_under_cursor := -1
// 								under_cursor_type: EMEPStateDragSplinePointType

// 								for pl, p_idx in v.points {
// 									p := world_spline_point(pl, e.pos)

// 									// point itself
// 									{
// 										r := Rect  {
// 											x = p.x - 2,
// 											y = p.y - 2,
// 											width = 4,
// 											height = 4,
// 										}

// 										if mouse_in_world_rect(r, camera) {
// 											spline_point_under_cursor = p_idx
// 											under_cursor_type = .Point
// 										}
// 									}

// 									// control in
// 									{
// 										r := Rect  {
// 											x = p.control_in.x - 2,
// 											y = p.control_in.y - 2,
// 											width = 4,
// 											height = 4,
// 										}

// 										if mouse_in_world_rect(r, camera) {
// 											spline_point_under_cursor = p_idx
// 											under_cursor_type = .ControlIn
// 										}
// 									}

// 									// control out
// 									{
// 										r := Rect  {
// 											x = p.control_out.x - 2,
// 											y = p.control_out.y - 2,
// 											width = 4,
// 											height = 4,
// 										}

// 										if mouse_in_world_rect(r, camera) {
// 											spline_point_under_cursor = p_idx
// 											under_cursor_type = .ControlOut
// 										}
// 									}
// 								}

// 								if rl.IsMouseButtonPressed(.LEFT) {
// 									if spline_point_under_cursor != -1 {
// 										m.state = EMEPStateMouseDownSplinePoint {
// 											idx = spline_point_under_cursor,
// 											type = under_cursor_type,
// 											mouse_start = mouse_pos(),
// 										}
// 									} else {
// 										p := SplinePoint {
// 											point = mouse_world_position(camera) - e.pos,
// 											speed = 1,
// 										}

// 										if len(v.points) > 0 {
// 											p.control_in = (p.point + slice.last(v.points[:]).point)/2
// 											in_to_point := p.point - p.control_in
// 											p.control_out = p.point + in_to_point
// 										} else {
// 											p.control_in = p.point - {10, 0}
// 											p.control_out = p.point + {10, 0}
// 										}

// 										s.selected_point = len(v.points)
// 										append(&v.points, p)
// 									}
// 								}

// 								if rl.IsMouseButtonPressed(.RIGHT) && spline_point_under_cursor != -1 && under_cursor_type == .Point {
// 									ordered_remove(&v.points, spline_point_under_cursor)
// 								}
// 							}

// 						case EMEPStateMouseDownSplinePoint:
// 							mouse_diff := linalg.length(s.mouse_start - mouse_pos())

// 							if mouse_diff > 3 {
// 								m.state = EMEPStateDragSplinePoint {
// 									idx = s.idx,
// 									type = s.type,
// 								}
// 							} else {
// 								if rl.IsMouseButtonUp(.LEFT) {
// 									m.state = EMEPStateEditSpline {
// 										selected_point = s.type == .Point ? s.idx : -1,
// 									}
// 								}
// 							}

// 						case EMEPStateDragSplinePoint:
// 							p := &v.points[s.idx]

// 							switch s.type {
// 								case .Point:
// 									new := mouse_world_position(camera) - e.pos
// 									diff := new - p.point
// 									p.point = new
// 									p.control_in += diff
// 									p.control_out += diff
// 								case .ControlIn:
// 									p.control_in = mouse_world_position(camera) - e.pos
// 									in_to_point := p.point - p.control_in
// 									point_to_out := p.control_out - p.point
// 									p.control_out = p.point + linalg.projection(point_to_out, in_to_point)
// 								case .ControlOut:
// 									p.control_out = mouse_world_position(camera) - e.pos
// 									out_to_point := p.point - p.control_out
// 									point_to_in := p.control_in - p.point
// 									p.control_in = p.point + linalg.projection(point_to_in, out_to_point)
// 							}

// 							if rl.IsMouseButtonUp(.LEFT) {
// 								m.state = EMEPStateEditSpline {
// 									selected_point = s.type == .Point ? s.idx : -1,
// 								}
// 								record_undo()
// 							}
// 					}
// 			}

// 			if gui_button("Delete entity", cut_rect_bottom(&side_panel, MetricPropertyHeight, MetricPropertyMargin)) {
// 				destroy_entity(&em.world, m.edited)
// 				m.edited = EntityHandleNone
// 				record_undo()
// 			}

// 			movement: Vec2

// 			if rl.IsKeyPressed(.LEFT) {
// 				movement.x -= 1
// 			}

// 			if rl.IsKeyPressed(.RIGHT) {
// 				movement.x += 1
// 			}

// 			if rl.IsKeyPressed(.UP) {
// 				movement.y -= 1
// 			}

// 			if rl.IsKeyPressed(.DOWN) {
// 				movement.y += 1
// 			}

// 			if rl.IsKeyDown(.LEFT_SHIFT) {
// 				movement *= 10
// 			}

// 			if movement.x != 0 || movement.y != 0 {
// 				e.pos += movement
// 				record_undo()
// 			}

// 			if rl.IsKeyPressed(.DELETE) {
// 				destroy_entity(&em.world, m.edited)
// 				m.edited = EntityHandleNone
// 				record_undo()
// 			}
// 		}

// 		rl.BeginScissorMode(i32(rect.x), i32(rect.y), i32(rect.width), i32(rect.height))

// 		edit_mode_draw_world(em, rect)

// 		rl.EndScissorMode()
// 	}

// 	edit_mode_edit_entity_types :: proc(rect: Rect, em: ^EditorMemory, m: ^EditModeEditEntityTypes) {
// 		rect := rect
// 		side_panel := cut_rect_right(&rect, 6 * MetricEditorTileSize, 0)
// 		rl.DrawRectangleRec(side_panel, ColorPanelBackground)

// 		side_panel_toolbar_background := cut_rect_bottom(&side_panel, MetricToolbarHeight, 0)
// 		rl.DrawRectangleRec(side_panel_toolbar_background, ColorToolbarBackground)
// 		side_panel_toolbar := inset_rect(side_panel_toolbar_background, MetricToolbarPadding, MetricToolbarPadding)
// 		w := &em.world

// 		if gui_button("New", cut_rect_left(&side_panel_toolbar, button_width("New"), 0)) {
// 			ha_add(&w.entity_types, EntityType { id = new_uid() })
// 			record_undo()
// 		}

// 		checker_tex := get_texture(em.checker_texture)
// 		ts: f32 = MetricEditorTileSize
// 		row := cut_rect_top(&side_panel, ts, 0)

// 		et_num_drawn := 0
// 		et_iter := ha_make_iter(w.entity_types)
// 		for et in ha_iter(&et_iter) {
// 			if is_builtin_entity_type(et) {
// 				continue
// 			}

// 			dr := cut_rect_left(&row, ts, 0)
// 			rl.DrawTexturePro(checker_tex, rect_from_size(texture_size(checker_tex)), dr, 0, 0, rl.WHITE)

// 			placeholder_tex, placeholder_rect := get_entity_type_placeholder_tex(et)

// 			if placeholder_tex.id != 0 {
// 				rl.DrawTexturePro(placeholder_tex, placeholder_rect, dr, 0, 0, rl.WHITE)
// 			}

// 			if rl.CheckCollisionPointRec(mouse_pos(), dr) {
// 				rl.DrawRectangleLinesEx(dr, 4, color_a(rl.RED.rgb, 150))

// 				if rl.IsMouseButtonPressed(.LEFT) {
// 					m.edited_type = et.handle
// 				}
// 			}

// 			if et.handle == m.edited_type {
// 				rl.DrawRectangleLinesEx(dr, 4, rl.YELLOW)
// 			}

// 			et_num_drawn += 1

// 			if et_num_drawn % 6 == 0 {
// 				row = cut_rect_top(&side_panel, ts, 0)
// 			}
// 		}

// 		if et := ha_get_ptr(em.world.entity_types, m.edited_type); et != nil && !is_builtin_entity_type(et^) {
// 			bottom_panel := cut_rect_bottom(&rect, ts*4 + MetricGroupMargin*3 + MetricToolbarHeight, 0)
// 			rl.DrawRectangleRec(bottom_panel, ColorPanelBackground)

// 			fields_background := cut_rect_bottom(&bottom_panel, MetricToolbarHeight, 0)
// 			rl.DrawRectangleRec(fields_background, ColorToolbarBackground)

// 			fields := inset_rect(fields_background, MetricToolbarPadding, MetricToolbarPadding)

// 			{
// 				type_names := make([dynamic]string, context.temp_allocator)
// 				types := make([dynamic]typeid, context.temp_allocator)
// 				os_info := runtime.type_info_base(type_info_of(EntityTypeVariant))

// 				if osu_info, ok := os_info.variant.(runtime.Type_Info_Union); ok {
// 					for v in osu_info.variants {
// 						if named, ok := v.variant.(runtime.Type_Info_Named); ok {
// 							if v.id == EntityTypeBuiltin {
// 								continue
// 							}

// 							append(&type_names, named.name[len("EntityType"):])
// 							append(&types, v.id)
// 						}
// 					}
// 				}

// 				before := reflect.union_variant_typeid(et.variant)
// 				cur, changed := gui_state_selector(cut_rect_left(&fields, gui_state_selector_width(type_names[:]), 0), types[:], type_names[:], before)

// 				if changed {
// 					reflect.set_union_variant_typeid(et.variant, cur)
// 					record_undo()
// 				}
// 			}

// 			select_texture :: proc(toolbar_rect_in: Rect, cur: TextureHandle, available: []TextureHandle) -> TextureHandle {
// 				toolbar_rect := toolbar_rect_in
// 				item_rect := cut_rect_left(&toolbar_rect, MetricEditorTileSize, 0)
// 				checker_tex := get_texture(checker_tex())
// 				cur_name := texture_hash_from_handle(cur)
// 				res := cur

// 				for tex_handle in available {
// 					id := ui_next_id()

// 					tex := get_texture(tex_handle)
// 					tex_name := texture_hash_from_handle(tex_handle)
// 					rl.DrawTexturePro(checker_tex, rect_from_size(texture_size(checker_tex)), item_rect, 0, 0, rl.WHITE)
// 					rl.DrawTexturePro(tex, rect_from_size(texture_size(tex)), item_rect, 0, 0, rl.WHITE)

// 					if rl.CheckCollisionPointRec(mouse_pos(), item_rect) {
// 						ui.next_hover = id
// 					}

// 					if ui.hover == id {
// 						rl.DrawRectangleLinesEx(item_rect, 4, color_a(rl.YELLOW.rgb, 150))
// 					}

// 					if ui.clicked == id {
// 						res = tex_handle
// 					}

// 					if cur_name == tex_name {
// 						rl.DrawRectangleLinesEx(item_rect, 4, color_a(rl.GREEN.rgb, 150))
// 					}

// 					new_row := item_rect.x + item_rect.width > toolbar_rect.x + toolbar_rect.width
// 					if new_row {
// 						toolbar_rect.x = toolbar_rect_in.x
// 						toolbar_rect.width = toolbar_rect_in.width
// 						toolbar_rect.y += toolbar_rect.height + MetricGroupMargin
// 					}

// 					item_rect = cut_rect_left(&toolbar_rect, MetricEditorTileSize, new_row ? 0 : 5)
// 				}

// 				return res
// 			}

// 			extra_toolbar := cut_rect_bottom(&bottom_panel, ts*4, MetricGroupMargin*3)
// 			extra_toolbar.height = ts

// 			switch &st in et.variant {
// 				case EntityTypeBuiltin:
// 					// Nothing

// 				case EntityTypeAnimatedObject:
// 					start_paused := gui_push_button("Start paused", cut_rect_left(&fields, 80, 10), st.start_paused)

// 					if start_paused != st.start_paused {
// 						st.start_paused = start_paused
// 						record_undo()
// 					}

// 					if new_val, changed := gui_int_field(cut_rect_left(&fields, 120, 0), st.num_frames, "Num frames"); changed {
// 						st.num_frames = new_val
// 						record_undo()
// 					}

// 					if new_val, changed := gui_f32_field(cut_rect_left(&fields, 140, 0), st.frame_time, "Frame time"); changed {
// 						st.frame_time = new_val
// 						record_undo()
// 					}

// 					if res := select_texture(extra_toolbar, st.texture, em.entity_textures); res != st.texture {
// 						st.texture = res
// 						record_undo()
// 					}

// 				case EntityTypeStaticObject:
// 					if res := select_texture(extra_toolbar, st.texture, em.entity_textures); res != st.texture {
// 						st.texture = res
// 						record_undo()
// 					}
// 			}

// 			rl.BeginScissorMode(i32(rect.x), i32(rect.y), i32(rect.width), i32(rect.height))

// 			if m.camera_zoom == 0 {
// 				m.camera_zoom = default_game_camera_zoom()
// 			}

// 			camera := get_camera(m.camera_pos, m.camera_zoom)

// 			rl.BeginMode2D(camera)

// 			switch &et in et.variant {
// 				case EntityTypeStaticObject:
// 					if tex, ok := get_texture(et.texture); ok {
// 						dest_rect := draw_texture_dest_rect(tex, { tex.width % 2 == 0 ? 0 : 0.5, tex.height % 2 == 0 ? 0 : 0.5 })
// 						rl.DrawTexturePro(tex, draw_texture_source_rect(tex, false), dest_rect, rect_local_middle(dest_rect), 0, rl.WHITE)
// 						mp := mouse_pos()

// 						if rl.IsMouseButtonPressed(.LEFT) && rl.CheckCollisionPointRec(mp, rect) {
// 							m.dragging = true
// 							m.drag_start = mp
// 						}

// 						if m.dragging {
// 							start_wp := linalg.floor(rl.GetScreenToWorld2D(m.drag_start, camera))
// 							wp := linalg.floor(rl.GetScreenToWorld2D(mp, camera))
// 							c := Rect {
// 								x = start_wp.x,
// 								y = start_wp.y,
// 								width = wp.x - start_wp.x,
// 								height = wp.y - start_wp.y,
// 							}

// 							if c.width < 0 {
// 								c.x += c.width
// 								c.width = -c.width
// 							}

// 							if c.height < 0 {
// 								c.y += c.height
// 								c.height = -c.height
// 							}


// 							rl.DrawRectangleRec(c, color_a(rl.YELLOW.rgb, 60))

// 							if rl.IsMouseButtonReleased(.LEFT) {
// 								et.collider = c
// 								m.dragging = false
// 								record_undo()
// 							}
// 						} else {
// 							rl.DrawRectangleRec(et.collider, color_a(rl.YELLOW.rgb, 60))
// 						}
// 					}

// 				case EntityTypeAnimatedObject:
// 					if tex, ok := get_texture(et.texture); ok  {
// 						m.preview_anim.anim = {
// 							num_frames = et.num_frames,
// 							frame_length = et.frame_time,
// 							texture = et.texture,
// 						}

// 						update_animation(&m.preview_anim)
// 						source := animation_rect(&m.preview_anim, false)

// 						dest := rl.Rectangle {
// 							width = source.width,
// 							height = source.height,
// 						}

// 						rl.DrawTexturePro(tex, source, dest, linalg.floor(rect_local_middle(dest)), 0, rl.WHITE)

// 						mp := mouse_pos()

// 						if rl.IsMouseButtonPressed(.LEFT) && rl.CheckCollisionPointRec(mp, rect) {
// 							m.dragging = true
// 							m.drag_start = mp
// 						}

// 						if m.dragging {
// 							start_wp := linalg.floor(rl.GetScreenToWorld2D(m.drag_start, camera))
// 							wp := linalg.floor(rl.GetScreenToWorld2D(mp, camera))
// 							c := Rect {
// 								x = start_wp.x,
// 								y = start_wp.y,
// 								width = wp.x - start_wp.x,
// 								height = wp.y - start_wp.y,
// 							}

// 							if c.width < 0 {
// 								c.x += c.width
// 								c.width = -c.width
// 							}

// 							if c.height < 0 {
// 								c.y += c.height
// 								c.height = -c.height
// 							}

// 							rl.DrawRectangleRec(c, color_a(rl.YELLOW.rgb, 60))

// 							if rl.IsMouseButtonReleased(.LEFT) {
// 								et.collider = c
// 								m.dragging = false
// 								record_undo()
// 							}
// 						} else {
// 							rl.DrawRectangleRec(et.collider, color_a(rl.YELLOW.rgb, 60))
// 						}
// 					}
// 				case EntityTypeBuiltin:
// 			}

// 			rl.DrawCircleV({}, 1, rl.YELLOW)

// 			rl.EndMode2D()

// 			rl.EndScissorMode()

// 			if gui_button("Delete", cut_rect_left(&fields, button_width("Delete"), MetricToolbarSpacing)) {
// 				ha_remove(&w.entity_types, et.handle)
// 				record_undo()
// 			}
// 		}
// 	}

// 	edit_mode_move :: proc(rect: Rect, em: ^EditorMemory, m: ^EditModeMove) {
// 		rl.BeginScissorMode(i32(rect.x), i32(rect.y), i32(rect.width), i32(rect.height))
// 		camera := get_camera(em.camera_pos, em.zoom)

// 		switch &s in m.state {
// 			case EMEState_Default:
// 				if rl.IsMouseButtonPressed(.LEFT) {
// 					m.state = EMEState_Selecting {
// 						start = mouse_world_position(camera),
// 					}
// 				}

// 			case EMEState_Selecting:
// 				diff := mouse_world_position(camera) - s.start
// 				r := Rect {
// 					s.start.x,
// 					s.start.y,
// 					diff.x,
// 					diff.y,
// 				}

// 				if r.width < 0 {
// 					r.x += r.width
// 					r.width = -r.width
// 				}

// 				if r.height < 0 {
// 					r.y += r.height
// 					r.height = -r.height
// 				}

// 				draw_rectangle(r, color_a(rl.YELLOW.rgb, 50), 100)

// 				selected_tiles := make([dynamic]int, context.temp_allocator)

// 				for t, ti in em.world.tiles {
// 					if !em.sample_all_layers && t.layer != em.layer {
// 						continue
// 					}

// 					wr := tile_world_rect(t.x, t.y)

// 					if rl.CheckCollisionRecs(r, wr) {
// 						append(&selected_tiles, ti)
// 					}
// 				}

// 				for ti in selected_tiles {
// 					t := em.world.tiles[ti]
// 					wr := tile_world_rect(t.x, t.y)
// 					draw_rectangle(wr, color_a(rl.RED.rgb, 90), 100)
// 				}

// 				selected_entities := make([dynamic]EntityHandle, context.temp_allocator)

// 				e_iter := ha_make_iter(em.world.entities)
// 				for e, eh in ha_iter_ptr(&e_iter) {
// 					if !em.sample_all_layers && e.layer != em.layer {
// 						continue
// 					}


// 					wr := entity_picking_rect(e)

// 					if rl.CheckCollisionRecs(r, wr) {
// 						append(&selected_entities, eh)
// 					}
// 				}

// 				for se in selected_entities {
// 					e := ha_get_ptr(em.world.entities, se)
// 					r := entity_picking_rect(e)
// 					draw_rectangle(r, color_a(rl.RED.rgb, 90), 100)
// 				}

// 				if rl.IsMouseButtonUp(.LEFT) {
// 					if len(selected_entities) == 0 && len(selected_tiles) == 0 {
// 						m.state = EMEState_Default {}
// 					} else {
// 						m.state = EMEState_Moving {
// 							selected_entities = slice.clone(selected_entities[:]),
// 							selected_tiles = slice.clone(selected_tiles[:]),
// 						}
// 					}
// 				}

// 			case EMEState_Moving:
// 				if rl.IsMouseButtonPressed(.LEFT) {
// 					delete(s.selected_entities)
// 					delete(s.selected_tiles)
// 					m.state = EMEState_Selecting {
// 						start = mouse_world_position(camera),
// 					}
// 					break
// 				}

// 				if rl.IsKeyPressed(.DELETE) {
// 					slice.reverse_sort(s.selected_tiles[:])

// 					for ti in s.selected_tiles {
// 						unordered_remove(&em.world.tiles, ti)
// 					}

// 					for seh in s.selected_entities {
// 						destroy_entity(&em.world, seh)
// 					}

// 					record_undo()
// 					delete(s.selected_entities)
// 					delete(s.selected_tiles)
// 					m.state = EMEState_Default {}
// 					break
// 				}

// 				for ti in s.selected_tiles {
// 					t := em.world.tiles[ti]
// 					wr := tile_world_rect(t.x, t.y)
// 					draw_rectangle(wr, color_a(rl.RED.rgb, 90), 100)
// 				}

// 				for se in s.selected_entities {
// 					e := ha_get_ptr(em.world.entities, se)
// 					r := entity_picking_rect(e)
// 					draw_rectangle(r, color_a(rl.RED.rgb, 90), 100)
// 				}

// 				movement: Vec2

// 				if rl.IsKeyPressed(.LEFT) {
// 					movement.x -= 1
// 				}

// 				if rl.IsKeyPressed(.RIGHT) {
// 					movement.x += 1
// 				}

// 				if rl.IsKeyPressed(.UP) {
// 					movement.y -= 1
// 				}

// 				if rl.IsKeyPressed(.DOWN) {
// 					movement.y += 1
// 				}

// 				if movement.x != 0 || movement.y != 0 {
// 					for ti in s.selected_tiles {
// 						t := &em.world.tiles[ti]
// 						t.x += int(movement.x)
// 						t.y += int(movement.y)
// 					}

// 					for seh in s.selected_entities {
// 						e := ha_get_ptr(em.world.entities, seh)
// 						e.pos += movement * TileHeight
// 					}

// 					record_undo()
// 				}
// 		}

// 		edit_mode_draw_world(em, rect)

// 		rl.EndScissorMode()
// 	}

// 	edit_mode_dialogue :: proc(rect: Rect, em: ^EditorMemory, m: ^DialogueEditorState) {
// 		rect := rect
// 		bottom_toolbar := cut_rect_bottom(&rect, MetricToolbarHeight, 0)

// 		t: ^DialogueTree

// 		if int(em.edited_dialogue) < len(em.world.dialogue_trees) {
// 			t = &em.world.dialogue_trees[em.edited_dialogue]
// 		}

// 		if t != nil {
// 			dialogue_editor(rect, t, m)
// 		}

// 		rl.DrawRectangleRec(bottom_toolbar, ColorToolbarBackground)
// 		bottom_toolbar = inset_rect(bottom_toolbar, MetricToolbarPadding, MetricToolbarPadding)

// 		if new_val, changed := gui_enum_dropdown(cut_rect_left(&bottom_toolbar, 200, 0), em.edited_dialogue, "Current"); changed {
// 			em.edited_dialogue = new_val
// 		}
// 	}

// 	switch m in em.mode {
// 		case ^EditModePlaceTiles:
// 			edit_mode_place_tiles(window, em, m)

// 		case ^EditModePlaceEntities:
// 			edit_mode_place_entities(window, em, m)

// 		case ^EditModeEntityProperties:
// 			edit_mode_entity_properties(window, em, m)

// 		case ^EditModeEditEntityTypes:
// 			edit_mode_edit_entity_types(window, em, m)

// 		case ^EditModeMove:
// 			edit_mode_move(window, em, m)

// 		case ^DialogueEditorState:
// 			edit_mode_dialogue(window, em, m)
// 	}

// 	rl.DrawTexturePro(ui.overlay.texture, {0, 0, f32(ui.overlay.texture.width), f32(-ui.overlay.texture.height)}, {0, 0, f32(rl.GetRenderWidth()), f32(rl.GetRenderHeight())}, {}, 0, rl.WHITE)

// 	t := rl.GetTime()
// 	time_since_save := t - em.saved_at

// 	if time_since_save < 1 {
// 		text :cstring= "Saved!"
// 		color := rl.WHITE

// 		if em.save_error {
// 			text = "SAVE ERROR!!"
// 			color = rl.RED
// 		}

// 		rl.DrawTextEx(em.font, text, {10, 26}, MetricFontHeight * 4, 0, color)
// 	}

// 	rl.EndBlendMode()
// 	rl.EndShaderMode()
// }

// layer_view_mode_compatible :: proc(object_layer: int, lvm: LayerViewMode, layer: int) -> bool {
// 	if lvm == .All {
// 		return true
// 	}

// 	if lvm == .Current && object_layer == layer {
// 		return true
// 	}

// 	if lvm == .CurrentAndBehind && object_layer <= layer {
// 		return true
// 	}

// 	return false
// }
