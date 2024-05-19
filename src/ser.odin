package game

// import "core:fmt"
// import "core:intrinsics"
// import "core:reflect"
// import "core:strings"
// import "core:strconv"
// import "core:log"

// import "core:encoding/json"

// _ :: fmt

// Ser :: struct {
// 	is_writing: bool,
// 	cur: ^json.Value,
// 	root: json.Value,
// }

// ser_init_writer :: proc(s: ^Ser) {
// 	s.is_writing = true
// 	s.root = json.Object {}
// 	s.cur = &s.root
// }

// ser_init_reader :: proc(s: ^Ser, root: json.Value) {
// 	s.is_writing = false
// 	s.root = root
// 	s.cur = &s.root
// }

// @(require_results)
// ser_int :: proc(s: ^Ser, val: ^$T) -> bool where intrinsics.type_is_integer(T) && size_of(T) <= size_of(i64) {
// 	if s.is_writing {
// 		s.cur^ = json.Integer(val^)
// 	} else {
// 		v := s.cur.(json.Integer) or_return
// 		val^ = T(v)
// 	}

// 	return true
// }

// @(require_results)
// ser_float :: proc(s: ^Ser, val: ^$T) -> bool where intrinsics.type_is_float(T) {
// 	if s.is_writing {
// 		s.cur^ = json.Float(val^)
// 	} else {
// 		if v, ok := s.cur.(json.Float); ok {
// 			val^ = T(v)
// 		} else if v, ok := s.cur.(json.Integer); ok {
// 			val^ = T(v)
// 		} else {
// 			return false
// 		}
// 	}

// 	return true
// }

// @(require_results)
// ser_bool :: proc(s: ^Ser, val: ^$T) -> bool where intrinsics.type_is_boolean(T) {
// 	if s.is_writing {
// 		s.cur^ = json.Boolean(val^)
// 	} else {
// 		v := s.cur.(json.Boolean) or_return
// 		val^ = T(v)
// 	}

// 	return true
// }

// @(require_results)
// ser_string :: proc(s: ^Ser, val: ^string) -> bool {
// 	if s.is_writing {
// 		s.cur^ = json.String(strings.clone(val^))
// 	} else {
// 		v := s.cur.(json.String) or_return
// 		val^ = strings.clone(string(v))
// 	}

// 	return true
// }


// @(require_results)
// ser_enum :: proc(s: ^Ser, val: ^$T) -> bool where intrinsics.type_is_enum(T) {
// 	if s.is_writing {
// 		s.cur^ = json.Integer(val^)
// 	} else {
// 		v := s.cur.(json.Integer) or_return
// 		val^ = T(v)
// 	}

// 	return true
// }

// @(require_results)
// ser_union_tag_field :: proc(s: ^Ser, key: string, value: ^$T) -> bool
// where intrinsics.type_is_union(T) {
// 	tag: i64
// 	if s.is_writing {
// 		tag = reflect.get_union_variant_raw_tag(value^)
// 	}
// 	ser_field(s, key, &tag) or_return
// 	if !s.is_writing {
// 		reflect.set_union_variant_raw_tag(value^, tag)
// 	}
// 	return true
// }

// @(require_results)
// ser_slice :: proc(s: ^Ser, data: ^$T/[]$E) -> bool {
// 	if s.is_writing {
// 		s.cur^ = make(json.Array, len(data))
// 	} else {
// 		arr, is_arr := &s.cur.(json.Array)
// 		assert(is_arr, "ser_slice: cur is not json.Array")
// 		data^ = make([]E, len(arr^))
// 	}

// 	for &v, idx in data {
// 		ser_array_element(s, idx, &v) or_return
// 	}
// 	return true
// }

// @(require_results)
// ser_fixed_array :: proc(s: ^Ser, data: ^$T/[$N]$E) -> bool {
// 	if s.is_writing {
// 		s.cur^ = make(json.Array, len(data))
// 	} else {
// 		_, is_arr := &s.cur.(json.Array)
// 		assert(is_arr, "ser_slice: cur is not json.Array")
// 		data^ = {}
// 	}

// 	when intrinsics.type_is_enumerated_array(T) {
// 		for idx in 0..<len(N) {
// 			ser_array_element(s, idx, &data[N(idx)]) or_return
// 		}
// 	} else {
// 		for idx in 0..<N {
// 			ser_array_element(s, idx, &data[idx]) or_return
// 		}
// 	}
// 	return true
// }

// @(require_results)
// ser_dynamic_array :: proc(s: ^Ser, data: ^$T/[dynamic]$E, loc := #caller_location) -> bool {
// 	if s.is_writing {
// 		s.cur^ = make(json.Array, len(data))
// 	} else {
// 		arr, is_arr := &s.cur.(json.Array)
// 		assert(is_arr, "ser_dynamic_array: cur is not json.Array")
// 		data^ = make([dynamic]E, len(arr), loc = loc)
// 	}

// 	for &v, idx in data {
// 		ser_array_element(s, idx, &v) or_return
// 	}
// 	return true
// }

// @(require_results)
// ser_array_element :: proc(s: ^Ser, idx: int, v: ^$T) -> bool {
// 	prev_cur := s.cur
// 	arr, is_arr := &s.cur.(json.Array)
// 	assert(is_arr, "ser_array_element: cur is not json.Array")

// 	if s.is_writing {
// 		when intrinsics.type_is_struct(T) || intrinsics.type_is_union(T) {
// 			arr[idx] = json.Object{}
// 		} else {
// 			arr[idx] = json.Value {}
// 		}
// 	}

// 	s.cur = &arr[idx]

// 	when intrinsics.type_is_union(T) {
// 		ser_union_tag_field(s, "__tag", v) or_return
// 	}

// 	ser(s, v) or_return
// 	s.cur = prev_cur
// 	return true
// }

// @(require_results)
// ser_field :: proc(s: ^Ser, key: string, v: ^$T) -> bool {
// 	if s.is_writing {
// 		when intrinsics.type_is_struct(T) {
// 			if v^ == {} {
// 				return true
// 			}
// 		} else when intrinsics.type_is_numeric(T) {
// 			if v^ == {} {
// 				return true
// 			}
// 		} else when intrinsics.type_is_boolean(T) {
// 			if v^ == false {
// 				return true
// 			}
// 		}
// 	}

// 	prev_cur := s.cur
// 	obj, is_obj := &s.cur.(json.Object)
// 	assert(is_obj, "ser_field: cur is not json.Object")

// 	if s.is_writing {
// 		assert(!(key in obj), "ser_field writer: cur already has key")

// 		when intrinsics.type_is_struct(T) || intrinsics.type_is_union(T) {
// 			obj[strings.clone(key)] = json.Object {}
// 		} else {
// 			obj[strings.clone(key)] = json.Value {}
// 		}
// 	} else {
// 		if !(key in obj) {
// 			return true
// 		}
// 	}

// 	s.cur = &obj[key]

// 	when intrinsics.type_is_union(T) {
// 		if !s.is_writing && reflect.union_variant_typeid(s.cur^) == json.Integer {
// 			log.warnf("Enum has become Union: Assuming enum value can be to set raw tag! Value: %v", v)
// 			ti := type_info_of(T)
// 			no_nil := false
// 			if u, ok := ti.variant.(reflect.Type_Info_Union); ok {
// 				no_nil = u.no_nil
// 			}

// 			tag: i64

// 			ser_int(s, &tag) or_return

// 			if !no_nil {
// 				tag += 1
// 			}

// 			reflect.set_union_variant_raw_tag(v^, tag)
// 		} else {
// 			ser_union_tag_field(s, "__tag", v) or_return
// 		}
// 	}

// 	ser(s, v) or_return
// 	s.cur = prev_cur
// 	return true
// }

// ser :: proc {
// 	// basic built in json types
// 	ser_int,
// 	ser_slice,
// 	ser_dynamic_array,
// 	ser_fixed_array,
// 	ser_bool,
// 	ser_float,
// 	ser_enum,
// 	ser_string,

// 	// more complex types
// 	ser_uid,
// 	ser_spline_point,
// 	ser_rect,
// 	ser_entity_type,
// 	ser_entity_type_variant,
// 	ser_tile,
// 	ser_entity_handle,
// 	ser_entity,
// 	ser_entity_variant,
// 	ser_action,
// 	ser_dialogue_tree,
// 	ser_dialogue_node,
// 	ser_dialogue_node_variant,
// 	ser_dialogue_connection,
// 	ser_dialogue_choice,
// 	ser_event,
// 	ser_settings,
// }

// @(require_results)
// ser_uid :: proc(s: ^Ser, val: ^UID) -> bool {
// 	if s.is_writing {
// 		buf: [41]byte
// 		hex := strconv.append_bits_128(buf[:], u128(val^), 16, false, 128, strconv.digits, {.Prefix})
// 		s.cur^ = json.String(strings.clone(hex))
// 	} else {
// 		s := s.cur.(json.String) or_return
// 		i := strconv.parse_u128_maybe_prefixed(s) or_return
// 		val^ = UID(i)
// 	}

// 	return true
// }

// @(require_results)
// ser_entity_type :: proc(s: ^Ser, v: ^EntityType) -> bool {
// 	ser_field(s, "id", &v.id) or_return
// 	ser_field(s, "variant", &v.variant) or_return
// 	return true
// }

// @(require_results)
// ser_entity_type_variant :: proc(s: ^Ser, variant: ^EntityTypeVariant) -> bool {
// 	switch &v in variant {
// 		case EntityTypeStaticObject:
// 			ser_field(s, "collider", &v.collider) or_return

// 			if s.is_writing {
// 				n := texture_hash_from_handle(v.texture)
// 				ser_field(s, "texture", &n) or_return
// 			} else {
// 				n: Hash
// 				ser_field(s, "texture", &n) or_return
// 				v.texture = texture_handle_from_hash(n)
// 			}

// 			ser_field(s, "pushable", &v.pushable) or_return

// 		case EntityTypeAnimatedObject:
// 			ser_field(s, "collider", &v.collider) or_return

// 			if s.is_writing {
// 				n := texture_hash_from_handle(v.texture)
// 				ser_field(s, "texture", &n) or_return
// 			} else {
// 				n: Hash
// 				ser_field(s, "texture", &n) or_return
// 				v.texture = texture_handle_from_hash(n)
// 			}

// 			ser_field(s, "num_frames", &v.num_frames) or_return
// 			ser_field(s, "frame_time", &v.frame_time) or_return
// 			ser_field(s, "start_paused", &v.start_paused) or_return

// 		case EntityTypeBuiltin: unreachable()
// 	}
// 	return true
// }

// @(require_results)
// ser_rect :: proc(s: ^Ser, v: ^Rect) -> bool {
// 	ser_field(s, "x", &v.x) or_return
// 	ser_field(s, "y", &v.y) or_return
// 	ser_field(s, "width", &v.width) or_return
// 	ser_field(s, "height", &v.height) or_return
// 	return true
// }

// @(require_results)
// ser_tile :: proc(s: ^Ser, v: ^Tile) -> bool {
// 	ser_field(s, "tile_idx", &v.tile_idx) or_return
// 	ser_field(s, "x", &v.x) or_return
// 	ser_field(s, "y", &v.y) or_return
// 	ser_field(s, "layer", &v.layer) or_return
// 	ser_field(s, "flip_x", &v.flip_x) or_return
// 	ser_field(s, "flip_y", &v.flip_y) or_return
// 	return true
// }

// @(require_results)
// ser_spline_point :: proc(s: ^Ser, v: ^SplinePoint) -> bool {
// 	ser_field(s, "point", &v.point) or_return
// 	ser_field(s, "control_in", &v.control_in) or_return
// 	ser_field(s, "control_out", &v.control_out) or_return
// 	ser_field(s, "speed", &v.speed) or_return
// 	ser_field(s, "custom_rotation", &v.custom_rotation) or_return
// 	ser_field(s, "rotation", &v.rotation) or_return
// 	ser_field(s, "scale", &v.scale) or_return
// 	return true
// }

// @(require_results)
// ser_union_variant_typeid :: proc(s: ^Ser, key: string, v: ^typeid, $T: typeid) -> bool where intrinsics.type_is_union(T) {
// 	ti := runtime.type_info_base(type_info_of(T))
// 	uti, ok := ti.variant.(runtime.Type_Info_Union)

// 	if !ok {
// 		return false
// 	}

// 	if s.is_writing {
// 		assert(!uti.no_nil || v^ != nil)
// 		tag: int

// 		if v^ != nil {
// 			for var, i in uti.variants {
// 				if var.id == v^ {
// 					tag = i
// 					if !uti.no_nil {
// 						tag += 1
// 					}

// 					break
// 				}
// 			}
// 		}

// 		ser_field(s, key, &tag) or_return
// 	} else {
// 		tag: int
// 		ser_field(s, key, &tag) or_return

// 		if tag < len(uti.variants) {
// 			if uti.no_nil {
// 				v^ = uti.variants[tag].id
// 			} else {
// 				if tag == 0 {
// 					v^ = nil
// 				} else {
// 					v^ = uti.variants[tag-1].id
// 				}
// 			}
// 		} else {
// 			log.error("tag is out of range for union")
// 			return false
// 		}
// 	}

// 	return true
// }

// @(require_results)
// ser_entity_variant :: proc(s: ^Ser, variant: ^EntityVariant) -> bool {
// 	#partial switch &v in variant {
// 		case PlayerCat:
// 		case Rocket:
// 			ser_field(s, "state", &v.state) or_return
// 		case UNPC:
// 		case Pickup:
// 		case StaticObject:
// 		case AnimatedObject:
// 		case Trigger:
// 			ser_field(s, "rect", &v.rect) or_return
// 			ser_field(s, "name", &v.name) or_return
// 			ser_field(s, "target_id", &v.target.id) or_return
// 			ser_field(s, "required_state", &v.required_state) or_return
// 			ser_field(s, "destroy_on_trigger", &v.destroy_on_trigger) or_return
// 			ser_field(s, "event", &v.event) or_return
// 		case Spline:
// 			ser_field(s, "points", &v.points) or_return
// 			ser_field(s, "name", &v.name) or_return
// 			ser_field(s, "on_done_event", &v.on_done_event) or_return
// 			ser_field(s, "dont_scale", &v.dont_scale) or_return
// 		case Usable:
// 			ser_field(s, "icon", &v.icon) or_return
// 			ser_field(s, "actions", &v.actions) or_return
// 			ser_field(s, "not_interactable", &v.not_interactable) or_return
// 			ser_field(s, "progress_required", &v.progress_required) or_return
// 		case StaticCollider:
// 			ser_field(s, "collider", &v.collider) or_return
// 			ser_field(s, "one_direction", &v.one_direction) or_return

// 		case SplineEvaluator:
// 	}

// 	return true
// }

// @(require_results)
// ser_entity :: proc(s: ^Ser, v: ^Entity) -> bool {
// 	ser_field(s, "kind", &v.kind) or_return

// 	if !s.is_writing {
// 		v^ = create_entity_from_entity_kind(v.kind)
// 	}

// 	ser_field(s, "id", &v.id) or_return

// 	if v.id == 0 && !s.is_writing {
// 		v.id = new_uid()
// 	}

// 	ser_field(s, "facing", &v.facing) or_return
// 	ser_field(s, "hiden", &v.hidden) or_return
// 	ser_field(s, "pos", &v.pos) or_return
// 	ser_field(s, "layer", &v.layer) or_return
// 	ser_field(s, "scale", &v.scale) or_return
// 	ser_field(s, "rot", &v.rot) or_return
// 	ser_field(s, "parallax", &v.parallax) or_return
// 	ser_field(s, "parallax_y_lock", &v.parallax_y_lock) or_return

// 	if v.kind == .Legacy {
// 		ser_field(s, "type_id", &v.type.id) or_return
// 	}

// 	ser_field(s, "tag", &v.tag) or_return
// 	ser_field(s, "disabled", &v.disabled) or_return

// 	if v.kind == .Legacy {
// 		ser_field(s, "variant", &v.variant) or_return
// 		ser_field(s, "dialogue_name", &v.dialogue_name) or_return
// 	}

// 	ser_field(s, "flip_x", &v.flip_x) or_return

// 	return true
// }

// @(require_results)
// ser_action :: proc(s: ^Ser, a: ^Action) -> bool {
// 	switch v in a {
// 		case ActionPlayAnimation:
// 			ser_field(s, "entity", &v.entity) or_return
// 			ser_field(s, "oneshot", &v.oneshot) or_return

// 		case ActionDisableCollision:
// 			ser_field(s, "entity", &v.entity) or_return

// 		case ActionPickup:
// 			ser_field(s, "entity", &v.entity) or_return

// 		case ActionDeleteEntity:
// 			ser_field(s, "entity", &v.entity) or_return

// 		case ActionEnableEntity:
// 			ser_field(s, "entity", &v.entity) or_return

// 		case ActionLoadLevel:
// 			ser_field(s, "level_name", &v.level_name) or_return

// 		case ActionStartDialogue:
// 			ser_field(s, "entity", &v.entity) or_return
// 			ser_field(s, "dialogue_name", &v.dialogue_name) or_return
// 			ser_field(s, "entity", &v.entity) or_return
// 			ser_field(s, "auto_advance", &v.auto_advance) or_return

// 		case ActionMoveAlongSpline:
// 			ser_field(s, "entity", &v.entity) or_return
// 			ser_field(s, "spline", &v.spline) or_return
// 			ser_field(s, "done_interactable", &v.done_interactable) or_return

// 		case ActionPlayerJump:
// 			ser_field(s, "override_velocity", &v.override_velocity) or_return
// 			ser_field(s, "velocity", &v.velocity) or_return

// 		case ActionSetInteractionEnabled:
// 			ser_field(s, "target", &v.target) or_return
// 			ser_field(s, "enabled", &v.enabled) or_return

// 		case ActionFocusCamera:
// 			ser_field(s, "target", &v.target) or_return
// 			ser_field(s, "time", &v.time) or_return
// 	}

// 	return true
// }

// @(require_results)
// ser_entity_handle :: proc(s: ^Ser, v: ^EntityHandle) -> bool {
// 	ser_field(s, "id", &v.id) or_return
// 	return true
// }

// @(require_results)
// ser_level :: proc(s: ^Ser, v: ^Level) -> bool {
// 	ser_field(s, "tiles", &v.tiles) or_return
// 	ser_field(s, "entities", &v.entities) or_return
// 	return true
// }

// @(require_results)
// ser_dialogue_node_variant :: proc(s: ^Ser, a: ^DialogueNodeVariant) -> bool {
// 	switch v in a {
// 		case DialogueNodeVariantNormal:
// 			ser_field(s, "text", &v.text) or_return
// 			ser_field(s, "actor", &v.actor) or_return
// 			ser_field(s, "choices", &v.choices) or_return
// 			ser_field(s, "num_choices", &v.num_choices) or_return
// 			ser_field(s, "override_kind_enable", &v.override_kind_enable) or_return
// 			ser_field(s, "override_kind", &v.override_kind) or_return
// 			ser_field(s, "dont_animate", &v.dont_animate) or_return

// 		case DialogueNodeVariantStart:

// 		case DialogueNodeVariantProgressCheck:
// 			f := transmute(^i64)&v.progress_to_check

// 			ser_field(s, "progress_to_check", f) or_return

// 		case DialogueNodeVariantSetProgress:
// 			ser_field(s, "progress", &v.progress) or_return

// 		case DialogueNodeVariantGivePlayerItem:
// 			ser_field(s, "item", &v.item) or_return

// 		case DialogueNodeVariantTriggerEvent:
// 			ser_field(s, "event", &v.event) or_return

// 		case DialogueNodeVariantTakeItem:
// 			ser_field(s, "item", &v.item) or_return

// 		case DialogueNodeVariantItemCheck:
// 			ser_field(s, "item", &v.item) or_return
// 	}

// 	return true
// }


// @(require_results)
// ser_dialogue_choice :: proc(s: ^Ser, v: ^DialogueChoice) -> bool {
// 	ser_field(s, "text", &v.text) or_return
// 	ser_field(s, "check_progress", &v.check_progress) or_return
// 	ser_field(s, "does_not_have_progress", &v.does_not_have_progress) or_return
// 	f := transmute(^i64)&v.progress_to_check
// 	ser_field(s, "progress_to_check", f) or_return
// 	ser_field(s, "check_item", &v.check_item) or_return
// 	ser_field(s, "does_not_have_item", &v.does_not_have_item) or_return
// 	ser_field(s, "item_to_check", &v.item_to_check) or_return

// 	return true
// }


// @(require_results)
// ser_dialogue_node :: proc(s: ^Ser, v: ^DialogueNode) -> bool {
// 	ser_field(s, "pos", &v.pos) or_return
// 	ser_field(s, "unused", &v.unused) or_return
// 	ser_field(s, "variant", &v.variant) or_return

// 	return true
// }

// @(require_results)
// ser_dialogue_connection :: proc(s: ^Ser, v: ^DialogueConnection) -> bool {
// 	ser_field(s, "from", &v.from) or_return
// 	ser_field(s, "from_choice", &v.from_choice) or_return
// 	ser_field(s, "to", &v.to) or_return
// 	return true
// }

// @(require_results)
// ser_dialogue_tree :: proc(s: ^Ser, v: ^DialogueTree) -> bool {
// 	ser_field(s, "name", &v.name) or_return
// 	ser_field(s, "nodes", &v.nodes) or_return
// 	ser_field(s, "connections", &v.connections) or_return
// 	return true
// }

// @(require_results)
// ser_event :: proc(s: ^Ser, ev: ^Event) -> bool {
// 	switch &v in ev {
// 		case EventTalkToEntity:
// 			ser_field(s, "entity", &v.entity) or_return

// 		case EventDestroyEntityWithTag:
// 			ser_field(s, "tag", &v.tag) or_return

// 		case EventAngryDoorOpened:
// 		case EventCatEnterRocket:
// 		case EventReleaseHang:
// 		case EventGotOnionSeed:
// 		case EventGotEgg:
// 		case EventFlyToBookShelf:
// 		case EventSetProgressFlag:
// 			ser_field(s, "flag", &v.flag) or_return

// 		case EventGetItem:
// 			ser_field(s, "item", &v.item) or_return

// 		case EventSaySingleLine:
// 		case EventAnimateAlongSpline:
// 			ser_field(s, "entity", &v.entity) or_return
// 			ser_field(s, "spline", &v.spline) or_return

// 		case EventCatEnterRocketInFrontOfOak:

// 		case EventRocketSplineDone:
// 			ser_field(s, "spline", &v.spline) or_return

// 		case EventAcornOpen:
// 		case EventFadeEntityWithTag:
// 			ser_field(s, "tag", &v.tag) or_return

// 		case EventCatEnterRocketInSpace:

// 		case EventEndAcornSpace:
// 		case EventCheckIfAllPortraitsHung:

// 		case EventFloatIntoAir:
// 		case EventFlyOutFromPlanet:
// 		case EventHideRenderable:
// 		case EventFadeRenderable:
// 		case EventRemoveColliderAndAnimate:
// 		case EventStartAnimating:
// 		case EventJumpIntoBatter:
// 		case EventEggShake:
// 		case EventPlaySound:
// 		case EventFadePortraitToCat:
// 		case EventStartEnd:
// 		case EventOpenCave:
// 		case EventFlourThrown:
// 		case EventSetRenderable:
// 		case EventFadeOutMusic:
// 		case EventPutSeedInSoil:
// 		case EventFadeOutBird:

// 		case EventTeleportEntity:
// 			ser_field(s, "entity", &v.entity) or_return
// 			ser_field(s, "target", &v.target) or_return

// 	}
// 	return true
// }

// @(require_results)
// ser_settings :: proc(s: ^Ser, v: ^Settings) -> bool {
// 	ser_field(s, "keyboard_bindings", &v.keyboard_bindings) or_return
// 	return true
// }
