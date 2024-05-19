package game

// import "core:fmt"
// import "core:math"
// import "core:math/rand"
// import "core:math/linalg"
import "core:time"
// import "core:slice"
// import "core:strings"
// import "core:reflect"
import "core:log"
// import "core:intrinsics"
import "core:encoding/json"
import "core:os"
// import "core:unicode/utf8"
// import "core:path/filepath"
// import "core:prof/spall"
import rl "vendor:raylib"

Version :: "1.3"

GamePixelHeight :: 180

CAT_DEV :: #config(CAT_DEV, false)
// CatProfile :: #config(CatProfile, false)

// default_game_camera_zoom :: proc() -> f32 {
// 	return (screen_height()/GamePixelHeight)
// }

// gui_scale :: proc() -> f32 {
// 	return default_game_camera_zoom()
// }

Vec2i :: distinct [2]int
Vec2 :: rl.Vector2
Vec4 :: rl.Vector4
Rect :: rl.Rectangle

// rect_is_empty :: proc(r: Rect) -> bool {
// 	return r.width == 0 || r.height == 0
// }

// recreate_grabpoints :: proc(w: ^World) {
// 	tiles_with_collision := make(map[Vec2i]struct{}, 10, context.temp_allocator)

// 	for c in w.colliders {
// 		if c.tile != 0 {
// 			t := w.tiles[c.tile]
// 			tiles_with_collision[{t.x, t.y}] = {}
// 		}
// 	}

// 	for c in w.colliders {
// 		if c.one_direction {
// 			continue
// 		}

// 		left_allowed := true
// 		right_allowed := true
// 		if c.tile != 0 {
// 			t := w.tiles[c.tile]
// 			pos := Vec2i {t.x, t.y}
// 		 	pos_left := pos + {-1, 0}
// 		 	pos_left_up := pos + {-1, -1}
// 			pos_right := pos + {1, 0}
// 		 	pos_right_up := pos + {1, -1}
// 			pos_up := pos + {0, -1}

// 			if pos_up in tiles_with_collision {
// 				left_allowed = false
// 				right_allowed = false
// 			}

// 			if pos_left in tiles_with_collision {
// 				left_allowed = false
// 			}

// 			if pos_right in tiles_with_collision {
// 				right_allowed = false
// 			}

// 			if pos_left_up in tiles_with_collision {
// 				left_allowed = false
// 			}

// 			if pos_right_up in tiles_with_collision {
// 				right_allowed = false
// 			}
// 		}

// 		p1 := rect_top_left(c.rect)
// 		p2 := rect_top_right(c.rect)

// 		if left_allowed && is_hang_state_allowed(w, p1, .East) {
// 			append(&w.grab_points, GrabPoint{ pos = p1, compatible_facing = .East })
// 		}

// 		if right_allowed && is_hang_state_allowed(w, p2, .West) {
// 			append(&w.grab_points, GrabPoint{ pos = p2, compatible_facing = .West })
// 		}
// 	}
// }

// rect_add_pos :: proc(r: Rect, p: Vec2) -> Rect {
// 	return {
// 		r.x + p.x,
// 		r.y + p.y,
// 		r.width,
// 		r.height,
// 	}
// }

LevelName :: enum {
	IntroDream,
	Planet,
	House,
	Space,
	SpaceHouse,
	PancakeBatterLand,
	MainMenu,
}

// Checkpoint :: enum {
// 	None,
// 	Intro,
// 	Planet,
// 	OtherPlace,
// 	Space,
// 	PlanetBack,
// 	SpaceHouse,
// 	PancakeBatterLand,
// 	PlanetGotEgg,
// }

// load_checkpoint :: proc(c: Checkpoint, portraits: bit_set[Portrait]) {
// 	clear(&g_mem.inventory.items)
// 	g_mem.hide_hud = false
// 	g_mem.last_saved_at = time.now()

// 	add_portraits :: proc(portraits: bit_set[Portrait]) {
// 		if .Klucke in portraits {
// 			add_to_inventory_raw(.KluckePortrait)
// 		}

// 		if .Lakrits in portraits {
// 			add_to_inventory_raw(.LakritsPortrait)
// 		}

// 		if .Lillemor in portraits {
// 			add_to_inventory_raw(.LillemorPortrait)
// 		}

// 		if .Pontus in portraits {
// 			add_to_inventory_raw(.PontusPortrait)
// 		}
// 	}

// 	switch c {
// 		case .Intro, .None:
// 			g_mem.progress = {}
// 			add_portraits(portraits)
// 			load_level(.IntroDream)
// 			play_music(&g_mem.music, .None)
// 		case .Planet:
// 			g_mem.progress = {}
// 			add_portraits(portraits)
// 			load_level(.Planet)
// 			play_music(&g_mem.music, .Catnap)

// 		case .PlanetGotEgg:
// 			g_mem.progress = {.HideTutorialStuff, .BirdGreeted, .GottenScoldedByFlourTree, .HasSmackedFlourTree, .HasFlouredWall, .GotEgg, .WaterfallGreeted, .TalkedToSquirrel }
// 			add_to_inventory_raw(.Butter)
// 			add_to_inventory_raw(.BaseballBat)
// 			add_to_inventory_raw(.Flour)
// 			add_to_inventory_raw(.Egg)
// 			add_portraits(portraits)
// 			load_level(.Planet)
// 			play_music(&g_mem.music, .Catnap)

// 		case .OtherPlace:
// 			g_mem.progress = {.HideTutorialStuff, .HasFlouredWall }
// 			add_to_inventory_raw(.Butter)
// 			add_to_inventory_raw(.BaseballBat)
// 			add_to_inventory_raw(.Flour)
// 			add_to_inventory_raw(.Egg)
// 			add_portraits(portraits)
// 			load_level(.House)
// 			play_music(&g_mem.music, .Catnap)
// 		case .Space:
// 			g_mem.progress = {.HideTutorialStuff, .HasFlouredWall  }
// 			add_to_inventory_raw(.Butter)
// 			add_to_inventory_raw(.BaseballBat)
// 			add_to_inventory_raw(.Flour)
// 			add_to_inventory_raw(.Egg)
// 			add_portraits(portraits)
// 			load_level(.Space)
// 			play_music(&g_mem.music, .Catnap)
// 		case .PlanetBack:
// 			g_mem.progress = {.HideTutorialStuff, .SpaceEnded, .HasFlouredWall }
// 			add_to_inventory_raw(.Butter)
// 			add_to_inventory_raw(.BaseballBat)
// 			add_to_inventory_raw(.Flour)
// 			add_to_inventory_raw(.Egg)
// 			add_portraits(portraits)
// 			load_level(.Planet)
// 			play_music(&g_mem.music, .Catnap)
// 		case .SpaceHouse:
// 			g_mem.progress = {.HideTutorialStuff, }
// 			add_to_inventory_raw(.Butter)
// 			add_to_inventory_raw(.BaseballBat)
// 			add_to_inventory_raw(.Flour)
// 			add_to_inventory_raw(.Egg)
// 			add_portraits(portraits)
// 			load_level(.SpaceHouse)
// 			play_music(&g_mem.music, .Catnap)
// 		case .PancakeBatterLand:
// 			g_mem.progress = {.HideTutorialStuff, }
// 			add_to_inventory_raw(.BaseballBat)
// 			add_portraits(portraits)
// 			load_level(.PancakeBatterLand)
// 			play_music(&g_mem.music, .Catnap)
// 	}

// 	g_mem.save.portraits = portraits
// }

// Facing :: enum {
// 	East,
// 	West,
// }

// PickupType :: enum {
// 	None,
// 	OnionSeed,
// 	WaterBucket,
// 	Egg,
// 	Key,
// 	Butter,
// 	Flour,
// 	BaseballBat,
// 	Unused,
// 	KluckePortrait,
// 	LakritsPortrait,
// 	LillemorPortrait,
// 	PontusPortrait,
// }

// pickup_descriptions := [PickupType]string {
// 	.None = "This is a bug",
// 	.OnionSeed = "The onion seed! I must grow it",
// 	.WaterBucket = "It's a bucket, full of water!",
// 	.Egg = "Egg egg eggers! Birdy egg",
// 	.Key = "It's Squirrels root cellar key",
// 	.Butter = "It's butter! Butter makes pancakes good and cats very slippery",
// 	.Flour = "It's flour. Good for making pancakes, and making slippery things sticky!",
// 	.BaseballBat = "A BASEBALL BAT! It can smack things! Shake things! Open things! Also, it can sports",
// 	.Unused = "This is a bug",
// 	.KluckePortrait = "A portrait showing one of the mythological ancestors!",
// 	.LakritsPortrait = "It's a portrait of a charming cat in a tuxedo!",
// 	.LillemorPortrait = "A portrait of a particularly fine cat!",
// 	.PontusPortrait = "A depiction of a fine gentleman!",
// }

// Pickup :: struct {
// 	pickup_type: PickupType,
// }


// add_to_inventory_raw :: proc(item: PickupType) {
// 	for i in g_mem.inventory.items {
// 		if i.item == item {
// 			return
// 		}
// 	}

// 	inv_item := InventoryItem {
// 		item = item,
// 	}

// 	append(&g_mem.inventory.items, inv_item)
// }

// add_to_inventory :: proc(item: PickupType, world_pos: Vec2, has_world_pos: bool = false) {
// 	for i in g_mem.inventory.items {
// 		if i.item == item {
// 			return
// 		}
// 	}

// 	inv_item := InventoryItem {
// 		item = item,
// 		added_at = g_mem.time,
// 	}

// 	if has_world_pos {
// 		c := get_camera(g_mem.camera_state)
// 		inv_item.original_screen_pos = rl.GetWorldToScreen2D(world_pos, c)
// 		inv_item.has_original_screen_pos = true
// 	}

// 	append(&g_mem.inventory.items, inv_item)

// 	#partial switch item {
// 		case .Egg:
// 			send_event(EventGotEgg{})

// 		case .OnionSeed:
// 			send_event(EventGotOnionSeed{})

// 		case .Butter:
// 			ent_iter := ha_make_iter(g_mem.world.entities)
// 			for e, eh in ha_iter_ptr(&ent_iter) {
// 				if v, ok := e.variant.(Trigger); ok && v.name == .FlashButterPickup {
// 					destroy_entity(world, eh)
// 					break
// 				}
// 			}

// 		case .KluckePortrait:
// 			g_mem.show_portrait = .Klucke
// 			// steam_add_achievement(.Klucke)

// 		case .LakritsPortrait:
// 			g_mem.show_portrait = .Lakrits
// 			// steam_add_achievement(.Lakrits)

// 		case .LillemorPortrait:
// 			g_mem.show_portrait = .Lillemor
// 			// steam_add_achievement(.Lillemor)

// 		case .PontusPortrait:
// 			g_mem.show_portrait = .Pontus
// 			// steam_add_achievement(.Pontus)
// 	}
// }

// pickup_item :: proc(item: EntityHandle) {
// 	if e := get_entity_raw(item); e != nil && e.pickup != .None {
// 		add_to_inventory(e.pickup, e.pos, true)

// 		say_text: string

// 		if len(e.examine_text) > 0 {
// 			say_text = e.examine_text
// 		} else {
// 			say_text = pickup_descriptions[e.pickup]
// 		}

// 		if e.pickup == .Egg {
// 			say_text = ""
// 		}

// 		if say_text != "" {
// 			send_delayed_event(EventSaySingleLine { entity = g_mem.cat, line = strings.clone(say_text)}, PickupAnimateTime + 0.1)
// 		}

// 		destroy_entity(world, e.handle)
// 		play_sound_range(.Pickup1, .Pickup1)
// 	}
// }

// StaticCollider :: struct {
// 	collider: Rect,
// 	one_direction: bool,
// }

// StaticObject :: struct {
// 	texture: TextureHandle,
// }

// AnimatedObject :: struct {
// 	anim: AnimationInstance,
// 	playing: bool,
// 	oneshot: bool,
// }

// TriggerName :: enum {
// 	None,
// 	OnionSpot,
// 	NearSquirrel,
// 	Unused,
// 	SetCameraY,
// 	UseInteractable,
// 	CameraVolume,
// 	ClimbHighVolume,
// 	CameraVolumeFit,
// 	FlashButterPickup,
// 	FlashTalk,
// 	FadeOutEntity,
// 	FlashButter,
// }

// trigger_world_rect :: proc(t: EntityInst(Trigger)) -> Rect{
// 	return rect_add_pos(t.rect, t.pos)
// }

// Trigger :: struct {
// 	rect: Rect,
// 	name: TriggerName,
// 	target: EntityHandle,
// 	required_state: int,
// 	destroy_on_trigger: bool,
// 	event: Event,
// }

EntityHandle :: distinct Handle

// EntityHandleNone :: EntityHandle(HandleNone)

// SplinePoint :: struct {
// 	using point: Vec2,
// 	control_in: Vec2,
// 	control_out: Vec2,
// 	speed: f32,
// 	custom_rotation: bool,
// 	rotation: f32,
// 	scale: f32,
// }

// world_spline_point :: proc(p: SplinePoint, parent: Vec2) -> SplinePoint {
// 	res := p

// 	res.point += parent
// 	res.control_in += parent
// 	res.control_out += parent

// 	return res
// }

// Spline :: struct {
// 	name: string,
// 	points: [dynamic]SplinePoint,
// 	on_done_event: Event,
// 	dont_scale: bool,
// }

// EntityReference :: distinct UID

// EntityReferenceNone :: EntityReference(0)

// Tag :: enum {
// 	None,
// 	BeforeEgg,
// 	AfterEgg,
// 	RootCellarBlocker,
// 	RootCellarDoorBg,
// 	OnOnionPickup,
// 	Cloud,
// 	FarCloud,
// 	Squirrel,
// 	RocketFlyUpToBookshelfInteractable,
// 	FlourTree,
// 	FlourTreeFace,
// 	RocketLandingSpline,
// 	RocketFlyToSecondRoomSpline,
// 	FlyUpOakSpline,
// 	Acorn,
// 	CatIntoAcornSpline,
// 	RocketIntoAcornSpline,
// 	USpaceToPlanetStartPos,
// 	RemoveWhenComingFromSpace,
// 	RootCellarHatch,
// 	JumpIntoBatterSpline,
// 	ReturnToPlanetSpline,
// 	EggShell,
// 	Oak,
// 	PancakeStack,
// 	PancakeStackSpline,

// 	Easel1,
// 	EaselSpline1,
// 	Easel2,
// 	EaselSpline2,
// 	Easel3,
// 	EaselSpline3,
// 	Easel4,
// 	EaselSpline4,

// 	IntroCloud,
// 	IntroCloudSpline,
// 	IntroSquirrel,
// 	IntroSquirrelSpline,

// 	SquirrelRocket,
// 	EndingSplineEnterSquirrel,
// 	EndingSplineFetchPancakes,
// 	EndingSplineWithPancakes,

// 	EndKlucke,
// 	EndLakrits,
// 	EndLillemor,
// 	EndPontus,

// 	EndingSplineFlyAway,

// 	PlanetWestWalls,
// 	PlanetEastWall,
// 	CaveFace,
// 	FlashTalkTrigger,
// }

// ActionPlayAnimation :: struct {
// 	entity: EntityHandle,
// 	oneshot: bool,
// }

// ActionDisableCollision :: struct {
// 	entity: EntityHandle,
// }

// ActionStartDialogue :: struct {
// 	entity: EntityHandle,
// 	dialogue_name: DialogueName,
// 	auto_advance: bool,
// }

// ActionPickup :: struct {
// 	entity: EntityHandle,
// }

// ActionDeleteEntity :: struct {
// 	entity: EntityHandle,
// }

// ActionEnableEntity :: struct {
// 	entity: EntityHandle,
// }

// ActionLoadLevel :: struct {
// 	level_name: LevelName,
// }

// ActionMoveAlongSpline :: struct {
// 	entity: EntityHandle,
// 	spline: EntityHandle,
// 	done_interactable: EntityHandle,
// }

// ActionPlayerJump :: struct {
// 	override_velocity: bool,
// 	velocity: Vec2,
// }

// ActionSetInteractionEnabled :: struct {
// 	target: EntityHandle,
// 	enabled: bool,
// }

// ActionFocusCamera :: struct {
// 	target: EntityHandle,
// 	time: f32,
// }

// Action :: union {
// 	ActionPlayAnimation,
// 	ActionDisableCollision,
// 	ActionFocusCamera,
// 	ActionPickup,
// 	ActionDeleteEntity,
// 	ActionEnableEntity,
// 	ActionLoadLevel,
// 	ActionStartDialogue,
// 	ActionMoveAlongSpline,
// 	ActionPlayerJump,
// 	ActionSetInteractionEnabled,
// }

// UsableIcon :: enum {
// 	ActionButton,
// 	Talk,
// 	None,
// }

// Usable :: struct {
// 	icon: UsableIcon,
// 	progress_required: ProgressFlag,
// 	item_required: PickupType,
// 	actions: [dynamic]Action,
// 	not_interactable: bool,
// }

// entity_variant_from_entity_type :: proc(et: EntityType) -> EntityVariant {
// 	switch v in et.variant {
// 		case EntityTypeStaticObject: return StaticObject {}
// 		case EntityTypeAnimatedObject: return AnimatedObject {}
// 		case EntityTypeBuiltin: {
// 			#partial switch v.variant {
// 				case .None:
// 					panic("Invalid bultin type")

// 				case .Trigger:
// 					return Trigger{}

// 				case .Interactable:
// 					return Usable{}

// 				case .Spline:
// 					return Spline{}

// 				case .Collider:
// 					return StaticCollider{}
// 			}
// 		}
// 	}

// 	panic("invalid entity type")
// }

// SplineEvaluator :: struct {
// 	target: EntityHandle,
// 	spline: EntityHandle,
// 	time: f32,
// 	on_done: EntityHandle,
// 	on_done_event: Event,
// 	interactable_on_done: bool,
// 	camera_follow: bool,
// }

// UNPC :: struct {

// }


// AcornAnimator :: struct {
// 	start_pos: Vec2,
// 	start_zoom: f32,
// 	cat: EntityHandle,
// 	rocket: EntityHandle,
// 	cat_lerp_start_pos: Vec2,
// 	cat_lerp_start_pos_set: bool,
// 	rocket_lerp_start_pos: Vec2,
// 	rocket_lerp_start_pos_set: bool,
// }

// EntityVariant :: union {
// 	PlayerCat,
// 	Rocket,
// 	UNPC,
// 	Pickup,
// 	StaticObject,
// 	AnimatedObject,
// 	Trigger,
// 	Spline,
// 	Usable,
// 	StaticCollider,
// 	SplineEvaluator,
// 	AcornAnimator,
// }

// UseItemHandlerProc :: proc(^Entity, PickupType)

// slap :: proc() {
// 	if cat, ok := get_entity(g_mem.cat, PlayerCat); ok {
// 		set_state(cat, PlayerStateSlaping{})
// 	}
// }

// baseball_slap :: proc(delay: f32 = 0) {
// 	if cat, ok := get_entity(g_mem.cat, PlayerCat); ok {
// 		set_state(cat, PlayerStateOneShotAnim{ anim = cat.anim_baseball, delay = delay })
// 	}
// }

// baseball_slap_up :: proc() {
// 	if cat, ok := get_entity(g_mem.cat, PlayerCat); ok {
// 		set_state(cat, PlayerStateOneShotAnim{ anim = cat.anim_baseball_up})
// 	}
// }

// uih_default :: proc(e: ^Entity, item: PickupType) {
// 	line: string
// 	switch item {
// 		case .None: line = "This is a bug"
// 		case .OnionSeed: line = "I must find a nice spot to plant this"
// 		case .WaterBucket: line = "That doesn't need dampening"
// 		case .Egg: line = "That would be rude"
// 		case .Key: line = "That's no door!"
// 		case .Butter: line = "Don't wanna butter that"
// 		case .Flour: line = "Doesn't need flour"
// 		case .BaseballBat: line = "It doesn't need baseballin', unfortunately"
// 		case .KluckePortrait: line = "I'm keeping this until the end!"
// 		case .LakritsPortrait: line = "No, this portrait is important!"
// 		case .LillemorPortrait: line = "I don't wanna use this pretty portrait with anything!"
// 		case .Unused: line = "This is a bug"
// 		case .PontusPortrait: line = "No, this thing belongs in a museum!"
// 	}
// 	player_say(line)
// }

// disable_interaction_seconds :: proc(s: f32) {
// 	g_mem.disable_interaction_until = g_mem.time + f64(s)
// }

// uih_flour_tree :: proc(e: ^Entity, item: PickupType) {
// 	if item == .BaseballBat {
// 		if get_progress(.HasSmackedFlourTree) || get_progress(.SpaceEnded) {
// 			followup := EventSaySingleLine{ entity = e.handle, line = strings.clone("I am already angriest!!")}
// 			player_say("Eeee, don't wanna do that again, he'll get even angrier!", end_event = followup)
// 			return
// 		}

// 		if !get_progress(.TalkedToSquirrel) {
// 			player_say("Uhm, not sure why I would do that! Perhaps I should talk to Squirrel first")
// 			return
// 		}

// 		baseball_slap()

// 		e.renderables[1].frame_timer += 1
// 		e.renderables[2].frame_timer += 1
// 		e.renderables[1].is_animating = true
// 		e.renderables[2].is_animating = true

// 		set_progress(.HasSmackedFlourTree)
// 		g_mem.disable_input_until = g_mem.time + 3.3
// 		send_delayed_event(EventTalkToEntity { entity = e.handle }, 3.3)
// 		send_delayed_event(EventGetItem {item = .Flour, from_pos = e.pos + {20,30}, has_from_pos = true}, 3)
// 		disable_interaction_seconds(4)
// 	} else if item == .Flour {
// 		say_single_line(e.handle, "You think you're funny?")
// 	} else {
// 		uih_default(e, item)
// 	}
// }

// uih_rock_wall :: proc(e: ^Entity, item: PickupType) {
// 	if item == .Flour {
// 		if cat, ok := get_entity(g_mem.cat, PlayerCat); ok {
// 			end_event := EventFlourThrown {
// 				wall = e.handle,
// 			}

// 			set_state(cat, PlayerStateOneShotAnim{ anim = cat.anim_throw_flour, end_event = end_event, walk_to_target_x = true, target_x = e.pos.x + (e.flip_x ? 34 : -34) })
// 		}
// 	} else if item == .Butter {
// 		player_say("This wall is already slippery, butter would make it worse!")
// 	} else {
// 		uih_default(e, item)
// 	}
// }

// open_root_cellar_door :: proc(e: ^Entity) {
// 	bg := find_entity_with_tag(.RootCellarDoorBg)
// 	blocker := find_entity_with_tag(.RootCellarBlocker)

// 	destroy_entity(world, blocker)
// 	remove_colliders_for_entity(world, bg)

// 	e.renderables[0].is_animating = true
// 	e.interactable = false
// }

// uih_root_cellar_door :: proc(e: ^Entity, item: PickupType) {
// 	if item == .BaseballBat {
// 		baseball_slap()
// 		send_delayed_event(EventSaySingleLine{ entity = g_mem.cat, line = strings.clone("That's one sturdy door! I'm gonna need a key")}, 1.5)
// 		return
// 	} else if item == .Key {
// 		play_sound_alias(.Pickup0)
// 		open_root_cellar_door(e)
// 		remove_inventory_item(.Key)
// 		return

// }
// 	uih_default(e, item)
// }

// EventPutSeedInSoil :: struct {
// 	pos: Vec2,
// }

// handle_put_seed_in_soil :: proc(e: EventPutSeedInSoil) {
// 	os := create_entity_from_entity_kind(.OnionSeed)
// 	os.pickup = .None
// 	os.pos = e.pos
// 	os.layer = 2
// 	os.use_item_handler = .OnionSeedInSoil
// 	os.interactable_distance = 18
// 	os.examine_text = "Doesn't seem to grow. Maybe it needs water?"
// 	add_entity(world, os)
// }

// uih_soil :: proc(e: ^Entity, item: PickupType) {
// 	if item == .OnionSeed {
// 		if cat, ok := get_entity(g_mem.cat, PlayerCat); ok {
// 			set_state(cat, PlayerStateOneShotAnim {
// 				anim = cat.anim_place_onion,
// 				walk_to_target_x = true,
// 				target_x = e.pos.x - 8,
// 				manual_end_facing = .East,
// 				end_event = EventPutSeedInSoil { pos = e.pos + {0, -10} },
// 			})
// 		}
// 		remove_inventory_item(.OnionSeed)
// 		set_progress(.OnionPlanted)
// 		e.interactable = false
// 	} else {
// 		uih_default(e, item)
// 	}
// }

// uih_angry_door_closed :: proc(e: ^Entity, item: PickupType) {
// 	if item == .BaseballBat {
// 		baseball_slap()

// 		send_delayed_event(EventStartAnimating { entity = e.handle, renderable = 1}, 1.1)
// 		e.collider = {}
// 		remove_colliders_for_entity(world, e.handle)

// 		e.interactable = false

// 		send_delayed_event(EventAngryDoorOpened{e.handle}, 1.4)
// 	} else {
// 		uih_default(e, item)
// 	}
// }

// buttercharge :: proc(interactable: ^Entity) {
// 	if p, ok := get_entity(g_mem.cat, PlayerCat); ok {
// 		offset := (interactable_pos(interactable).x - p.pos.x) + (p.facing == .East ? -15 : 15)
// 		set_state(p, PlayerStateButterCharge{ start_offset = offset })
// 	}
// }

// uih_tutorial_opening :: proc(e: ^Entity, item: PickupType) {
// 	if item == .Butter {
// 		set_progress(.HideTutorialStuff)
// 		buttercharge(e)
// 		destroy_trigger(.FlashButter)
// 	} else {
// 		uih_default(e, item)
// 	}
// }

// uih_hidden_opening :: proc(e: ^Entity, item: PickupType) {
// 	if item == .Butter {
// 		send_delayed_event(EventFadeRenderable{entity = e.handle, renderable = 1, fade_time = 0.5}, 1.2)
// 		buttercharge(e)
// 	} else {
// 		uih_default(e, item)
// 	}
// }

// uih_butter_return_exit :: proc(e: ^Entity, item: PickupType) {
// 	if item == .Butter {
// 		if p, ok := get_entity(g_mem.cat, PlayerCat); ok {
// 			buttercharge(e)
// 		}
// 	} else {
// 		uih_default(e, item)
// 	}
// }

// player_say :: proc(line: string, end_event: Event = nil) {
// 	say_single_line(g_mem.controlled_entity, line, end_event = end_event)
// }

// uih_angry_door_opened :: proc(e: ^Entity, item: PickupType) {
// 	if item == .BaseballBat {
// 		player_say("That would be undiplomatic")
// 	} else {
// 		uih_default(e, item)
// 	}
// }

// uih_onion_seed_in_soil :: proc(e: ^Entity, item: PickupType) {
// 	if item == .WaterBucket {
// 		if cat, ok := get_entity(g_mem.cat, PlayerCat); ok {
// 			set_state(cat, PlayerStateOneShotAnim { anim = cat.anim_water })
// 		}
// 		r := create_entity_from_entity_kind(.Rocket)
// 		r.pos = e.pos + {0, -14}

// 		if rv, ok := &r.variant.(Rocket); ok {
// 			rv.prev_pos = r.pos // this fixes glitches due to calulated velocity being big
// 		}

// 		r.layer = 4
// 		rh := add_entity(world, r)
// 		destroy_entity(world, e.handle)
// 		remove_inventory_item(item)
// 		set_progress(.OnionGrown)

// 		g_mem.disable_interaction_until = g_mem.time + 3.4
// 		send_delayed_event(EventTalkToEntity { entity = rh}, 3.4)
// 	} else {
// 		uih_default(e, item)
// 	}
// }

// uih_front_door :: proc(e: ^Entity, item: PickupType) {
// 	if item == .BaseballBat {
// 		baseball_slap()
// 		e.interactable = false

// 		spline := find_entity_with_tag(.RocketFlyToSecondRoomSpline)

// 		e := Entity {
// 			variant = SplineEvaluator {
// 				target = g_mem.rocket,
// 				spline = spline,
// 				interactable_on_done = true,
// 			},
// 		}

// 		add_entity(world, e)
// 		send_delayed_event(EventSaySingleLine{ entity = g_mem.cat, line = strings.clone("This door seems to neither open nor scold me. It's locked!")}, 0.8)
// 		set_progress(.TriedToOpenDoor)
// 	} else {
// 		uih_default(e, item)
// 	}
// }

// uih_hatch :: proc(e: ^Entity, item: PickupType) {
// 	if item == .BaseballBat {
// 		send_delayed_event(EventRemoveColliderAndAnimate { entity = e.handle, renderable = 0 }, 1)
// 		e.interactable = false
// 		baseball_slap_up()
// 		return
// 	}

// 	uih_default(e, item)
// }

// uih_small_egg_shell :: proc(e: ^Entity, item: PickupType) {
// 	if item == .BaseballBat {
// 		say_single_line(g_mem.cat, "WE SHALL HAVE PANCAKES WITHOUT CRUNCHY BITS!!")
// 		delay :: 2.5
// 		baseball_slap(delay)
// 		e.interactable = false
// 		send_delayed_event(EventStartAnimating { entity = e.handle, renderable = 0 }, delay + 1)
// 		send_delayed_event(EventAnimateAlongSpline { entity = find_entity_with_tag(.Easel1), spline = find_entity_with_tag(.EaselSpline1)}, delay + 3.2)
// 		send_delayed_event(EventAnimateAlongSpline { entity = find_entity_with_tag(.Easel2), spline = find_entity_with_tag(.EaselSpline2)}, delay + 3.2)
// 		send_delayed_event(EventAnimateAlongSpline { entity = find_entity_with_tag(.Easel3), spline = find_entity_with_tag(.EaselSpline3)}, delay + 3.2)
// 		send_delayed_event(EventAnimateAlongSpline { entity = find_entity_with_tag(.Easel4), spline = find_entity_with_tag(.EaselSpline4)}, delay + 3.2)

// 		send_delayed_event(EventCheckIfAllPortraitsHung {}, delay + 3)
// 	}
// }


// uih_easel :: proc(e: ^Entity, item: PickupType) {
// 	if item == .KluckePortrait || item == .LillemorPortrait || item == .LakritsPortrait || item == .PontusPortrait  {
// 		e.interactable = false
// 		e.num_renderables = 2

// 		tex: TextureHandle

// 		delay :: 1

// 		g_mem.disable_input_until = g_mem.time + delay + 3
// 		g_mem.disable_interaction_until = g_mem.time + delay + 3.5

// 		if item == .KluckePortrait {
// 			tex = get_texture_handle(.KluckePortrait)
// 			send_delayed_event(EventFadePortraitToCat {easel = e.handle, portrait = .Klucke}, delay)
// 		} else if item == .LillemorPortrait {
// 			tex = get_texture_handle(.LillemorPortrait)
// 			send_delayed_event(EventFadePortraitToCat {easel = e.handle, portrait = .Lillemor}, delay)
// 		} else if item == .LakritsPortrait {
// 			tex = get_texture_handle(.LakritsPortrait)
// 			send_delayed_event(EventFadePortraitToCat {easel = e.handle, portrait = .Lakrits}, delay)
// 		} else if item == .PontusPortrait {
// 			tex = get_texture_handle(.PontusPortrait)
// 			send_delayed_event(EventFadePortraitToCat {easel = e.handle, portrait = .Pontus}, delay)
// 		}

// 		play_sound_range(.Step0, .Step4	)

// 		e.renderables[1] = { texture = tex, offset = {0, -4}, relative_layer = -1 }
// 		remove_inventory_item(item)
// 	} else {
// 		uih_default(e, item)
// 	}
// }

// uih_batter_bowl :: proc(e: ^Entity, item: PickupType) {
// 	check_ingredients :: proc() {
// 		if get_progress(.BatterHasEgg) && get_progress(.BatterHasFlour) && get_progress(.BatterHasButter) {
// 			sqr := find_entity_of_kind(.Squirrel)

// 			if sqre := get_entity_raw(sqr); sqre != nil {
// 				sqre.dialogue_name = .EggShell
// 				sqre.interaction_position_offset = 75
// 			}

// 			start_dialogue(sqr, .EggShell)
// 		}
// 	}

// 	#partial switch item {
// 		case .Egg:
// 			player_say("I added egg")
// 			set_progress(.BatterHasEgg)
// 			check_ingredients()
// 			remove_inventory_item(.Egg)

// 		case .Flour:
// 			player_say("I added flour!")
// 			set_progress(.BatterHasFlour)
// 			check_ingredients()
// 			remove_inventory_item(.Flour)

// 		case .Butter:
// 			player_say("I added butter")
// 			set_progress(.BatterHasButter)
// 			check_ingredients()
// 			remove_inventory_item(.Butter)

// 		case .BaseballBat:
// 			player_say("The bat in batter has nothing to do with bat")

// 		case:
// 			uih_default(e, item)
// 	}

// }

// uih_pontus_planet :: proc(e: ^Entity, item: PickupType) {
// 	if item == .BaseballBat {
// 		baseball_slap()
// 		send_delayed_event(EventStartAnimating { entity = e.handle, renderable = 0 }, 1)

// 		pp := create_entity_from_entity_kind(.PontusPortrait)

// 		pp.layer = e.layer - 1
// 		pp.pos = e.pos + {0, -4}

// 		add_entity(world, pp)

// 		g_mem.disable_interaction_until = g_mem.time + 3
// 		e.interactable = false
// 		return
// 	}

// 	uih_default(e, item)
// }

// uih_globe :: proc(e: ^Entity, item: PickupType) {
// 	if item == .BaseballBat {
// 		player_say("I may be a cat, but that would be a slightly too chaotic move")
// 		return
// 	}

// 	uih_default(e, item)
// }

// uih_squirrel :: proc(e: ^Entity, item: PickupType) {
// 	if item == .Butter {
// 		player_say("He'll be happy to know I found butter!")
// 		return
// 	} else if item == .Flour {
// 		player_say("I should tell him I got the flour. But maybe not how I got it")
// 		return
// 	}

// 	uih_default(e, item)
// }

// UseItemHandlerName :: enum {
// 	None,
// 	FlourTree,
// 	RockWall,
// 	RootCellarDoor,
// 	Soil,
// 	AngryDoorClosed,
// 	AngryDoorOpened,
// 	OnionSeedInSoil,
// 	FrontDoor,
// 	Hatch,
// 	BatterBowl,
// 	TutorialOpening,
// 	HiddenOpening,
// 	NarrowOpening,
// 	SmallEggShell,
// 	Easel,
// 	PontusPlanet,
// 	Globe,
// 	Squirrel,
// }

// use_item_handlers := [UseItemHandlerName]UseItemHandlerProc {
// 	.None = nil,
// 	.FlourTree = uih_flour_tree,
// 	.RockWall = uih_rock_wall,
// 	.RootCellarDoor = uih_root_cellar_door,
// 	.Soil = uih_soil,
// 	.AngryDoorClosed = uih_angry_door_closed,
// 	.AngryDoorOpened = uih_angry_door_opened,
// 	.OnionSeedInSoil = uih_onion_seed_in_soil,
// 	.FrontDoor = uih_front_door,
// 	.Hatch = uih_hatch,
// 	.BatterBowl = uih_batter_bowl,
// 	.TutorialOpening = uih_tutorial_opening,
// 	.HiddenOpening = uih_hidden_opening,
// 	.NarrowOpening = uih_butter_return_exit,
// 	.SmallEggShell = uih_small_egg_shell,
// 	.Easel = uih_easel,
// 	.PontusPlanet = uih_pontus_planet,
// 	.Globe = uih_globe,
// 	.Squirrel = uih_squirrel,
// }

// animated_renderable :: proc(texture: TextureName, frame_length: f32,
// 	is_animating: bool = true, flip_x: bool = false, one_shot: bool = false,
// 	relative_layer: int = 0, offset: Vec2 = {}, interaction_wait_for_anim: bool = false,
// 	animate_when_interacted_with: bool = false) -> EntityRenderable {
// 	th := get_texture_handle(texture)
// 	tex := get_texture(th)
// 	nf := animation_num_frames(texture)

// 	r := Rect {
// 		x = 0,
// 		y = 0,
// 		width = f32(tex.width)/f32(nf),
// 		height = f32(tex.height),
// 	}

// 	return {
// 		type = .Animation,
// 		texture = th,
// 		texture_name = texture,
// 		frame_length = frame_length,
// 		is_animating = is_animating,
// 		num_frames = nf,
// 		rect = r,
// 		one_shot = one_shot,
// 		relative_layer = relative_layer,
// 		offset = offset,
// 		animate_when_interacted_with = animate_when_interacted_with,
// 		interaction_wait_for_anim = interaction_wait_for_anim,
// 	}
// }

// EntityRenderableType :: enum {
// 	Texture,
// 	Animation,
// 	Letter,
// }

// play_animation_frame_sound :: proc(anim: TextureName, f: int) {
// 	#partial switch anim {
// 		case .CatCloud:
// 			if f == 1 {
// 				play_sound_alias(.IntroEars)
// 			}

// 			if f == 2 {
// 				play_sound_alias(.IntroEyes)
// 			}

// 		case .CatBaseball:
// 			if f == 12 {
// 				play_sound_range(.CatSmack0, .CatSmack0)
// 			}

// 		case .CatBaseballUp:
// 			if f == 10 {
// 				play_sound_range(.CatSmack0, .CatSmack0)
// 			}


// 		case .FlourTreeFoliage:
// 			if f == 21 {
// 				play_sound_alias(.TreeCollapse)
// 			}


// 		case .CatButterCharge:
// 			if f == 6 {
// 				play_sound_alias(.CatButterdash0)
// 			}

// 		case .CatWater:
// 			if f == 8 {
// 				play_sound_alias(.CatWaterbucket)
// 			}

// 			if f == 25 {
// 				play_sound_alias(.CatLanding2)
// 			}

// 		case .CatThrowFlour:
// 			if f == 7 {
// 				play_sound_alias(.ThrowFlour)
// 			}

// 		case .RocketCatLeave:
// 			if f == 4 {
// 				play_sound_range(.Step0, .Step4)
// 			}
// 			if f == 7 {
// 				play_sound_alias(.CatLanding0)
// 			}

// 		case .SpaceOnionGrow:
// 			if f == 2 {
// 				play_sound_alias(.RocketGrow)
// 			}

// 		case .RocketCatJumpIn:
// 			if f == 4 {
// 				play_sound_alias(.Step2)
// 			}
// 	}
// }

// EntityRenderable :: struct {
// 	type: EntityRenderableType,

// 	texture: TextureHandle,
// 	texture_name: TextureName,
// 	rect: Rect,
// 	offset: Vec2,
// 	rot: f32,
// 	relative_layer: int,
// 	color: rl.Color,
// 	apply_color: bool,

// 	// Animation stuff
// 	animate_when_interacted_with: bool,
// 	interaction_wait_for_anim: bool,
// 	is_animating: bool,
// 	one_shot: bool,
// 	num_frames: int,
// 	cur_frame: int,
// 	num_loops: int,
// 	frame_length: f32,
// 	frame_timer: f32,

// 	// Letter stuff
// 	letter_size: f32,
// 	letter: u8,
// }

// entity_kind_display_name :: proc(e: EntityKind) -> string {
// 	#partial switch e {
// 		case .Globe:
// 			return "everyone I've ever known"

// 		case .AngryDoor:
// 			return "living room door"
// 	}

// 	return ""
// }

// EntityKind :: enum {
// 	Legacy,
// 	RockWall,
// 	Butter,
// 	RootCellarDoor,
// 	FlourTree,
// 	Stone,
// 	Waterfall,
// 	BaseballBat,
// 	Bird,
// 	OnionSeed,
// 	Soil,
// 	Rocket,
// 	AngryDoor,
// 	Egg,
// 	FrontDoor,
// 	Cat,
// 	Squirrel,
// 	Acorn,
// 	AcornAnimator,
// 	Hatch,
// 	BatterBowl,
// 	DrawBindingLeft,
// 	Unused,
// 	DrawBindingJump,
// 	DrawBindingJumpHold,
// 	Opening,
// 	HiddenOpening,
// 	NarrowOpening,
// 	KluckePortrait,
// 	DrawBindingUse,
// 	DrawBindingRight,
// 	LakritsPortrait,
// 	LillemorPortrait,
// 	SmallEggShell,
// 	Easel,
// 	PontusPortrait,
// 	PontusPlanet,
// 	CatCloud,
// 	PancakeStack,
// 	Globe,
// 	CaveFace,
// 	UseAbilityTutorial,
// }

// create_entity_from_entity_kind :: proc(k: EntityKind) -> Entity {
// 	create :: proc(k: EntityKind) -> Entity {
// 		switch k {
// 			case .Legacy:
// 				return {}

// 			// --- Player ---

// 			case .Cat:
// 				return {
// 					flip_with_facing = true,
// 					variant = PlayerCat{},
// 					interactable_icon_offset = {1, -14},
// 				}

// 			// --- NPCs ---

// 			case .Squirrel:
// 				return {
// 					dialogue_name = .Squirrel,
// 					num_renderables = 1,
// 					renderables = {
// 						0 = { texture = get_texture_handle(.SquirrelIdle) },
// 					},
// 					interactable = true,
// 					interactable_dir_from_facing = true,
// 					flip_with_facing = true,
// 					interactable_icon_offset = {0, -15},
// 					interaction_position_offset = 20,
// 					examine_text = "It's my friend the Squirrel. He's afraid of everything!",
// 					use_item_handler = .Squirrel,
// 				}

// 			case .FlourTree:
// 				return {
// 					dialogue_name = .FlourTree,
// 					num_renderables = 3,
// 					renderables = {
// 						0 = animated_renderable(.FlourTreeFace, 0.2, false, false, false, relative_layer = 1, offset = {1, 23}, animate_when_interacted_with = true),
// 						1 = animated_renderable(.FlourTree, 0.075, false, false, true),
// 						2 = animated_renderable(.FlourTreeFoliage, 0.075, false, false, true, 10),
// 					},
// 					interactable = true,
// 					interactable_offset = {0, 40},
// 					interactable_icon_offset = {3, -30},
// 					interactable_dir_from_facing = true,
// 					use_item_handler = .FlourTree,
// 					interaction_position_offset = 20,
// 					examine_text = "It's a very grumpy tree that has Flour instead of leaves",
// 				}

// 			case .Stone:
// 				return {
// 					dialogue_name = .Stone,
// 					num_renderables = 2,
// 					renderables = {
// 						0 = animated_renderable(.NpcStoneFace, 0.3, false, false, false, relative_layer = 1, offset = {-8, 2}, animate_when_interacted_with = true),
// 						1 = { texture = get_texture_handle(.NpcStone) },
// 					},
// 					interactable = true,
// 					interactable_offset = {-8, -2},
// 					interactable_icon_offset = {4, -12},
// 					examine_text = "This stone has lead a rocky life",
// 					interaction_position_offset = 40,
// 				}

// 			case .Waterfall:
// 				return {
// 					dialogue_name = .Waterfall,
// 					num_renderables = 2,
// 					renderables = {
// 						0 = animated_renderable(.WaterfallFace, 0.2, is_animating = false, offset = {4, -37}, animate_when_interacted_with = true),
// 						1 = animated_renderable(.Waterfall, 0.1, relative_layer = -2),
// 					},
// 					interactable = true,
// 					interactable_offset = {-4, -45},
// 					interactable_icon_offset = {-2, -8},
// 					examine_text = "It's Sheriff Slipshy Splashy!",
// 					interaction_position_offset = 25,
// 					facing = .West,
// 				}

// 			case .Bird:
// 				return {
// 					dialogue_name = .Bird,
// 					num_renderables = 1,
// 					renderables = {
// 						0 = { texture = get_texture_handle(.Bird) },
// 					},
// 					interactable = true,
// 					interactable_offset = {-3, 7},
// 					interactable_icon_offset = {8, -19},
// 					interaction_position_offset = 60,
// 					examine_text = "It's the bird that lives up here!",
// 				}

// 			case .Rocket:
// 				return {
// 					dialogue_name = .Rocket,
// 					num_renderables = 1,
// 					renderables = {
// 						0 = animated_renderable(.SpaceOnionGrow, 0.1, is_animating = false, animate_when_interacted_with = true, one_shot = true, interaction_wait_for_anim = true),
// 					},
// 					interactable = true,
// 					variant = Rocket{},
// 					interactable_offset = {0, 10},
// 					interactable_icon_offset = {-8, -25},
// 					interactable_dir_from_facing = true,
// 					flip_with_facing = false,
// 					facing = .West,
// 					interaction_position_offset = 25,
// 					examine_text = "The Rocket is also an onion. Will I cry if I ride inside?",
// 				}

// 			case .AngryDoor:
// 				return {
// 					num_renderables = 2,
// 					renderables = {
// 						1 = animated_renderable(.InsideDoor, 0.2, is_animating = false, one_shot = true),
// 					},
// 					collider = rect_from_pos_size({-18.5, -40}, {4, 80}),
// 					interactable = true,
// 					interactable_offset = {18, 30},
// 					interactable_icon_offset = {2, -11},
// 					interactable_from_behind = true,
// 					interactable_dir_from_facing = true,
// 					facing = .West,
// 					flip_with_facing = false,
// 					interaction_position_offset = 20,
// 					interactable_distance = 20,
// 					use_item_handler = .AngryDoorClosed,
// 					examine_text = "It's a door",
// 				}

// 			case .Acorn:
// 				return {
// 					dialogue_name = .Acorn,
// 					num_renderables = 3,
// 					renderables = {
// 						0 = animated_renderable(.AcornFace, 0.175, is_animating = false, offset = {0,7}, animate_when_interacted_with = true, relative_layer = 1),
// 						1 = { texture = get_texture_handle(.Acorn) },
// 						2 = { texture = get_texture_handle(.AcornHat), relative_layer = 1 },
// 					},
// 					interactable = true,
// 					interactable_dir_from_facing = true,
// 					interactable_offset = {4, 30},
// 					interactable_icon_offset = {4, -43},
// 					interactable_distance = 30,
// 					examine_text = "Hoo boy, it's an acorn!",
// 				}

// 			case .CaveFace:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = animated_renderable(.CaveFaceTalk, 0.2, is_animating = false, animate_when_interacted_with = true),
// 					},
// 					collider = rect_from_pos_size({-2.5*16*0.5, -4*16*0.5}, {2.5*16, 4*16}),
// 					examine_text = "It's the mouth of the cave! I should try talking to it",
// 					interactable = true,
// 					interactable_offset = {-22, 24},
// 					interactable_icon_offset = {13, -37},
// 					dialogue_name = .CaveFace,
// 				}

// 			// --- Pickups ---

// 			case .Butter:
// 				th := get_texture_handle(.Butter)

// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = { texture = th },
// 					},
// 					pickup = .Butter,
// 					interactable_icon_offset = {0, -10},
// 					interactable = true,
// 				}

// 			case .BaseballBat:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = { texture = get_texture_handle(.Mallet) },
// 					},
// 					interactable = true,
// 					pickup = .BaseballBat,
// 					interactable_icon_offset = {0, -15},
// 				}

// 			case .OnionSeed:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = { texture = get_texture_handle(.OnionSeed) },
// 					},
// 					interactable = true,
// 					pickup = .OnionSeed,
// 					interactable_icon_offset = {1, -13},
// 				}

// 			case .Egg:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = { texture = get_texture_handle(.Egg) },
// 					},
// 					interactable = true,
// 					interactable_offset = {0, -5},
// 					interactable_icon_offset = {0, -7},
// 					pickup = .Egg,
// 				}

// 			// --- Other ---

// 			case .AcornAnimator:
// 				return {
// 					variant = AcornAnimator{},
// 				}

// 			case .Globe:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = { texture = get_texture_handle(.Globe) },
// 					},
// 					interactable = true,
// 					interactable_offset = {0, 10},
// 					interactable_icon_offset = {10, -27},
// 					examine_text = "That's where I came from! That's home! Better be careful so I don't smack it off the table... Hnnnng",
// 					use_item_handler = .Globe,
// 				}

// 			case .RockWall:
// 				th := get_texture_handle(.RockWall)
// 				t := get_texture(th)
// 				s := texture_size(t)

// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = { texture = th },
// 					},
// 					examine_text = "It's a big slippery rock wall. Looks too tall to climb! I need something powdery to get a better grip!",
// 					collider = rect_from_pos_size(-s*0.5, s),
// 					interactable = true,
// 					interactable_offset = {-5, 26},
// 					interactable_icon_offset = {1, -12},
// 					use_item_handler = .RockWall,
// 				}

// 			case .RootCellarDoor:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = animated_renderable(.RootCellarDoorAnim, 0.2, false, false, true),
// 					},
// 					interactable = true,
// 					interactable_offset = {7, 0},
// 					interactable_icon_offset = {1, -16},
// 					interactable_distance = 20,
// 					examine_text = "I think this is Squirrel's root cellar",
// 					use_item_handler = .RootCellarDoor,
// 				}

// 			case .Hatch:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = animated_renderable(.Hatch, 0.250, false, false, true),
// 					},
// 					collider = rect_from_pos_size({-16, 10}, {32, 6}),
// 					interactable = true,
// 					interactable_offset = {0, 16},
// 					interactable_icon_offset = {0, -8},
// 					interactable_distance = 20,
// 					interactable_from_behind = true,
// 					use_item_handler = .Hatch,
// 					examine_text = "A hatch! Can probably be convinced to open by Mr Baseball",
// 				}

// 			case .Soil:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = { texture = get_texture_handle(.Soil) },
// 					},
// 					interactable = true,
// 					examine_text = "It's the soil where Squirrel wants me to plant the onion seed",
// 					interactable_offset = {0, -7},
// 					interactable_icon_offset = {0, -12},
// 					use_item_handler = .Soil,
// 				}

// 			case .FrontDoor:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = { texture = get_texture_handle(.FrontDoor), },
// 					},
// 					collider = rect_from_pos_size({-2, -40}, {4, 80}),
// 					interactable = true,
// 					interactable_offset = {-4, 30},
// 					interactable_icon_offset = {0, -8},
// 					use_item_handler = .FrontDoor,
// 					interactable_distance = 18,
// 					examine_text = "It's the door to the outside world!",
// 				}

// 			case .BatterBowl:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = { texture = get_texture_handle(.BatterBowl) },
// 					},
// 					interactable = true,
// 					use_item_handler = .BatterBowl,
// 					interactable_icon_offset = {0, -18},
// 					examine_text = "It's the bowl for pancake batter, just gotta add the ingredients!",
// 				}

// 			case .Opening:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = { texture = get_texture_handle(.Opening) },
// 					},
// 					interactable = true,
// 					interactable_offset = {-20, 10},
// 					interactable_icon_offset = {0, -11},
// 					collider = rect_from_pos_size({-24, -16}, {48, 32}),
// 					examine_text = "It's a narrow crack in the wall! I can only fit through if I'm like a buttered piece of cat loaf!",
// 					use_item_handler = .TutorialOpening,
// 				}

// 			case .HiddenOpening:
// 				return {
// 					num_renderables = 2,
// 					renderables = {
// 						0 = { texture = get_texture_handle(.OpeningHidden) },
// 						1 = { texture = get_texture_handle(.OpeningHiddenCover), relative_layer = 30, offset = {32, 0}},
// 					},
// 					interactable = true,
// 					interactable_offset = {-20, 2},
// 					interactable_icon_offset = {4, -12},
// 					collider = rect_from_pos_size({-24, -16}, {48, 32}),
// 					examine_text = "Some kind of mysterious hole in the wall! I'd get stuck if I tried to squeeze through",
// 					use_item_handler = .HiddenOpening,
// 				}

// 			case .NarrowOpening:
// 				return {
// 					interactable = true,
// 					examine_text = "It's a very narrow opening! It looks hard to fit through",
// 					use_item_handler = .NarrowOpening,
// 				}

// 			case .KluckePortrait:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = { texture = get_texture_handle(.KluckePortrait) },
// 					},
// 					pickup = .KluckePortrait,
// 					interactable = true,
// 					interactable_icon_offset = {0, -13},
// 				}

// 			case .LakritsPortrait:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = { texture = get_texture_handle(.LakritsPortrait) },
// 					},
// 					pickup = .LakritsPortrait,
// 					interactable = true,
// 					interactable_icon_offset = {0, -23},
// 					interactable_offset = {0, 10},
// 				}

// 			case .LillemorPortrait:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = { texture = get_texture_handle(.LillemorPortrait) },
// 					},
// 					pickup = .LillemorPortrait,
// 					interactable = true,
// 					interactable_icon_offset = {0, -23},
// 					interactable_offset = {0, 10},
// 				}

// 			case .SmallEggShell:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = animated_renderable(.EggShell, 0.15, is_animating = false, one_shot = true),
// 					},
// 					interactable = true,
// 					use_item_handler = .SmallEggShell,
// 					examine_text = "It's the piece of egg shell I accidentally dropped in here! I MUST DESTROY IT",
// 				}

// 			case .Easel:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = { texture = get_texture_handle(.Easel) },
// 					},
// 					interactable = true,
// 					examine_text = "It's an easel for holding a portrait",
// 					interactable_icon_offset = {0, -4},
// 					use_item_handler = .Easel,
// 				}

// 			case .PontusPortrait:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = { texture = get_texture_handle(.PontusPortrait) },
// 					},
// 					pickup = .PontusPortrait,
// 					interactable = true,
// 					interactable_icon_offset = {0, -23},
// 					interactable_offset = {0, 10},
// 				}

// 			case .PontusPlanet:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = animated_renderable(.PontusPlanet, 0.1, is_animating = false, one_shot = true),
// 					},
// 					interactable = true,
// 					interactable_icon_offset = {0, -37},
// 					examine_text = "Ooo! It's a big round planet-y thing. It's ready to crack!",
// 					interactable_distance = 40,
// 					use_item_handler = .PontusPlanet,
// 				}

// 			case .CatCloud:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = animated_renderable(.CatCloud, 3, is_animating = false, one_shot = true),
// 					},

// 					interactable_icon_offset = {37, -20},
// 				}

// 			case .PancakeStack:
// 				return {
// 					num_renderables = 1,
// 					renderables = {
// 						0 = animated_renderable(.Pancake, 0.1, is_animating = false, one_shot = true),
// 					},
// 				}

// 			case .Unused, .DrawBindingLeft, .DrawBindingJump, .DrawBindingJumpHold, .DrawBindingUse, .DrawBindingRight, .UseAbilityTutorial: {}
// 		}

// 		return {}
// 	}

// 	e := create(k)
// 	e.kind = k
// 	return e
// }

// MaxRenderables :: 4

// Entity :: struct {
// 	handle: EntityHandle,
// 	id: UID,
// 	hidden: bool,
// 	using pos: Vec2,
// 	render_pos: Maybe(Vec2),
// 	rot: f32,
// 	layer: int,
// 	scale: f32,
// 	parallax: f32,
// 	parallax_y_lock: bool,
// 	type: EntityTypeHandle,
// 	tag: Tag,
// 	enabled_at: f64,
// 	disabled: bool,
// 	interactable: bool,
// 	interactable_from_behind: bool,
// 	interactable_dir_from_facing: bool,
// 	interactable_offset: Vec2,
// 	interactable_icon_offset: Vec2,
// 	interactable_distance: f32,
// 	dialogue_name: DialogueName,
// 	examine_text: string,
// 	renderables: [MaxRenderables]EntityRenderable,
// 	num_renderables: int,
// 	variant: EntityVariant,
// 	kind: EntityKind,
// 	collider: Rect,
// 	flip_x: bool,
// 	flip_with_facing: bool,
// 	interaction_position_offset: f32,
// 	pickup: PickupType,
// 	facing: Facing,
// 	use_item_handler: UseItemHandlerName,
// }

UID :: distinct u128

// new_uid :: proc() -> UID {
// 	return UID(rand.uint128())
// }

// string_to_uid :: proc(s: string) -> UID {
// 	return UID(transmute(u128)([2]u64 { u64(hash(s)), u64(hash("from_string")) }))
// }

// EntityTypeHandle :: distinct Handle

// EntityTypeHandleNone :: EntityTypeHandle {}

// EntityTypeStaticObject :: struct {
// 	collider: rl.Rectangle,
// 	texture: TextureHandle,
// 	pushable: bool,
// }

// EntityTypeAnimatedObject :: struct {
// 	collider: rl.Rectangle,
// 	texture: TextureHandle,
// 	num_frames: int,
// 	frame_time: f32,
// 	start_paused: bool,
// }

// EntityTypeBuiltinVariant :: enum {
// 	None,
// 	UCat,
// 	URocket,
// 	UWaterfallFace,
// 	USquirrel,
// 	UOnionSeed,
// 	UWaterbucket,
// 	Trigger,
// 	Interactable,
// 	Spline,
// 	UOnionBox,
// 	UStoneFace,
// 	UBird,
// 	UEgg,
// 	UKey,
// 	UDoorFace,
// 	Collider,
// 	UFlourTree,
// 	UMallet,
// }

// EntityTypeBuiltin :: struct {
// 	variant: EntityTypeBuiltinVariant,
// }

// EntityTypeVariant :: union {
// 	EntityTypeStaticObject,
// 	EntityTypeAnimatedObject,
// 	EntityTypeBuiltin,
// }

// EntityTypeArray :: HandleArray(EntityType, EntityTypeHandle)

// EntityType :: struct {
// 	handle: EntityTypeHandle,
// 	id: UID,
// 	variant: EntityTypeVariant,
// }

// get_named_spline :: proc(name: string) -> (EntityInst(Spline), bool)  {
// 	if e, ok := world.named_splines[name]; ok {
// 		if spline_entity, ok := get_entity(e, Spline); ok {
// 			return spline_entity, true
// 		}
// 	}

// 	return {}, false
// }

// checker_tex :: proc() -> TextureHandle {
// 	return g_mem.editor_memory.checker_texture
// }

// RenderText :: struct {
// 	text: string,
// 	pos: Vec2,
// 	size: f32,
// 	color: rl.Color,
// 	time_on_line: f32,
// }

// get_to_render :: proc() -> []Renderable {
// 	return g_mem.to_render[:]
// }

// draw_rectangle_lines :: proc(r: Rect, c: rl.Color, layer: int) {
// 	append(&g_mem.to_render, Renderable {
// 		variant = RenderableRectLines {
// 			rect = r,
// 			color = c,
// 		},
// 		layer = layer,
// 	})
// }

// draw_rectangle :: proc(r: Rect, c: rl.Color, layer: int) {
// 	append(&g_mem.to_render, Renderable {
// 		variant = RenderableRect {
// 			rect = r,
// 			color = c,
// 		},
// 		layer = layer,
// 	})
// }

dpi_scale :: proc() -> f32 {
	when CAT_DEV {
		return rl.GetWindowScaleDPI().x
	} else {
		return 1
	}
}

// CameraFollowPlayerSide :: enum {
// 	None, Left, Right,
// }

// CameraFollowPlayer :: struct {
// 	camera_offset: f32,
// 	camera_offset_lerp_start: f32,
// 	camera_offset_lerp_end: f32,
// 	camera_lerp_t: f32,
// 	player_start_pos: Vec2,
// 	player_start_pos_set: bool,
// 	player_side: CameraFollowPlayerSide,
// 	y_target: f32,
// 	y_start: f32,
// 	y_lerp_t: f32,
// }

// CameraInVolume :: struct {
// 	volume: EntityHandle,
// 	start: Vec2,
// 	start_zoom: f32,
// 	lerp_t: f32,
// 	fit: bool,
// }

// CameraLocked :: struct {}

// CameraMode :: union #no_nil {
// 	CameraFollowPlayer,
// 	CameraInVolume,
// 	CameraLocked,
// }

// CameraState :: struct {
// 	pause_camera_until: f64,
// 	pos: Vec2,
// 	zoom: f32,
// 	target_zoom: f32,
// 	shake_until: f64,
// 	shake_amp: f32,
// 	shake_freq: f32,
// 	wanted_y: f32,
// 	mode: CameraMode,
// }

// InventoryItem :: struct {
// 	item: PickupType,
// 	added_at: f64,
// 	has_original_screen_pos: bool,
// 	original_screen_pos: Vec2,
// }

// Inventory :: struct {
// 	items: [dynamic]InventoryItem,
// }

// GameStateDefault :: struct {}

// SpaceGameLetter :: struct {
// 	e: EntityHandle,
// 	letter: u8,
// 	rot_speed: f32,
// }

// SpaceGameStatus :: enum {
// 	Collecting,
// 	CollectingDoneDoTextAnimation,
// 	DoneFlyingAway,
// }

// SpaceGameBg :: struct {
// 	texture: TextureHandle,
// 	pos: f32,
// }

// GameStateSpaceGame :: struct {
// 	rocket: EntityHandle,
// 	needed: []byte,
// 	current: []byte,
// 	spawn_timer: f32,
// 	letters: [dynamic]SpaceGameLetter,
// 	vel: f32,
// 	status: SpaceGameStatus,
// 	status_time: f32,
// 	end_event: Event,
// 	bottom_text_offset: Vec2,
// 	bottom_text_size: f32,
// 	fly_away_start_pos: Vec2,
// 	said_intro_line: bool,
// 	available_bgs: []TextureHandle,
// 	spawned_bgs: [dynamic]SpaceGameBg,
// 	letter_color_normal: rl.Color,
// 	letter_color_need: rl.Color,

// 	last_needed_spawned_at: f64,
// }


// EndBg :: struct {
// 	texture: TextureHandle,
// 	pos: f32,
// }

// GameStateEnteringPancakeBatterLand :: struct {
// 	cat: EntityHandle,
// 	state_time: f32,
// 	credits_timer: f32,
// 	credits_idx: int,
// }

// entity_pos :: proc(eh: EntityHandle) -> Vec2 {
// 	if e := get_entity_raw(eh); e != nil {
// 		return e.pos
// 	}

// 	return {}
// }

// entering_pbl_start :: proc(cat: EntityHandle) {
// 	gs := GameStateEnteringPancakeBatterLand {
// 		cat = cat,
// 	}

// 	if cat, ok := get_entity(cat, PlayerCat); ok {
// 		cat.rot = -20
// 	}

// 	set_game_state(gs)
// 	g_mem.camera_state.pos = {}
// }

// CreditsTimer :: 3

// entering_pbl_update :: proc(gs: ^GameStateEnteringPancakeBatterLand) {
// 	gs.state_time += dt
// 	cat, cat_ok := get_entity(gs.cat, PlayerCat)

// 	if !cat_ok {
// 		return
// 	}

// 	if !get_progress(.HideTutorialStuff) {
// 		set_progress(.HideTutorialStuff)
// 	}

// 	cat.render_pos = {}
// 	tt := remap(gs.state_time, 0.5, 1.5, 0, 1)
// 	start_pos := Vec2{-200, -200}
// 	end_pos := Vec2{-100, 104}
// 	cat.pos = math.lerp(start_pos, end_pos, smooth_stop2(tt))
// 	g_mem.camera_state.pos = math.lerp(start_pos, end_pos + Vec2{50, -30}, smooth_stop2(tt))
// 	g_mem.camera_state.wanted_y = g_mem.camera_state.pos.y
// 	cat.rot = math.lerp(f32(-20), 0, smooth_stop2(tt))

// 	if tt >= 1 {
// 		gs.state_time = 0
// 		gs.credits_timer = CreditsTimer
// 		cat.pos = end_pos
// 		cat.rot = 0
// 		g_mem.controlled_entity = g_mem.cat
// 		set_game_state(GameStateDefault{})
// 		set_state(cat, PlayerStateNormal{})
// 		return
// 	}
// }

// RootStatePlaying :: struct {

// }

// RootState :: union {
// 	RootStateMainMenu,
// 	RootStateIngameMenu,
// 	RootStatePlaying,
// }

// GameStateEnd :: struct {
// 	status: EndStateStatus,
// 	cat_start_pos: Vec2,
// 	cat: EntityHandle,
// 	credits_timer: f32,
// 	credits_idx: int,
// 	timer: f32,
// 	cats: [5]EntityHandle,
// 	num_cats: int,
// 	random_cats: [5]int,
// 	random_cats_idx: int,
// 	random_cat_timer: f32,
// 	logo: EntityHandle,
// 	logo_start_pos: Vec2,
// 	squirrel_timer: f32,
// 	squirrel_going_left: bool,
// 	pancake_lerp_start: Vec2,
// 	squirrel_flew_away: bool,
// 	squirrel_passes_since_credits_done: int,
// 	squirrel_growing: bool,

// 	thankscakes_timer: f32,
// 	thankscakes_spawned: bool,

// 	sqr_rocket: EntityHandle,
// 	sqr_rocket_spline_evaluator: EntityHandle,
// 	pancakes: EntityHandle,
// }

// GameStateIntro :: struct {
// 	time: f32,
// 	cloud: EntityHandle,
// 	squirrel: EntityHandle,
// 	squirrel_moving: bool,
// 	music_started: bool,
// }

// GameStateIntroTransition :: struct {
// 	time: f32,
// 	wanted_camera_pos: Vec2,
// }

// GameState :: union #no_nil {
// 	GameStateDefault,
// 	GameStateSpaceGame,
// 	GameStateEnteringPancakeBatterLand,
// 	GameStateEnd,
// 	GameStateIntro,
// 	GameStateIntroTransition,
// }

Animation_Name :: enum {
	Idle,
	Run,
}

Animation :: struct {
	texture:       rl.Texture2D,
	num_frames:    int,
	frame_timer:   f32,
	current_frame: int,
	frame_length:  f32,
	name:          Animation_Name,
}

update_animation :: proc(a: ^Animation) {
	a.frame_timer += rl.GetFrameTime()

	if a.frame_timer > a.frame_length {
		a.current_frame += 1
		a.frame_timer = 0

		if a.current_frame == a.num_frames {
			a.current_frame = 0
		}
	}
}

draw_animation :: proc(a: Animation, pos: rl.Vector2, flip: bool) {
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
	cat:                                EntityHandle,
	rocket:                             EntityHandle,
	next_controlled_entity:             EntityHandle,
	controlled_entity:                  EntityHandle,

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

// show_dialogue_tutorial :: proc() -> bool {
// 	return world.diag_tutorial_choice_counter > 0 || world.diag_tutorial_advance_counter > 0
// }

// delete_interaction :: proc(i: Interaction) {
// 	switch v in i {
// 		case InteractionDialogue:
// 			delete(v.single_line)
// 	}
// }

// clear_interactions :: proc() {
// 	for ai in g_mem.active_interactions {
// 		delete_interaction(ai)
// 	}

// 	clear(&g_mem.active_interactions)
// }

// add_interaction :: proc(i: Interaction) {
// 	append(&g_mem.active_interactions, i)
// }

// say_single_line :: proc(entity: EntityHandle, line: string, manual_end: bool = false, flip_bubble: bool = false, no_sound: bool = false, end_event: Event = nil) {
// 	id := InteractionDialogue {
// 		entity = entity,
// 		auto_advance = true,
// 		single_line = strings.clone(line),
// 		manual_end = manual_end,
// 		flip_bubble = flip_bubble,
// 		no_sound = no_sound,
// 		end_event = end_event,
// 	}

// 	add_interaction(id)
// }

// start_dialogue :: proc(entity: EntityHandle, dialogue: DialogueName, auto_advance: bool = false) {
// 	if dialogue == .None {
// 		return
// 	}

// 	id := InteractionDialogue {
// 		entity = entity,
// 		dialogue = dialogue,
// 		auto_advance = auto_advance,
// 	}

// 	d := world.dialogue_trees[dialogue]

// 	start_node_found := false
// 	for &n, n_idx in d.nodes {
// 		#partial switch &v in n.variant {
// 			case DialogueNodeVariantStart:
// 				id.current_node = n_idx
// 				start_node_found = true

// 			case DialogueNodeVariantNormal:
// 				v.cur_choice = 0
// 		}
// 	}

// 	if !start_node_found {
// 		log.error("Dialogue has no start node")
// 		return
// 	}

// 	add_interaction(id)

// 	if p, ok := get_entity(g_mem.controlled_entity, PlayerCat); ok {
// 		if !auto_advance {
// 			set_state(p, PlayerStateInteracting {})
// 		}

// 		p.vel.x = 0

// 		if target := get_entity_raw(entity); target != nil && entity != g_mem.controlled_entity {
// 			dir := target.pos - p.pos

// 			p.facing = dir.x > 0 ? .East : .West
// 		}
// 	}
// }

// resolve_entity_reference :: proc(w: ^World, eh: ^EntityHandle) {
// 	if entity_raw_valid(eh^) {
// 		return
// 	}

// 	if eh.id != 0 {
// 		eh^ = w.entity_lookup[EntityReference(eh.id)]
// 	}
// }

// InteractionDialogue :: struct {
// 	entity: EntityHandle,
// 	dialogue: DialogueName,
// 	current_node: int,
// 	current_node_do_choices: bool,
// 	auto_advance: bool,
// 	manual_end: bool,
// 	time_on_line: f32,
// 	single_line: string,
// 	flip_bubble: bool,
// 	done: bool,
// 	no_sound: bool,
// 	end_event: Event,
// }

// Interaction :: union {
// 	InteractionDialogue,
// }

// GrabPoint :: struct {
// 	pos: Vec2,
// 	compatible_facing: Facing,
// }

// Tile :: struct {
// 	// 0 means no tile
// 	tile_idx: int,
// 	x: int,
// 	y: int,
// 	layer: int,
// 	flip_x: bool,
// 	flip_y: bool,
// }

// Collider :: struct {
// 	rect: Rect,
// 	entity: EntityHandle,
// 	tile: int,
// 	one_direction: bool,
// }

// Cloud :: struct {
// 	entity: EntityHandle,
// 	vel: Vec2,
// }

// DialogueName :: enum {
// 	None,
// 	Squirrel,
// 	Waterfall,
// 	Stone,
// 	Bird,
// 	Door,
// 	Rocket,
// 	CatTryOpenDoor,
// 	OtherSquirrel,
// 	Acorn,
// 	FlourTree,
// 	EggShell,
// 	Klucke,
// 	Lakrits,
// 	Lillemor,
// 	Pontus,
// 	RocketSquirrel,
// 	CaveFace,
// }

// // A spawned, dynamic world
// World :: struct {
// 	colliders: [dynamic]Collider,
// 	grab_points: [dynamic]GrabPoint,

// 	triggers: [dynamic]EntityHandle,

// 	entities: HandleArray(Entity, EntityHandle),
// 	entity_lookup: map[EntityReference]EntityHandle,

// 	named_positions: map[string]Vec2,

// 	named_splines: map[string]EntityHandle,

// 	entity_types: HandleArray(EntityType, EntityTypeHandle),
// 	tiles: [dynamic]Tile,

// 	interactables: [dynamic]EntityHandle,

// 	add_entities: [dynamic]Entity,

// 	clouds: [dynamic]Cloud,
// 	clouds_start_x: f32,
// 	clouds_max_x: f32,

// 	dialogue_trees: [DialogueName]DialogueTree,

// 	fading_renderables: [dynamic]FadingRenderable,

// 	diag_tutorial_advance_counter: int,
// 	diag_tutorial_choice_counter: int,
// }


// // Music:
// // E A E^1oct
// // A A+5 A+7

// RocketState :: enum {
// 	Standby,
// 	Ignition,
// 	SlightRising,
// 	Blastoff,
// 	FlyingUp,
// 	LeavingPlanet,
// 	ExternallyControlled,
// 	ExternallyControlledCameraFollow,
// 	ExternallyControlledCameraFollowEaseIn,
// }

// RocketOneshotDoneEvent :: enum {
// 	None,
// 	CatJumpedOut,
// 	CatJumpedIn,
// }

// Rocket :: struct {
// 	prev_pos: Vec2,
// 	vel: Vec2,

// 	cat_inside: bool,
// 	time_in_state: f32,
// 	state: RocketState,
// 	cat_inside_time: f32,
// 	cat_inside_camera_start: Vec2,
// 	doing_jump_in_anim: bool,

// 	landing_progress: f32,
// 	oneshot_done_event: RocketOneshotDoneEvent,
// }

// PlayerStateDashing :: struct {
// }

// NormalStateAnim :: enum {
// 	Idle,
// 	Walk,
// }

// PlayerStateNormal :: struct {
// 	has_touched_ground: bool,
// 	anim: NormalStateAnim,
// }

// PlayerStateHang :: struct {
// 	grab_pos: Vec2,
// 	transition_played: bool,
// }

// PlayerStateHangClimb :: struct {
// 	start_pos: Vec2,
// 	velocity_offset: Vec2,
// 	sound_played: bool,
// }

// PlayerStateClimbing :: struct {
// 	wanted_x_offset: f32,
// 	sound: rl.Sound,
// }

// PlayerStateWallSlide :: struct {
// 	cant_climb: bool,
// 	wanted_x_offset: f32,
// 	transition_played: bool,
// 	sound: rl.Sound,
// }

// PlayerStateJumping :: struct {
// 	charge_done: bool,
// }

// PlayerStateInteracting :: struct {
// 	started_walk: bool,
// 	in_position: bool,
// }

// PlayerStateSlaping :: struct {

// }

// PlayerStateBaseballin :: struct {
// 	delay: f32,
// }

// PlayerStateFloating :: struct {

// }

// PlayerStateFloatingToEnd :: struct {
// 	squirrel: EntityHandle,
// 	line1_said: bool,
// 	line2_said: bool,
// 	line3_said: bool,
// 	line4_said: bool,
// 	removed_clouds: bool,
// 	squirrel_pos_x_start: f32,
// }

// PlayerStateFloatingToKitchen :: struct {
// 	squirrel: EntityHandle,
// 	lerp_start: Vec2,
// 	sqr_lerp_start: Vec2,
// 	lerp_started: bool,
// }

// PlayerStateEnterEnd :: struct {
// 	camera_start_pos: Vec2,
// 	start_zoom: f32,
// 	player_spline: EntityHandle,
// }

// PlayerStateButterCharge :: struct {
// 	start_offset: f32,
// }

// PlayerStateWallslideToNormal :: struct {

// }

// PlayerStateExternallyControlled :: struct {

// }

// PlayerStateOneShotAnim :: struct {
// 	anim: AnimatedSprite,
// 	delay: f32,

// 	end_event: Event,

// 	walk_to_target_x: bool,
// 	target_x: f32,
// 	manual_end_facing: Maybe(Facing),
// 	end_facing: Facing,

// 	started_walk: bool,
// 	walk_done: bool,
// }

// PlayerState :: union {
// 	PlayerStateNormal,
// 	PlayerStateDashing,
// 	PlayerStateHang,
// 	PlayerStateHangClimb,
// 	PlayerStateWallSlide,
// 	PlayerStateJumping,
// 	PlayerStateInteracting,
// 	PlayerStateClimbing,
// 	PlayerStateSlaping,
// 	PlayerStateBaseballin,
// 	PlayerStateFloating,
// 	PlayerStateFloatingToEnd,
// 	PlayerStateFloatingToKitchen,
// 	PlayerStateEnterEnd,
// 	PlayerStateButterCharge,
// 	PlayerStateWallslideToNormal,
// 	PlayerStateExternallyControlled,
// 	PlayerStateOneShotAnim,
// }

// AnimationInstance :: struct {
// 	using anim: AnimatedSprite,
// 	cur_frame: int,
// 	frame_timer: f32,
// 	started: bool,
// }

// AnimatedSprite :: struct {
// 	texture: TextureHandle,
// 	texture_name: TextureName,
// 	num_frames: int,
// 	frame_length: f32,
// 	offset: Vec2,
// }

// entity_inst :: proc(e: ^Entity, var: ^$T) -> EntityInst(T) {
// 	return EntityInst(T) { e, var }
// }

// EntityInst :: struct($T: typeid) {
// 	using entity: ^Entity,
// 	using var: ^T,
// }

// EntityCopy :: struct($T: typeid) {
// 	using entity: Entity,
// 	using var: T,
// }

// find_entity_of_kind :: proc(kind: EntityKind) -> EntityHandle {
// 	if kind == .Legacy  {
// 		return EntityHandleNone
// 	}

// 	ent_iter := ha_make_iter(g_mem.world.entities)
// 	for e, eh in ha_iter_ptr(&ent_iter) {
// 		if e.kind == kind {
// 			return eh
// 		}
// 	}

// 	return EntityHandleNone
// }

// find_entities_with_tag :: proc(tag: Tag) -> []EntityHandle {
// 	if tag == .None {
// 		return {}
// 	}

// 	res := make([dynamic]EntityHandle, context.temp_allocator)

// 	ent_iter := ha_make_iter(g_mem.world.entities)
// 	for e, eh in ha_iter_ptr(&ent_iter) {
// 		if e.tag == tag {
// 			append(&res, eh)
// 		}
// 	}

// 	return res[:]
// }

// find_entity_with_tag :: proc(tag: Tag) -> EntityHandle {
// 	if tag == .None {
// 		return EntityHandleNone
// 	}

// 	ent_iter := ha_make_iter(g_mem.world.entities)
// 	for e, eh in ha_iter_ptr(&ent_iter) {
// 		if e.tag == tag {
// 			return eh
// 		}
// 	}

// 	return EntityHandleNone
// }

// disable_entity :: proc(eh: EntityHandle) {
// 	e := get_entity_raw(eh)

// 	if e == nil {
// 		return
// 	}

// 	e.disabled = true
// 	remove_colliders_for_entity(world, eh)
// }

// enable_entity :: proc(w: ^World, eh: EntityHandle) {
// 	e := ha_get_ptr(w.entities, eh)

// 	if e == nil {
// 		log.error("Entity not part of world")
// 		return
// 	}

// 	if !rect_is_empty(e.collider) {
// 		c := e.collider
// 		c.x += e.x
// 		c.y += e.y
// 		c.x = linalg.ceil(c.x)
// 		c.y = linalg.ceil(c.y)
// 		append(&w.colliders, Collider { rect = c, entity = eh } )
// 	}

// 	#partial switch &v in e.variant {
// 		case PlayerCat:
// 			anim_idle := make_animated_sprite(.CatIdle, 1)
// 			v.anim_walk = make_animated_sprite(.Cat, 0.08)
// 			v.anim_idle = anim_idle
// 			v.anim_charging = make_animated_sprite(.CatButterCharge, 0.1, offset = Vec2{36, -8})
// 			v.anim_hang = make_animated_sprite(.CatHang, 0.1, offset = {0, -1})
// 			v.anim_wallslide = make_animated_sprite(.CatWallslide, 0.1)
// 			v.anim_hangclimb = make_animated_sprite(.CatHangclimb, 0.07)
// 			v.anim_jump = make_animated_sprite(.CatJump, 0.05)
// 			v.anim_jump_to_hang = make_animated_sprite(.CatJumpToHang, 0.04)
// 			v.anim_wall_climb = make_animated_sprite(.CatWallClimb, 0.055)
// 			v.anim_slap = make_animated_sprite(.CatSlap, 0.075)
// 			v.anim_baseball = make_animated_sprite(.CatBaseball, 0.075)
// 			v.anim_baseball_up = make_animated_sprite(.CatBaseballUp, 0.1, offset = {8, -8})
// 			v.anim_wallslide_to_stand = make_animated_sprite(.CatWallslideToStand, 0.04)
// 			v.anim_wakeup = make_animated_sprite(.CatWakeup, 0.2)
// 			v.anim_water = make_animated_sprite(.CatWater, 0.125, offset = {7, -8})
// 			v.anim_throw_flour = make_animated_sprite(.CatThrowFlour, 0.1, offset = {13, -24})
// 			v.anim_place_onion = make_animated_sprite(.CatPlaceOnion, 0.1, offset = {2, 0})
// 			v.anim_baseball.offset = {8, -8}
// 			v.state = PlayerStateNormal {}
// 			v.anim = {
// 				anim = anim_idle,
// 			}

// 			e.num_renderables = 1
// 			e.renderables[0] = {
// 				texture = v.anim.anim.texture,
// 				rect = animation_rect(&v.anim, e.facing == .West),
// 				offset = v.anim.offset,
// 			}

// 		case StaticObject:
// 			if et, ok := ha_get(w.entity_types, e.type); ok {
// 				if etv, ok := et.variant.(EntityTypeStaticObject); ok {
// 					e.num_renderables = 1
// 					e.renderables[0] = {
// 						texture = etv.texture,
// 					}
// 					e.collider = etv.collider
// 				}
// 			}

// 		case AnimatedObject:
// 			if et, ok := ha_get(w.entity_types, e.type); ok {
// 				if etv, ok := et.variant.(EntityTypeAnimatedObject); ok {
// 					v.anim.texture = etv.texture
// 					v.anim.num_frames = etv.num_frames
// 					v.anim.frame_length = etv.frame_time
// 					e.collider = etv.collider
// 					v.playing = etv.start_paused == false
// 				}
// 			}

// 		case Trigger:
// 		case Spline:
// 		case Usable:
// 		case StaticCollider:
// 		case SplineEvaluator:

// 		case AcornAnimator:
// 			g_mem.controlled_entity = EntityHandleNone
// 			v.start_pos = g_mem.camera_state.pos
// 			v.start_zoom = g_mem.camera_state.zoom
// 			v.rocket = g_mem.rocket
// 			v.cat = g_mem.cat
// 	}

// 	e.disabled = false

// 	if e.dialogue_name != .None {
// 		e.interactable = true
// 	}

// 	#partial switch &v in e.variant {
// 		case StaticObject:
// 			if !rect_is_empty(e.collider) {
// 				c := e.collider
// 				c.x += e.x
// 				c.y += e.y
// 				append(&w.colliders, Collider { rect = c, entity = eh } )

// 				p1 := pos_from_rect(c)
// 				p2 := pos_from_rect(c) + {c.width, 0}
// 			}

// 		case AnimatedObject:
// 			if !rect_is_empty(e.collider) {
// 				c := e.collider
// 				c.x += e.x
// 				c.y += e.y
// 				append(&w.colliders, Collider { rect = c, entity = eh } )
// 			}

// 		case PlayerCat:
// 			g_mem.cat = eh

// 		case Usable:
// 			if len(v.actions) > 0 && !v.not_interactable {
// 				append(&w.interactables, eh)
// 				e.interactable = true
// 			}

// 		case Rocket:
// 			g_mem.rocket = eh
// 			v.prev_pos = e.pos

// 		case Pickup:
// 			e.interactable = true

// 		case Spline:
// 			w.named_splines[v.name] = eh

// 		case Trigger:
// 			append(&w.triggers, eh)

// 		case StaticCollider:
// 			append(&w.colliders, Collider { rect = rect_add_pos(v.collider, e.pos), entity = eh, one_direction = v.one_direction })

// 		case SplineEvaluator:

// 	}

// 	e.enabled_at = g_mem.time
// }

// add_entity :: proc(w: ^World, e: Entity) -> EntityHandle {
// 	h := ha_add(&w.entities, e)

// 	if e.disabled == false {
// 		enable_entity(w, h)
// 	}

// 	return h
// }

// delete_entity :: proc(e: Entity) {
// 	#partial switch v in e.variant {
// 		case Usable:
// 			delete(v.actions)

// 		case Spline:
// 			delete(v.name)
// 			delete(v.points)
// 	}
// }

// remove_colliders_for_entity :: proc(world: ^World, h: EntityHandle) {
// 	if h == EntityHandleNone {
// 		return
// 	}

// 	for i := 0; i < len(world.colliders); {
// 		if world.colliders[i].entity == h {
// 			unordered_remove(&world.colliders, i)
// 			continue
// 		}

// 		i += 1
// 	}
// }

// destroy_entity :: proc(world: ^World, h: EntityHandle) {
// 	if h == EntityHandleNone {
// 		return
// 	}

// 	remove_colliders_for_entity(world, h)

// 	if e := ha_get_ptr(world.entities, h); e != nil {
// 		delete_entity(e^)

// 		#partial switch v in e.variant {
// 			case Usable:
// 				for i, idx in world.interactables {
// 					if i == h {
// 						unordered_remove(&world.interactables, idx)
// 						break
// 					}
// 				}
// 		}

// 		e^ = {}

// 		ha_remove(&world.entities, h)
// 	}
// }

// get_entity_raw :: proc(h: EntityHandle) -> ^Entity  {
// 	return ha_get_ptr(g_mem.world.entities, h)
// }

// get_entity :: proc(h: EntityHandle, $T: typeid) -> (EntityInst(T), bool) #optional_ok  {
// 	if h == EntityHandleNone {
// 		return {}, false
// 	}

// 	e := ha_get_ptr(g_mem.world.entities, h)

// 	if e != nil {
// 		if var, ok := &e.variant.(T); ok {
// 			return {
// 				e, var,
// 			}, true
// 		}
// 	}

// 	return {}, false
// }

// get_entity_copy :: proc(h: EntityHandle, $T: typeid) -> (EntityCopy(T), bool) #optional_ok  {
// 	if h == EntityHandleNone {
// 		return {}, false
// 	}

// 	if e, ok := ha_get(g_mem.world.entities, h); ok {
// 		if var, ok := e.variant.(T); ok {
// 			return {
// 				e, var,
// 			}, true
// 		}
// 	}

// 	return {}, false
// }

// entity_raw_valid :: proc(h: EntityHandle) -> bool {
// 	return get_entity_raw(h) != nil
// }

// entity_valid :: proc(h: EntityHandle, $T: typeid) -> bool {
// 	if h == EntityNone {
// 		return false
// 	}

// 	_, ok := get_entity(h, T)
// 	return ok
// }

// InputDirection :: enum {
// 	East, West,
// }


// mix :: proc(a, b: proc(f32) -> f32, weight_b, t: f32) -> f32 {
//   return a(t) + weight_b * (b(t) - a(t))
// }

// smooth_start2 :: proc(t: f32) -> f32 {
// 	return t * t
// }

// smooth_stop2 :: proc(t: f32) -> f32 {
// 	return 1 - (1 - t) * (1 - t)
// }

// PlayerCat :: struct {
// 	prev_pos: Vec2,
// 	last_input_direction: InputDirection,
// 	input_dir_change_timer: f32,
// 	input_dir_change_start_offset: f32,
// 	camera_offset: f32,
// 	vel: Vec2,
// 	grounded: bool,
// 	collides_in_front: bool,
// 	collides_in_head: bool,
// 	collides_in_front_overlap: f32,
// 	collides_in_feet: bool,
// 	last_grounded_at: time.Time,
// 	last_grounded_pos: Vec2,
// 	state: PlayerState,
// 	state_time: f32,
// 	state_start_pos: Vec2,
// 	anim_idle: AnimatedSprite,
// 	anim_walk: AnimatedSprite,
// 	anim_charging: AnimatedSprite,
// 	anim_hang: AnimatedSprite,
// 	anim_wallslide: AnimatedSprite,
// 	anim_hangclimb: AnimatedSprite,
// 	anim_jump: AnimatedSprite,
// 	anim_jump_to_hang: AnimatedSprite,
// 	anim_wall_climb: AnimatedSprite,
// 	anim_slap: AnimatedSprite,
// 	anim_baseball: AnimatedSprite,
// 	anim_baseball_up: AnimatedSprite,
// 	anim_wallslide_to_stand: AnimatedSprite,
// 	anim_wakeup: AnimatedSprite,
// 	anim_water: AnimatedSprite,
// 	anim_throw_flour: AnimatedSprite,
// 	anim_place_onion: AnimatedSprite,
// 	nearest_grabpoint: GrabPoint,
// 	lock_camera: bool,

// 	physics_t: f32,

// 	anim: AnimationInstance,
// }

// set_state :: proc(p: EntityInst(PlayerCat), state: PlayerState) {
// 	#partial switch &s in p.state {
// 		case PlayerStateClimbing:
// 			rl.StopSound(s.sound)

// 		case PlayerStateWallSlide:
// 			rl.StopSound(s.sound)
// 	}

// 	p.state = state
// 	p.state_time = 0
// 	p.state_start_pos = p.pos

// 	switch &s in p.state {
// 		case PlayerStateNormal:
// 			p.anim = { anim = p.anim_idle }

// 		case PlayerStateDashing:
// 			p.anim = { anim = p.anim_charging }

// 		case PlayerStateHang:
// 			p.vel = {}
// 			if s.transition_played {
// 				needed_pos := hang_state_grab_pos(s.grab_pos, p.facing)
// 				p.anim = { anim = p.anim_hang }
// 				p.pos = needed_pos
// 			} else {
// 				p.anim = { anim = p.anim_jump_to_hang }
// 			}

// 		case PlayerStateHangClimb:
// 			p.vel = {}
// 			p.anim = { anim = p.anim_hangclimb }
// 			play_sound_range(.CatClimb1, .CatClimb2)

// 		case PlayerStateWallSlide:
// 			p.vel = {}
// 			if s.transition_played {
// 				p.anim = { anim = p.anim_wallslide }
// 			} else {
// 				p.anim = { anim = p.anim_jump_to_hang }
// 			}

// 		case PlayerStateJumping:
// 			p.anim = { anim = p.anim_jump }

// 		case PlayerStateInteracting:
// 			p.anim = { anim = p.anim_idle }

// 		case PlayerStateClimbing:
// 			s.sound = play_sound_range(.CatWallClimb0, .CatWallClimb2)
// 			p.vel = {}
// 			p.anim = { anim = p.anim_wall_climb }

// 		case PlayerStateSlaping:
// 			p.vel = {}
// 			p.anim = { anim = p.anim_slap }

// 		case PlayerStateBaseballin:
// 			p.vel = {}
// 			p.anim = { anim = p.anim_baseball }

// 		case PlayerStateFloating:
// 			p.vel = {}
// 			p.anim = { anim = p.anim_idle }

// 		case PlayerStateFloatingToEnd:
// 			s.squirrel = find_entity_of_kind(.Squirrel)
// 			p.vel = {}
// 			p.anim = { anim = p.anim_idle }

// 		case PlayerStateFloatingToKitchen:
// 			s.squirrel = find_entity_of_kind(.Squirrel)
// 			p.vel = {}
// 			p.anim = { anim = p.anim_idle }

// 		case PlayerStateEnterEnd:
// 			s.start_zoom = g_mem.camera_state.zoom
// 			s.camera_start_pos = g_mem.camera_state.pos
// 			p.render_pos = {}
// 			p.vel = {}
// 			p.anim = { anim = p.anim_idle }

// 		case PlayerStateButterCharge:
// 			p.anim = { anim = p.anim_charging }
// 			p.vel = {}

// 		case PlayerStateWallslideToNormal:
// 			p.anim = { anim = p.anim_wallslide_to_stand }
// 			p.vel = {}

// 		case PlayerStateOneShotAnim:
// 			if !s.walk_to_target_x {
// 				p.anim = { anim = s.anim }
// 			}
// 			p.vel = {}

// 		case PlayerStateExternallyControlled:
// 	}
// }

// animated_sprite_size :: proc(s: ^AnimatedSprite) -> Vec2 {
// 	tex := get_texture(s.texture)
// 	return { f32(int(tex.width) / s.num_frames), f32(tex.height) }
// }

// get_default_collider :: proc(pos: Vec2) -> rl.Rectangle {
// 	return { pos.x - 6, pos.y - 2, 12, 10 }
// }

// get_rocket_collider :: proc(pos: Vec2) -> Rect {
// 	return { pos.x - 11, pos.y - 12, 22, 30 }
// }

// get_player_collider :: proc(pos: Vec2, state: ^PlayerState) -> rl.Rectangle {
// 	default_collider := get_default_collider(pos)

// 	switch s in state {
// 		case PlayerStateNormal:
// 			return default_collider

// 		case PlayerStateJumping:
// 			return default_collider

// 		case PlayerStateDashing:
// 			dash_collider := default_collider
// 			dash_collider.height = 6
// 			dash_collider.y += 6
// 			return dash_collider

// 		case PlayerStateWallSlide:
// 			/*ws_collider := default_collider
// 			ws_collider.width -= 2
// 			ws_collider.x += 1
// 			return ws_collider*/
// 			return {}

// 		case PlayerStateHang:
// 			return {}

// 		case PlayerStateHangClimb:
// 			return {}

// 		case PlayerStateInteracting:
// 			return default_collider

// 		case PlayerStateClimbing:
// 			/*ws_collider := default_collider
// 			ws_collider.width -= 2
// 			ws_collider.x += 1
// 			return ws_collider*/
// 			return {}

// 		case PlayerStateSlaping:
// 			return default_collider

// 		case PlayerStateBaseballin:
// 			return default_collider

// 		case PlayerStateFloating:
// 			return {}

// 		case PlayerStateFloatingToEnd:
// 			return {}

// 		case PlayerStateFloatingToKitchen:
// 			return {}

// 		case PlayerStateEnterEnd:
// 			return {}

// 		case PlayerStateButterCharge:
// 			return {}

// 		case PlayerStateWallslideToNormal:
// 			return default_collider

// 		case PlayerStateOneShotAnim:
// 			return default_collider

// 		case PlayerStateExternallyControlled:
// 			return {}
// 	}

// 	return {}
// }

// player_carry_pos :: proc() -> Vec2 {
// 	if cat, ok := get_entity(g_mem.controlled_entity, PlayerCat); ok {
// 		return cat.pos + (cat.facing == .East ? {3, -11} : {-4, -11})
// 	}

// 	return {}
// }

// player_put_down_pos :: proc() -> Vec2 {
// 	if cat, ok := get_entity(g_mem.controlled_entity, PlayerCat); ok {
// 		return cat.pos + (cat.facing == .East ? {10, 4} : {-10, 4})
// 	}

// 	return {}
// }

// get_player_feet_collider :: proc(p: EntityInst(PlayerCat)) -> rl.Rectangle {
// 	player_feet_collider := get_default_collider(p.pos)
// 	player_feet_collider.y += player_feet_collider.height - 2
// 	player_feet_collider.height = 4
// 	player_feet_collider.x += 2
// 	player_feet_collider.width -= 4
// 	return player_feet_collider
// }

// FrontColliderWidth :: 4

// get_player_front_collider :: proc(p: EntityInst(PlayerCat)) -> rl.Rectangle {
// 	player_front_collider := get_default_collider(p.pos)
// 	player_front_collider.y += 1
// 	player_front_collider.x += p.facing == .East ? player_front_collider.width : -FrontColliderWidth
// 	player_front_collider.width = FrontColliderWidth
// 	player_front_collider.height -= 2
// 	return player_front_collider
// }

// HeadColliderHeight :: 4

// get_player_head_collider :: proc(p: EntityInst(PlayerCat)) -> rl.Rectangle {
// 	hc := get_default_collider(p.pos)
// 	hc.y -= HeadColliderHeight
// 	hc.height = HeadColliderHeight
// 	hc.x += 3
// 	hc.width -= 6
// 	return hc
// }

// update_animation :: proc(a: ^AnimationInstance, oneshot: bool = false, speed_mult: f32 = 1) -> bool {
// 	if a.anim.texture == TextureHandleNone || a.anim.num_frames == 0 {
// 		return false
// 	}

// 	if !a.started {
// 		a.cur_frame = 0
// 		a.frame_timer = a.frame_length
// 		a.started = true
// 	}

// 	num_frames := a.anim.num_frames
// 	frame_length := a.anim.frame_length

// 	a.frame_timer -= dt * speed_mult

// 	looped := false

// 	if a.frame_timer <= 0 {
// 		a.cur_frame += 1

// 		if a.cur_frame >= num_frames {
// 			if oneshot {
// 				a.cur_frame = a.num_frames - 1
// 			} else {
// 				a.cur_frame = 0
// 				looped = true
// 			}
// 		}

// 		play_animation_frame_sound(a.texture_name, a.cur_frame)

// 		// Add frame_timer here in case it is negative, so we don't end up losing time
// 		a.frame_timer = frame_length + a.frame_timer
// 	}

// 	return looped
// }

// make_animated_sprite :: proc(texture: TextureName, frame_length: f32, offset: Vec2 = {0,0}) -> AnimatedSprite {
// 	return AnimatedSprite {
// 		texture = get_texture_handle(texture),
// 		texture_name = texture,
// 		num_frames = animation_num_frames(texture),
// 		frame_length = frame_length,
// 		offset = offset,
// 	}
// }

// collision_resolve :: proc(resolve_for: rl.Rectangle, other: rl.Rectangle) -> (bool, Vec2) {
// 	coll_rect := rl.GetCollisionRec(resolve_for, other)

// 	if coll_rect.width == 0 && coll_rect.height == 0 {
// 		return false, {}
// 	}

// 	if coll_rect.width < coll_rect.height {
// 		on_right := resolve_for.x + resolve_for.width / 2 > coll_rect.x
// 		return true, {on_right ? coll_rect.width : -coll_rect.width, 0}
// 	}

// 	on_top := resolve_for.y + resolve_for.height / 2 < coll_rect.y
// 	return true, {0, on_top ? -coll_rect.height : coll_rect.height}
// }

// tile_world_rect :: proc(x, y: int) -> Rect {
// 	return {
// 		f32(x * TileHeight), f32(y * TileHeight),
// 		TileHeight,
// 		TileHeight,
// 	},
// }

// tile_tileset_rect :: proc(x, y: int, px, py: int, flip_x: bool, flip_y: bool) -> Rect {
// 	return {
// 		f32(x * TileHeight + px*(2*x + 1)),
// 		f32(y * TileHeight + py*(2*y + 1)),
// 		flip_x ? -TileHeight : TileHeight,
// 		flip_y ? -TileHeight : TileHeight,
// 	},
// }

// delete_world :: proc(w: World) {
// 	e_iter := ha_make_iter(w.entities)
// 	for e in ha_iter(&e_iter) {
// 		delete_entity(e)
// 	}

// 	for d in w.dialogue_trees {
// 		for n in d.nodes {
// 			switch v in n.variant {
// 				case DialogueNodeVariantNormal:
// 					delete(v.text)

// 					for c in v.choices {
// 						delete(c.text)
// 					}

// 				case DialogueNodeVariantStart:

// 				case DialogueNodeVariantProgressCheck:

// 				case DialogueNodeVariantSetProgress:

// 				case DialogueNodeVariantGivePlayerItem:

// 				case DialogueNodeVariantTriggerEvent:

// 				case DialogueNodeVariantTakeItem:

// 				case DialogueNodeVariantItemCheck:
// 			}

// 		}

// 		delete(d.nodes)
// 		delete(d.connections)
// 	}

// 	ha_delete(w.entities)
// 	ha_delete(w.entity_types)
// 	delete(w.interactables)
// 	delete(w.entity_lookup)
// 	delete(w.tiles)
// 	delete(w.triggers)
// 	delete(w.colliders)
// 	delete(w.grab_points)
// 	delete(w.named_positions)
// 	delete(w.named_splines)
// 	delete(w.clouds)
// 	delete(w.fading_renderables)
// }

// get_built_in_type :: proc(w: World, v: EntityTypeBuiltinVariant) -> (EntityType, bool) {
// 	et_iter := ha_make_iter(w.entity_types)
// 	for et in ha_iter(&et_iter) {
// 		if etb, ok := et.variant.(EntityTypeBuiltin); ok {
// 			if etb.variant == v {
// 				return et, true
// 			}
// 		}
// 	}

// 	return {}, false
// }

// get_builtin_entity_type_uid :: proc(t: EntityTypeBuiltinVariant) -> UID {
// 	#partial switch t {
// 		case .None: return 0
// 		case .Trigger: return string_to_uid("trigger")
// 		case .Interactable: return string_to_uid("interactable")
// 		case .Spline: return string_to_uid("curve")
// 		case .Collider: return string_to_uid("collider")
// 	}

// 	return 0
// }

// create_world :: proc(ss: SerializedState) -> World {
// 	w: World

// 	entity_type_lookup := make(map[UID]EntityTypeHandle, 10, context.temp_allocator)

// 	for t in EntityTypeBuiltinVariant {
// 		if t == .None {
// 			continue
// 		}

// 		id := get_builtin_entity_type_uid(t)

// 		type := EntityType {
// 			id = id,
// 			variant = EntityTypeBuiltin {
// 				variant = t,
// 			},
// 		}

// 		entity_type_lookup[id] = ha_add(&w.entity_types, type)
// 	}

// 	entity_types: []EntityType

// 	ser: Ser
// 	ser_init_reader(&ser, ss.entity_types)
// 	assert(ser_slice(&ser, &entity_types))

// 	for et in entity_types {
// 		entity_type_lookup[et.id] = ha_add(&w.entity_types, et)
// 	}

// 	delete(entity_types)
// 	level: Level
// 	ser_init_reader(&ser, ss.level)
// 	assert(ser_level(&ser, &level))

// 	w.tiles = slice.clone_to_dynamic(level.tiles)

// 	for &e in level.entities {
// 		if eth, ok := entity_type_lookup[e.type.id]; ok {
// 			e.type = eth
// 		}

// 		w.entity_lookup[EntityReference(e.id)] = ha_add(&w.entities, e)
// 	}

// 	resolve_event_references :: proc(w: ^World, event: ^Event) {
// 		#partial switch &e in event {
// 			case EventAnimateAlongSpline:
// 				resolve_entity_reference(w, &e.entity)
// 				resolve_entity_reference(w, &e.spline)

// 			case EventRocketSplineDone:
// 				resolve_entity_reference(w, &e.spline)

// 			case EventTeleportEntity:
// 				resolve_entity_reference(w, &e.entity)
// 				resolve_entity_reference(w, &e.target)
// 		}
// 	}

// 	ent_iter := ha_make_iter(w.entities)
// 	for e in ha_iter_ptr(&ent_iter) {
// 		#partial switch &v in e.variant {
// 			case Usable:
// 				for &au in v.actions {
// 					switch &a in au {
// 						case ActionPlayAnimation:
// 							resolve_entity_reference(&w, &a.entity)

// 						case ActionDisableCollision:
// 							resolve_entity_reference(&w, &a.entity)

// 						case ActionPickup:
// 							resolve_entity_reference(&w, &a.entity)

// 						case ActionDeleteEntity:
// 							resolve_entity_reference(&w, &a.entity)

// 						case ActionEnableEntity:
// 							resolve_entity_reference(&w, &a.entity)

// 						case ActionLoadLevel:

// 						case ActionStartDialogue:
// 							resolve_entity_reference(&w, &a.entity)

// 						case ActionMoveAlongSpline:
// 							resolve_entity_reference(&w, &a.entity)
// 							resolve_entity_reference(&w, &a.spline)
// 							resolve_entity_reference(&w, &a.done_interactable)

// 						case ActionPlayerJump:

// 						case ActionSetInteractionEnabled:
// 							resolve_entity_reference(&w, &a.target)

// 						case ActionFocusCamera:
// 							resolve_entity_reference(&w, &a.target)

// 					}
// 				}

// 			case Trigger:
// 				resolve_entity_reference(&w, &v.target)
// 				resolve_event_references(&w, &v.event)

// 			case Spline:
// 				resolve_event_references(&w, &v.on_done_event)

// 			case SplineEvaluator:
// 				resolve_entity_reference(&w, &v.target)
// 				resolve_entity_reference(&w, &v.spline)
// 		}
// 	}

// 	ser_init_reader(&ser, ss.dialogue_trees)
// 	dialogue_trees: [dynamic]DialogueTree
// 	assert(ser_dynamic_array(&ser, &dialogue_trees))

// 	for d in dialogue_trees {
// 		w.dialogue_trees[d.name] = d
// 	}

// 	delete(level.tiles)
// 	delete(level.entities)
// 	delete(dialogue_trees)

// 	return w
// }

// enable_world :: proc(w: ^World) {
// 	for t, t_idx in w.tiles {
// 		if t.layer >= 0 {
// 			append(&w.colliders, Collider { rect = tile_world_rect(t.x, t.y), tile = t_idx } )
// 		}
// 	}

// 	e_iter := ha_make_iter(w.entities)
// 	for e, eh in ha_iter_ptr(&e_iter) {
// 		if !e.disabled {
// 			enable_entity(w, eh)
// 		}
// 	}

// 	recreate_grabpoints(w)
// }

// get_nearest_grabpoint :: proc(grab_points: []GrabPoint, p: EntityInst(PlayerCat)) -> (grab_point: GrabPoint) {
// 	grab_point_distance2 : f32 = math.INF_F32
// 	player_grab_pos := get_player_grab_pos(p)

// 	for gp in grab_points {
// 		pos_diff := gp.pos - player_grab_pos
// 		dist2 := linalg.length2(pos_diff)

// 		if dist2 < grab_point_distance2 {
// 			grab_point = gp
// 			grab_point_distance2 = dist2
// 		}
// 	}

// 	return grab_point
// }

// dt: f32

// hang_state_grab_pos :: proc(grab_point: Vec2, facing: Facing) -> Vec2 {
// 	return grab_point - Vec2{facing == .West ? -5 : 5, -5}
// }

// is_rect_colliding :: proc(r: Rect, world: ^World) -> bool {
// 	for c in world.colliders {
// 		if rl.CheckCollisionRecs(c.rect, r) {
// 			return true
// 		}
// 	}

// 	return false
// }

// get_hang_state_collider :: proc(p: Vec2) -> Rect {
// 	return { p.x - 5, p.y - 5, 10, 10 }
// }

// is_hang_state_allowed :: proc(world: ^World, grab_point_pos: Vec2, hang_facing: Facing) -> bool {
// 	profile_scope()
// 	player_top_coll := get_default_collider(grab_point_pos + (hang_facing == .East ? Vec2{8, -8} : Vec2{-8, -8}))
// 	coll := get_hang_state_collider(hang_state_grab_pos(grab_point_pos, hang_facing))

// 	for c in world.colliders {
// 		if c.one_direction {
// 			continue
// 		}

// 		if rl.CheckCollisionRecs(player_top_coll, c.rect) || rl.CheckCollisionRecs(coll, c.rect) {
// 			return false
// 		}
// 	}

// 	return true
// }

// try_grab :: proc(world: ^World, p: EntityInst(PlayerCat), skip_transition := false) -> bool {
// 	player_grab_pos := get_player_grab_pos(p)
// 	grabbed := false
// 	grab_threshold: f32 = 7
// 	gp := p.nearest_grabpoint
// 	pos_diff := gp.pos - player_grab_pos

// 	if linalg.length(pos_diff) < grab_threshold && gp.compatible_facing == p.facing && (pos_diff.y <= 0 || ((p.facing == .East && pos_diff.x < -1) || (p.facing == .West && pos_diff.x > 1))) {
// 		if is_hang_state_allowed(world, gp.pos, p.facing) {
// 			p.vel = {}
// 			new_state := PlayerStateHang{ grab_pos = gp.pos }
// 			new_state.transition_played = skip_transition
// 			set_state(p, new_state)
// 			grabbed = true
// 		}
// 	}

// 	return grabbed
// }

// EntityNone :: EntityHandle {}

// get_player_grab_pos :: proc(p: EntityInst(PlayerCat)) -> Vec2 {
// 	return p.pos + {p.facing == .East ? 6 : -6, 4}
// }

// jump :: proc(p: EntityInst(PlayerCat)) {
// 	p.vel.y = -220
// 	p.grounded = false
// 	set_state(p, PlayerStateJumping{})
// 	play_sound_range(.Step0, .Step4)
// }

// animation_rect :: proc(a: ^AnimationInstance, flip_x: bool) -> Rect {
// 	if a == nil || a.anim.num_frames == 0 || a.anim.texture == TextureHandleNone {
// 		return {}
// 	}

// 	tex := get_texture(a.anim.texture)

// 	source := rl.Rectangle {
// 		x = linalg.floor(f32(a.cur_frame * int(tex.width)/a.anim.num_frames)),
// 		y = 0,
// 		width = f32(int(tex.width)/a.anim.num_frames),
// 		height = f32(tex.height),
// 	}

// 	return source
// }

// animation_num_frames :: proc(texture: TextureName) -> int {
// 	#partial switch texture {
// 		case .RootCellarDoorAnim: return 4
// 		case .FlourTree: return 13
// 		case .FlourTreeFoliage: return 28
// 		case .FlourTreeFace: return 4
// 		case .NpcStoneFace: return 2
// 		case .Waterfall: return 4
// 		case .WaterfallFace: return 2
// 		case .SpaceOnionTalk: return 3
// 		case .SpaceOnionTalkOutline: return 3
// 		case .SpaceOnionGrow: return 14
// 		case .RocketCatJumpIn: return 15
// 		case .RocketCatLeave: return 10
// 		case .Fire: return 4
// 		case .InsideDoor: return 4
// 		case .DoorFace: return 2
// 		case .Cat: return 4
// 		case .CatBaseball: return 19
// 		case .CatBaseballUp: return 17
// 		case .CatHangclimb: return 13
// 		case .CatIdle: return 2
// 		case .CatJump: return 3
// 		case .CatJumpToHang: return 3
// 		case .CatSlap: return 9
// 		case .CatButterCharge: return 21
// 		case .CatWallClimb: return 4
// 		case .CatThrowFlour: return 11
// 		case .CatWakeup: return 24
// 		case .CatWater: return 27
// 		case .CatPlaceOnion: return 7
// 		case .Squirrel: return 4
// 		case .Hatch: return 4
// 		case .AcornFace: return 5
// 		case .CatWallslideToStand: return 3
// 		case .EggShell: return 10
// 		case .PontusPlanet: return 11
// 		case .CatCloud: return 3
// 		case .Pancake: return 6
// 		case .CaveFace: return 6
// 		case .CaveFaceTalk: return 2
// 	}

// 	return 1
// }

// draw_texture_source_rect :: proc(tex: rl.Texture, flip_x: bool) -> rl.Rectangle {
// 	return {
// 		x = 0,
// 		y = 0,
// 		width = flip_x ? - f32(tex.width) : f32(tex.width),
// 		height = f32(tex.height),
// 	}
// }

// draw_texture_dest_rect :: proc(tex: rl.Texture, p: Vec2, scl: f32 = 1) -> rl.Rectangle {
// 	return {
// 		x = p.x,
// 		y = p.y,
// 		width = f32(tex.width) * scl,
// 		height = f32(tex.height) * scl,
// 	}
// }

// draw_texture_dest_rect_scl :: proc(tex: rl.Texture, p: Vec2, scl: Vec2) -> rl.Rectangle {
// 	return {
// 		x = p.x,
// 		y = p.y,
// 		width = f32(tex.width) * scl.x,
// 		height = f32(tex.height) * scl.y,
// 	}
// }

// rect_middle :: proc(r: rl.Rectangle) -> Vec2 {
// 	return {
// 		r.x + f32(r.width) * 0.5,
// 		r.y + f32(r.height) * 0.5,
// 	}
// }

// rect_local_middle :: proc(r: rl.Rectangle) -> Vec2 {
// 	return {
// 		f32(r.width) * 0.5,
// 		f32(r.height) * 0.5,
// 	}
// }

// camera_width :: proc(zoom: f32) -> f32 {
// 	return screen_width() / zoom
// }

// screen_height :: proc() -> f32 {
// 	if g_mem.editing {
// 		return f32(rl.GetScreenHeight())
// 	}

// 	h := f32(g_mem.main_drawing_tex.texture.height) / dpi_scale()

// 	if h == 0 {
// 		log.warn("render tex height 0")
// 		h = 720
// 	}

// 	return h
// }

// screen_width :: proc() -> f32 {
// 	if g_mem.editing {
// 		return f32(rl.GetScreenWidth())
// 	}

// 	w := f32(g_mem.main_drawing_tex.texture.width) / dpi_scale()

// 	if w == 0 {
// 		log.warn("render tex width 0")
// 		w = 1280
// 	}

// 	return w
// }

// screen_size :: proc() -> Vec2 {
// 	return {
// 		screen_width(),
// 		screen_height(),
// 	}
// }

// screen_top_left :: proc() -> Vec2 {
// 	sw := rl.IsWindowFullscreen() ? f32(rl.GetMonitorWidth(rl.GetCurrentMonitor())) : f32(rl.GetScreenWidth())
// 	sh := rl.IsWindowFullscreen() ? f32(rl.GetMonitorHeight(rl.GetCurrentMonitor())) : f32(rl.GetScreenHeight())

// 	war := wanted_ar()

// 	if current_ar() > war {
// 		h := sw*war
// 		return {0, sh/2 - h/2}
// 	} else {
// 		w := sh*(1/war)
// 		return { sw/2 - w/2, 0}
// 	}
// }

// get_camera_from_state :: proc(cs: CameraState) -> rl.Camera2D {
// 	shake_offset := Vec2 {
// 		cs.shake_amp * f32(math.cos((g_mem.time + 10) * f64(cs.shake_freq))),
// 		cs.shake_amp * f32(math.sin(g_mem.time * f64(cs.shake_freq))),
// 	}

// 	return rl.Camera2D {
// 		target = cs.pos + shake_offset,
// 		offset = screen_size() / 2 ,
// 		zoom = cs.zoom,
// 	}
// }

// get_camera_from_pos_zoom :: proc(pos: Vec2, zoom: f32) -> rl.Camera2D {
// 	return rl.Camera2D {
// 		target = pos,
// 		offset = screen_size() / 2,
// 		zoom = zoom,
// 	}
// }

// get_camera :: proc { get_camera_from_state, get_camera_from_pos_zoom }

// lerp_color :: proc(a, b: rl.Color, t: f32) -> (x: rl.Color) {
// 	af: Vec4 = { f32(a.r), f32(a.g), f32(a.b), f32(a.a) }
// 	bf: Vec4 = { f32(b.r), f32(b.g), f32(b.b), f32(b.a) }
// 	res := af*(1-t) + bf*t
// 	return { u8(res.r), u8(res.g), u8(res.b), u8(res.a) }
// }

// @(private="file")
// world: ^World

// update_camera :: proc(x_vel: f32 = 0) {
// 	p, p_ok := get_entity(g_mem.cat, PlayerCat)

// 	if !p_ok {
// 		return
// 	}

// 	cs := &g_mem.camera_state

// 	if cs.pause_camera_until > g_mem.time {
// 		return
// 	}

// 	pos := p.pos

// 	if rp, ok := p.render_pos.?; ok {
// 		pos = rp
// 	}

// 	camera_size := screen_size() / cs.zoom

// 	switch &m in cs.mode {
// 		case CameraFollowPlayer:
// 			if !m.player_start_pos_set {
// 				m.player_start_pos = pos
// 				m.player_start_pos_set = true
// 			}

// 			camera_distance := camera_size.x / 6
// 			camera_toggle_distance := camera_size.x / 8

// 			cr := rect_from_pos_size(cs.pos - camera_size * 0.5, camera_size)
// 			rm := rect_middle(cr)

// 			if m.y_target != cs.wanted_y {
// 				m.y_start = cs.pos.y
// 				m.y_target = cs.wanted_y
// 				m.y_lerp_t = 0
// 			}

// 			m.y_lerp_t += dt
// 			m.y_lerp_t = math.saturate(m.y_lerp_t)
// 			cs.pos.y = math.lerp(m.y_start, m.y_target, mix(smooth_start2, smooth_stop2, m.y_lerp_t, m.y_lerp_t))

// 			left_toggle := m.player_start_pos.x + camera_toggle_distance
// 			right_toggle := m.player_start_pos.x - camera_toggle_distance
// 			margin := camera_size.x / 5

// 			if right_toggle < cr.x + margin {
// 				diff := (cr.x + margin) - right_toggle
// 				left_toggle += diff
// 				right_toggle += diff
// 			}

// 			if left_toggle > cr.x + cr.width - margin {
// 				diff := (cr.x + cr.width - margin) - left_toggle
// 				left_toggle += diff
// 				right_toggle += diff
// 			}

// 			switch m.player_side {
// 				case .None:
// 					if g_mem.debug_draw {
// 						draw_rectangle(Rect { left_toggle, rm.y - 50, 1, 100}, rl.RED, 100)
// 						draw_rectangle(Rect { right_toggle, rm.y - 50, 1, 100}, rl.RED, 100)
// 					}

// 					if pos.x > left_toggle {
// 						m.player_side = .Left
// 						m.camera_offset_lerp_start = rm.x - pos.x
// 						m.camera_offset_lerp_end = camera_distance
// 						m.camera_lerp_t = 0
// 					}

// 					if pos.x < right_toggle {
// 						m.player_side = .Right
// 						m.camera_offset_lerp_start = rm.x - pos.x
// 						m.camera_offset_lerp_end = -camera_distance
// 						m.camera_lerp_t = 0
// 					}

// 				case .Left:
// 					if x_vel > 0 {
// 						m.camera_lerp_t += dt * 0.5
// 					} else if x_vel < 0 {
// 						m.player_side = .None
// 						m.player_start_pos_set = false
// 						break
// 					}

// 					if g_mem.debug_draw {
// 						draw_rectangle(Rect { rm.x - camera_distance, rm.y - 40, 1, 80}, rl.GREEN, 100)
// 					}

// 					m.camera_lerp_t = math.saturate(m.camera_lerp_t)
// 					m.camera_offset = math.lerp(m.camera_offset_lerp_start, m.camera_offset_lerp_end, mix(smooth_start2, smooth_stop2, m.camera_lerp_t, m.camera_lerp_t))
// 					cs.pos.x = pos.x + m.camera_offset

// 				case .Right:
// 					if x_vel < 0 {
// 						m.camera_lerp_t += dt * 0.5
// 					} else if x_vel > 0 {
// 						m.player_side = .None
// 						m.player_start_pos_set = false
// 						break
// 					}

// 					if g_mem.debug_draw {
// 						draw_rectangle(Rect { rm.x + camera_distance, rm.y - 40, 1, 80}, rl.GREEN, 100)
// 					}

// 					m.camera_lerp_t = math.saturate(m.camera_lerp_t)
// 					m.camera_offset = math.lerp(m.camera_offset_lerp_start, m.camera_offset_lerp_end, mix(smooth_start2, smooth_stop2, m.camera_lerp_t, m.camera_lerp_t))
// 					cs.pos.x = pos.x + m.camera_offset
// 			}

// 		case CameraInVolume:
// 			if v, ok := get_entity(m.volume, Trigger); ok && rl.CheckCollisionRecs(get_default_collider(pos), trigger_world_rect(v)) {
// 				m.lerp_t += dt * 0.5
// 				m.lerp_t = math.saturate(m.lerp_t)
// 				target := linalg.floor(rect_middle(trigger_world_rect(v)))
// 				cs.pos = math.lerp(m.start, target, mix(smooth_start2, smooth_stop2, m.lerp_t, m.lerp_t))

// 				if m.fit {
// 					target_zoom := default_game_camera_zoom() * (320 / v.rect.width)
// 					cs.zoom = math.lerp(m.start_zoom, target_zoom, mix(smooth_start2, smooth_stop2, m.lerp_t, m.lerp_t))
// 				}
// 			} else {
// 				if m.fit {
// 					cs.zoom = m.start_zoom
// 				}

// 				cs.mode = CameraFollowPlayer{}
// 			}

// 		case CameraLocked:
// 	}
// }

// MaxGamepads :: 4

// Input :: struct {
// 	x: f32,
// 	y: f32,
// 	jump: bool,
// 	jump_held: bool,
// 	use: bool,
// 	grab: bool,
// 	climb_down: bool,
// 	prev_item: bool,
// 	next_item: bool,
// 	ui_up: bool,
// 	ui_down: bool,
// 	ui_up_held: bool,
// 	ui_down_held: bool,
// 	ui_select: bool,
// 	toggle_menu: bool,
// 	dialogue_skip: bool,
// 	gamepad: bool,

// 	gamepad_down: [rl.GamepadButton]bool,
// 	gamepad_pressed: [rl.GamepadButton]bool,
// 	gamepad_left_x: f32,
// 	gamepad_left_y: f32,
// }

// InteractMaxDistance :: 30

// draw_circle :: proc(pos: Vec2, radius: f32 = 1, color: rl.Color = rl.WHITE, layer: int = 100) {
// 	append(&g_mem.to_render, Renderable {
// 		variant = RenderableCircle {
// 			pos = pos,
// 			radius = radius,
// 			color = color,
// 		},
// 		layer = layer,
// 	})
// }

// interactable_pos :: proc(e: ^Entity) -> Vec2 {
// 	flip := Vec2{1,1}

// 	if e.facing == .West || e.flip_x {
// 		flip.x = -1
// 	}

// 	return e.pos + e.interactable_offset * flip
// }

// is_closer_interactable :: proc(eh: EntityHandle, ph: EntityHandle, then: f32, max: f32 = math.F32_MAX) -> (bool, f32) {
// 	p, p_ok := get_entity(ph, PlayerCat)
// 	e := get_entity_raw(eh)

// 	if !p_ok || e == nil {
// 		return false, then
// 	}

// 	flip := Vec2{1,1}

// 	if e.facing == .West || e.flip_x {
// 		flip.x = -1
// 	}

// 	pos := e.pos + e.interactable_offset * flip

// 	if g_mem.debug_draw {
// 		draw_circle(pos)
// 		draw_circle(pos + e.interactable_icon_offset * flip, color = ColorCat)
// 	}

// 	in_front := (p.facing == .West && pos.x < p.pos.x) || (p.facing == .East && pos.x > p.pos.x) || e.interactable_from_behind

// 	if !e.interactable || !in_front {
// 		return false, then
// 	}

// 	dist := linalg.length(pos - p.pos)

// 	if dist < then && dist < max {
// 		return true, dist
// 	} else {
// 		return false, then
// 	}
// }

// clear_input :: proc() {
// 	old_input := input
// 	input = {
// 		ui_up_held = old_input.ui_up_held,
// 		ui_down_held = old_input.ui_down_held,
// 		gamepad = old_input.gamepad,
// 	}
// }

// gather_input :: proc() {
// 	profile_scope()
// 	clear_input()

// 	for b in rl.GamepadButton {
// 		for gp in 0..<MaxGamepads {
// 			if rl.IsGamepadButtonDown(i32(gp), b) {
// 				input.gamepad_down[b] = true
// 			}

// 			if rl.IsGamepadButtonPressed(i32(gp), b) {
// 				input.gamepad_pressed[b] = true
// 			}
// 		}
// 	}

// 	for gp in 0..<MaxGamepads {
// 		x := rl.GetGamepadAxisMovement(i32(gp), .LEFT_X)

// 		if abs(x) > abs(input.gamepad_left_x) {
// 			input.gamepad_left_x = x
// 		}

// 		y := rl.GetGamepadAxisMovement(i32(gp), .LEFT_Y)

// 		if abs(y) > abs(input.gamepad_left_y) {
// 			input.gamepad_left_y = y
// 		}
// 	}

// 	if g_mem.disable_input_until > g_mem.time {
// 		return
// 	}

// 	gamepad_movement: bool

// 	// handle gamepad input
// 	{
// 		b := &settings.gamepad_bindings
// 		down := &input.gamepad_down
// 		pressed := &input.gamepad_pressed
// 		x := input.gamepad_left_x

// 		if down[b[.Left]] {
// 			x = -1
// 		}

// 		if down[b[.Right]] {
// 			x = 1
// 		}

// 		y := input.gamepad_left_y
// 		input.x = math.abs(x) > 0.3 ? x : 0
// 		input.y = math.abs(y) > 0.3 ? y : 0

// 		if input.x != 0 || input.y != 0 {
// 			input.gamepad = true
// 			gamepad_movement = true
// 		}

// 		if pressed[b[.Jump]] {
// 			input.jump = true
// 			input.ui_select = true
// 			input.gamepad = true
// 		}

// 		if down[b[.Jump]] {
// 			input.jump_held = true
// 			input.gamepad = true
// 		}

// 		if pressed[b[.Use]] {
// 			input.use = true
// 			input.gamepad = true
// 			input.ui_select = true
// 			input.dialogue_skip = true
// 		}

// 		if input.y < 0 {
// 			input.grab = true
// 		}

// 		if input.y > 0.75 {
// 			input.climb_down = true
// 		}

// 		if pressed[b[.ClimbDown]] {
// 			input.climb_down = true
// 			input.gamepad = true
// 			input.dialogue_skip = true
// 		}

// 		if input.y < -0.5 {
// 			if !input.ui_up_held {
// 				input.ui_up_held = true
// 				input.ui_up = true
// 			}
// 		} else {
// 			input.ui_up_held = false
// 		}

// 		if input.y > 0.5 {
// 			if !input.ui_down_held {
// 				input.ui_down_held = true
// 				input.ui_down = true
// 			}
// 		} else {
// 			input.ui_down_held = false
// 		}

// 		if pressed[b[.PreviousItem]] {
// 			input.prev_item = true
// 			input.gamepad = true
// 		}

// 		if pressed[b[.NextItem]] {
// 			input.next_item = true
// 			input.gamepad = true
// 		}

// 		if pressed[.MIDDLE_RIGHT] {
// 			input.toggle_menu = true
// 			input.gamepad = true
// 		}

// 		if pressed[.RIGHT_FACE_DOWN] {
// 			input.ui_select = true
// 			input.gamepad = true
// 		}

// 		if pressed[.LEFT_FACE_DOWN] {
// 			input.gamepad = true
// 			input.ui_down = true
// 		}

// 		if pressed[.LEFT_FACE_UP] {
// 			input.gamepad = true
// 			input.ui_up = true
// 		}
// 	}

// 	b := &settings.keyboard_bindings

// 	if !gamepad_movement && rl.IsKeyDown(b[.Left]) {
// 		input.x -= 1
// 		input.gamepad = false
// 	}

// 	if !gamepad_movement && rl.IsKeyDown(b[.Right]) {
// 		input.x += 1
// 		input.gamepad = false
// 	}

// 	if rl.IsKeyPressed(b[.Jump]) {
// 		input.jump = true
// 		input.gamepad = false
// 		input.ui_select = true
// 	}

// 	if rl.IsKeyDown(b[.Jump]) {
// 		input.jump_held = true
// 		input.grab = true
// 		input.gamepad = false
// 	}

// 	if rl.IsKeyPressed(b[.Use]) {
// 		input.use = true
// 		input.gamepad = false
// 		input.ui_select = true
// 		input.dialogue_skip = true
// 	}

// 	if rl.IsKeyPressed(b[.ClimbDown]) {
// 		input.climb_down = true
// 		input.gamepad = false
// 	}

// 	if rl.IsKeyPressed(.ENTER) && rl.IsKeyUp(.LEFT_ALT) {
// 		input.ui_select = true
// 	}

// 	if rl.IsKeyPressed(.DOWN) {
// 		input.gamepad = false
// 		input.ui_down = true
// 	}

// 	if rl.IsKeyPressed(.UP) {
// 		input.gamepad = false
// 		input.ui_up = true
// 	}

// 	if rl.IsKeyPressed(b[.PreviousItem]) {
// 		input.prev_item = true
// 		input.gamepad = false
// 	}

// 	if rl.IsKeyPressed(b[.NextItem]) {
// 		input.next_item = true
// 		input.gamepad = false
// 	}

// 	if rl.IsKeyPressed(.ESCAPE) {
// 		input.toggle_menu = true
// 	}

// 	// No controlled entity, clear all input except menu stuff
// 	if g_mem.controlled_entity == EntityHandleNone {
// 		input.x = 0
// 		input.y = 0
// 		input.jump = false
// 		input.jump_held = false
// 		input.use = false
// 		input.grab = false
// 		input.climb_down = false
// 		input.prev_item = false
// 		input.next_item = false
// 		input.dialogue_skip = false
// 	}
// }

// Binding :: enum {
// 	Left,
// 	Right,
// 	ClimbDown,
// 	Jump,
// 	Use,
// 	NextItem,
// 	PreviousItem,
// }

// default_keyboard_bindings := [Binding]rl.KeyboardKey {
// 	.Left = .LEFT,
// 	.Right = .RIGHT,
// 	.ClimbDown = .DOWN,
// 	.Jump = .SPACE,
// 	.Use = .S,
// 	.NextItem = .D,
// 	.PreviousItem = .A,
// }

// default_gamepad_bindings := [Binding]rl.GamepadButton {
// 	.Left = .LEFT_FACE_LEFT,
// 	.Right = .LEFT_FACE_RIGHT,
// 	.ClimbDown = .RIGHT_FACE_RIGHT,
// 	.Jump = .RIGHT_FACE_DOWN,
// 	.Use = .RIGHT_FACE_LEFT,
// 	.PreviousItem = .LEFT_TRIGGER_1,
// 	.NextItem = .RIGHT_TRIGGER_1,
// }

// remove_inventory_item :: proc(item: PickupType) {
// 	for i, idx in g_mem.inventory.items {
// 		if i.item == item {
// 			all_actions := get_all_player_actions()

// 			if g_mem.selected_action == len(all_actions) - 1 {
// 				g_mem.selected_action -= 1
// 			}

// 			ordered_remove(&g_mem.inventory.items, idx)
// 			return
// 		}
// 	}
// }

// has_inventory_item :: proc(item: PickupType) -> bool {
// 	for i in g_mem.inventory.items {
// 		if i.item == item {
// 			return true
// 		}
// 	}

// 	return false
// }

// vec2_rot :: proc(v: Vec2, r: f32) -> Vec2 {
// 	cs := math.cos(r * rl.DEG2RAD)
// 	sn := math.sin(r * rl.DEG2RAD)
// 	return { v.x * cs - v.y * sn, v.x * sn + v.y * cs }
// }

// use_usable :: proc(u: EntityInst(Usable), remove_after_use := false) {
// 	remove_interactable := remove_after_use
// 	for au in u.actions {
// 		switch a in au {
// 			case ActionStartDialogue: {
// 				if e := get_entity_raw(a.entity); e != nil && e.dialogue_name != .None {
// 					start_dialogue(a.entity, e.dialogue_name, a.auto_advance)
// 				} else {
// 					e := a.entity

// 					if e == EntityHandleNone {
// 						e = g_mem.cat
// 					}

// 					start_dialogue(e, a.dialogue_name, a.auto_advance)
// 				}
// 			}

// 			case ActionPickup:
// 				pickup_item(a.entity)
// 				remove_interactable = true

// 			case ActionPlayAnimation:
// 				if anim, ok := get_entity(a.entity, AnimatedObject); ok {
// 					anim.playing = true
// 					anim.oneshot = a.oneshot
// 				}

// 			case ActionDisableCollision:
// 				remove_colliders_for_entity(world, a.entity)
// 				remove_interactable = true

// 			case ActionDeleteEntity:
// 				destroy_entity(world, a.entity)
// 				remove_interactable = true

// 			case ActionEnableEntity:
// 				enable_entity(world, a.entity)

// 			case ActionLoadLevel:
// 				g_mem.next_level_name = a.level_name
// 				g_mem.load_next_level = true

// 			case ActionMoveAlongSpline:
// 				target_interactable: bool

// 				if t := get_entity_raw(a.entity); t != nil {
// 					target_interactable = t.interactable
// 					t.interactable = false
// 				}

// 				e := Entity {
// 					variant = SplineEvaluator {
// 						target = a.entity,
// 						spline = a.spline,
// 						on_done = a.done_interactable,
// 						interactable_on_done = target_interactable,
// 					},
// 				}

// 				add_entity(world, e)

// 			case ActionPlayerJump:
// 				if cat, ok := get_entity(g_mem.cat, PlayerCat); ok {
// 					jump(cat)

// 					if a.override_velocity {
// 						cat.vel = a.velocity
// 					}
// 				}

// 			case ActionSetInteractionEnabled:
// 				if e := get_entity_raw(a.target); e != nil {
// 					e.interactable = a.enabled
// 				}

// 			case ActionFocusCamera:
// 			//    g_mem.camera_override = a.target
// 			//    g_mem.camera_override_time = a.time

// 		}
// 	}

// 	if remove_interactable {
// 		for ih, idx in g_mem.world.interactables {
// 			if ih == u.handle {
// 				unordered_remove(&g_mem.world.interactables, idx)
// 				break
// 			}
// 		}
// 		destroy_entity(world, u.handle)
// 	}
// }

// get_cat :: proc() -> (EntityInst(PlayerCat), bool) {
// 	return get_entity(g_mem.controlled_entity, PlayerCat)
// }

// in_trigger :: proc(p: EntityInst(PlayerCat), t: EntityInst(Trigger)) {
// 	if t.required_state != 0 && i64(t.required_state) != reflect.get_union_variant_raw_tag(p.state) {
// 		return
// 	}

// 	switch t.name {
// 		case .None, .OnionSpot, .NearSquirrel, .Unused, .ClimbHighVolume:

// 		case .SetCameraY:
// 			g_mem.camera_state.wanted_y = linalg.floor(rect_middle(trigger_world_rect(t)).y)

// 		case .UseInteractable:
// 			if e := get_entity_raw(t.target); e != nil && e.dialogue_name != .None {
// 				start_dialogue(e.handle, e.dialogue_name, false)
// 			}

// 			if p, ok := get_cat(); ok {
// 				if target, ok := get_entity(t.target, Usable); ok {
// 					use_usable(target)
// 				}
// 			}

// 		case .CameraVolume:
// 			if cur_civ, ok := g_mem.camera_state.mode.(CameraInVolume); ok {
// 				break
// 			}

// 			g_mem.camera_state.mode = CameraInVolume {
// 				volume = t.handle,
// 				start = g_mem.camera_state.pos,
// 				start_zoom = g_mem.camera_state.zoom,
// 			}


// 		case .CameraVolumeFit:
// 			if cur_civ, ok := g_mem.camera_state.mode.(CameraInVolume); ok {
// 				break
// 			}

// 			g_mem.camera_state.mode = CameraInVolume {
// 				volume = t.handle,
// 				start = g_mem.camera_state.pos,
// 				fit = true,
// 				start_zoom = g_mem.camera_state.zoom,
// 			}

// 		case .FadeOutEntity:
// 			if t.target != EntityHandleNone {
// 				send_event(EventFadeRenderable{entity = t.target, renderable = 0, fade_time = 1})
// 			}

// 		case .FlashButterPickup, .FlashTalk, .FlashButter:
// 	}

// 	if t.destroy_on_trigger {
// 		destroy_entity(world, t.handle)
// 	}
// }

// item_name := [PickupType]string {
// 	.None = "This is a bug!",
// 	.OnionSeed = "Onion Seed",
// 	.WaterBucket = "Water Bucket",
// 	.Egg = "Egg!",
// 	.Key = "Root cellar key",
// 	.Butter = "Butter!",
// 	.Flour = "Flour!",
// 	.BaseballBat = "Baseball Bat",
// 	.Unused = "This is a bug",
// 	.KluckePortrait = "Portrait of a Floof",
// 	.LakritsPortrait = "Enchanting Tuxedo Cat Portrait",
// 	.LillemorPortrait = "Portrait of a Fine Cat",
// 	.PontusPortrait = "Portrait of a gentleman",
// }

// cat_update :: proc(p: EntityInst(PlayerCat)) {
// 	profile_scope()

// 	p.nearest_grabpoint = get_nearest_grabpoint(world.grab_points[:], p)
// 	p.state_time += dt
// 	max_x_vel :: 80
// 	wallslide_x_fix_time :: 0.1

// 	affected_by_gravity := true

// 	def_collider := get_default_collider(p.pos)

// 	for th in g_mem.world.triggers {
// 		if te, ok := get_entity(th, Trigger); ok {
// 			trigger_rect := trigger_world_rect(te)

// 			if rl.CheckCollisionRecs(trigger_rect, def_collider) {
// 				if te.event != nil {
// 					send_event(te.event)
// 					destroy_entity(world, th)
// 				} else {
// 					in_trigger(p, te)
// 				}
// 			}
// 		}
// 	}

// 	profile_scope("cat state update")
// 	switch &s in p.state {
// 		case PlayerStateNormal:
// 			if p.grounded {
// 				s.has_touched_ground = true
// 			}

// 			if input.x != 0 {
// 				p.vel.x = input.x * max_x_vel
// 			} else if (p.grounded) {
// 				p.vel.x = 0
// 			}

// 			p.vel.x = clamp(p.vel.x, -max_x_vel, max_x_vel)

// 			if p.vel.x != 0 && !input.use {
// 				p.facing = p.vel.x > 0 ? .East : .West
// 			}

// 			if input.x == 0 {
// 				if s.anim != .Idle {
// 					p.anim = { anim = p.anim_idle}
// 					s.anim = .Idle
// 				}

// 				update_animation(&p.anim)
// 			} else {
// 				if s.anim != .Walk {
// 					play_sound_range(.Step0, .Step4)
// 					p.anim = { anim = p.anim_walk }
// 					s.anim = .Walk
// 				}
// 			}

// 			anim_speed := math.abs(input.x) > 0 ? math.abs(input.x) : 1

// 			if s.anim == .Walk && update_animation(&p.anim, speed_mult = smooth_stop2(anim_speed)) {
// 				play_sound_range(SoundName.Step0, SoundName.Step4)
// 			}

// 			if input.jump && s.has_touched_ground && (p.grounded || time.duration_seconds(time.since(p.last_grounded_at)) < 0.1) {
// 				if input.grab && !p.grounded {
// 					grabbed := try_grab(world, p)

// 					if grabbed {
// 						break
// 					}
// 				}

// 				jump(p)
// 				break
// 			}

// 			gp := p.nearest_grabpoint
// 			player_feet_collider := get_player_feet_collider(p)

// 			if rl.CheckCollisionPointRec(gp.pos, player_feet_collider) && is_hang_state_allowed(world, gp.pos, gp.compatible_facing) {
// 				if input.climb_down {
// 					p.vel = {}
// 					p.facing = gp.compatible_facing
// 					set_state(p, PlayerStateHang{ grab_pos = gp.pos })
// 					affected_by_gravity = false
// 					break
// 				}

// 				if abs(p.vel.x) < 1 {
// 					if gp.compatible_facing == .East && gp.pos.x > player_feet_collider.x + player_feet_collider.width*(1/2.0) {
// 						p.facing = gp.compatible_facing
// 						p.vel = {}
// 						set_state(p, PlayerStateHang{ grab_pos = gp.pos })
// 						affected_by_gravity = false
// 						break
// 					}

// 					if gp.compatible_facing == .West && gp.pos.x < player_feet_collider.x + player_feet_collider.width*(1/2.0) {
// 						p.facing = gp.compatible_facing
// 						p.vel = {}
// 						set_state(p, PlayerStateHang{ grab_pos = gp.pos })
// 						affected_by_gravity = false
// 						break
// 					}
// 				}
// 			}

// 			if input.use && len(g_mem.active_interactions) == 0 {
// 				all_actions := get_all_player_actions()

// 				if g_mem.selected_action < len(all_actions) {
// 					a := all_actions[g_mem.selected_action]
// 					iir := get_entity_raw(g_mem.interactable_in_range)

// 					if iir != nil {
// 						switch a.type {
// 							case .Inspect:
// 								if iir.kind == .Easel {
// 									t2 := iir.renderables[2].texture

// 									if t2 == get_texture_handle(.LakritsIdle) {
// 										g_mem.show_portrait = .Lakrits
// 										input.use = false
// 										break
// 									} else if t2 == get_texture_handle(.KluckeIdle) {
// 										g_mem.show_portrait = .Klucke
// 										input.use = false
// 										break
// 									} else if t2 == get_texture_handle(.LillemorIdle) {
// 										g_mem.show_portrait = .Lillemor
// 										input.use = false
// 										break
// 									} else if t2 == get_texture_handle(.PontusIdle) {
// 										g_mem.show_portrait = .Pontus
// 										input.use = false
// 										break
// 									}
// 								}

// 								if len(iir.examine_text) > 0 {
// 									say_single_line(g_mem.controlled_entity, iir.examine_text, flip_bubble = p.pos.x > iir.pos.x)
// 								} else if iir.pickup != .None {
// 									say_single_line(g_mem.controlled_entity, pickup_descriptions[iir.pickup])
// 								}
// 							case .UseItem:
// 								g_mem.disable_interaction_until = g_mem.time + 1
// 								handler := use_item_handlers[iir.use_item_handler]

// 								if handler != nil {
// 									handler(iir, a.item)
// 								} else {
// 									uih_default(iir, a.item)
// 								}

// 							case .Talk:
// 								if iir.dialogue_name != .None {
// 									p.vel = {}
// 									start_dialogue(g_mem.interactable_in_range, iir.dialogue_name, false)
// 								} else {
// 									if iir.pickup != .None {
// 										line := fmt.tprintf("Hello %s", item_name[iir.pickup])
// 										say_single_line(g_mem.controlled_entity, line, flip_bubble = p.pos.x > iir.pos.x)
// 									} else if iir.kind != .Legacy{
// 										dn := entity_kind_display_name(iir.kind)

// 										line := fmt.tprintf("Hello %v", dn != "" ? dn : to_sentence(fmt.tprint(iir.kind), capitalized = true))
// 										say_single_line(g_mem.controlled_entity, line, flip_bubble = p.pos.x > iir.pos.x)
// 									} else {
// 										say_single_line(g_mem.controlled_entity, "It doesn't look very talkative!", flip_bubble = p.pos.x > iir.pos.x)
// 									}
// 								}

// 							case .Pickup: {
// 								if iir.pickup != .None {
// 									pickup_item(iir.handle)
// 								} else if pickup_entity, ok := iir.variant.(Pickup); ok  {
// 									pickup_item(iir.handle)
// 								} else {
// 									say_single_line(g_mem.controlled_entity, "I can't pick that up!")
// 								}
// 							}
// 						}

// 						input.use = false
// 					} else {
// 						if a.type == .UseItem {
// 							if g_mem.show_portrait == nil {
// 								if a.item == .KluckePortrait {
// 									g_mem.show_portrait = .Klucke
// 									input.use = false
// 									break
// 								} else if a.item == .LakritsPortrait {
// 									g_mem.show_portrait = .Lakrits
// 									input.use = false
// 									break
// 								} else if a.item == .LillemorPortrait {
// 									g_mem.show_portrait = .Lillemor
// 									input.use = false
// 									break
// 								} else if a.item == .PontusPortrait {
// 									g_mem.show_portrait = .Pontus
// 									input.use = false
// 									break
// 								}
// 							}
// 						}
// 					}
// 				}
// 			}

// 		case PlayerStateInteracting:
// 			if len(g_mem.active_interactions) == 0 {
// 				set_state(p, PlayerStateNormal{})
// 			}

// 			for &ai in g_mem.active_interactions {
// 				switch &i in ai {
// 					case InteractionDialogue:
// 						if i.single_line != "" {
// 							break
// 						}

// 						if e := get_entity_raw(i.entity); e != nil {
// 							dir := Vec2 { e.facing == .West ? -1 : 1, 0}
// 							ipos := e.pos + e.interactable_offset
// 							if !e.interactable_dir_from_facing {
// 								dir = ipos.x - p.state_start_pos.x > 0 ? -1 : 1
// 							}
// 							target := ipos + dir * (e.interaction_position_offset == 0 ? 20 : e.interaction_position_offset)
// 							target.y = p.pos.y
// 							pos_to_target := target - p.pos

// 							if p.state_time <= 1 && linalg.length(pos_to_target) > 4 {
// 								if !s.started_walk {
// 									play_sound_range(SoundName.Step0, SoundName.Step4)
// 									p.anim = { anim = p.anim_walk }
// 									s.started_walk = true
// 									p.facing = pos_to_target.x > 0 ? .East : .West
// 								}

// 								p.pos = math.lerp(p.state_start_pos, target, p.state_time)

// 								anim_speed_mult := remap(abs(pos_to_target.x), 10, 40, 0.5, 1)

// 								if update_animation(&p.anim, speed_mult = anim_speed_mult) {
// 									play_sound_range(SoundName.Step0, SoundName.Step4)
// 								}
// 							} else {
// 								s.in_position = true
// 								ipos := e.pos + e.interactable_offset
// 								dir := ipos - p.pos
// 								p.facing = dir.x > 0 ? .East : .West
// 								p.anim = { anim = p.anim_idle}
// 							}
// 						} else {
// 							s.in_position = true
// 						}
// 				}
// 			}

// 		case PlayerStateDashing:
// 			p.vel = { (p.facing == .West ? -1 : 1) * 200, 0 }
// 			affected_by_gravity = false

// 			if p.state_time > 0.2 {
// 				set_state(p, PlayerStateNormal {})
// 				p.vel.x = clamp(p.vel.x, -40, 40)
// 				break
// 			}
// 		case PlayerStateHang:
// 			affected_by_gravity = false
// 			p.vel = {}

// 			if !s.transition_played {
// 				needed_pos := hang_state_grab_pos(s.grab_pos, p.facing)
// 				p.pos = math.lerp(p.state_start_pos, needed_pos, p.state_time / (f32(p.anim_jump_to_hang.num_frames) * p.anim_jump_to_hang.frame_length))

// 				if update_animation(&p.anim) {
// 					s.transition_played = true
// 					p.anim = { anim = p.anim_hang }
// 					p.pos = needed_pos
// 				}
// 			} else {
// 				if input.jump_held || input.y < 0 {
// 					set_state(p, PlayerStateHangClimb { start_pos = p.pos })
// 					break
// 				}

// 				if input.climb_down {
// 					set_state(p, PlayerStateWallSlide { transition_played = true })
// 					break
// 				}
// 			}
// 		case PlayerStateClimbing:
// 			affected_by_gravity = false
// 			in_climb_high_trigger := check_if_in_trigger(get_default_collider(p.pos), .ClimbHighVolume)
// 			max_climb_height: f32 = in_climb_high_trigger ? 56 : 38
// 			p.pos.x = math.lerp(p.state_start_pos.x, p.state_start_pos.x + s.wanted_x_offset, math.smoothstep(f32(0.0), f32(wallslide_x_fix_time), p.state_time))

// 			if !input.jump_held || math.abs(p.pos.y - p.last_grounded_pos.y) >= max_climb_height || !p.collides_in_front {
// 				set_state(p, PlayerStateWallSlide {
// 					cant_climb = true,
// 					transition_played = true,
// 					wanted_x_offset = p.facing == .West ? 0.01 : -0.01,
// 				})
// 				break
// 			}

// 			if p.collides_in_head {
// 				set_state(p, PlayerStateWallSlide {
// 					cant_climb = true,
// 					transition_played = true,
// 					wanted_x_offset = p.facing == .West ? 0.01 : -0.01,
// 				})
// 				break
// 			}

// 			p.vel.y = -30
// 			update_animation(&p.anim)

// 			if try_grab(world, p, true) {
// 				break
// 			}

// 		case PlayerStateWallSlide:
// 			p.vel.x = 0
// 			affected_by_gravity = false
// 			p.pos.x = math.lerp(p.state_start_pos.x, p.state_start_pos.x + s.wanted_x_offset, math.smoothstep(f32(0.0), f32(wallslide_x_fix_time), p.state_time))

// 			if try_grab(world, p, s.transition_played) {
// 				break
// 			}

// 			if !s.transition_played {
// 				if update_animation(&p.anim) {
// 					s.transition_played = true
// 					p.anim = { anim = p.anim_wallslide }
// 				}

// 				break
// 			}

// 			if input.jump_held && !s.cant_climb {
// 				set_state(p, PlayerStateClimbing{
// 					wanted_x_offset = s.wanted_x_offset - (p.pos.x - p.state_start_pos.x),
// 				})
// 				break
// 			}

// 			if !rl.IsSoundPlaying(s.sound) {
// 				s.sound = play_sound_range(.CatWallSlide1, .CatWallSlide2)
// 				rl.SetSoundPitch(s.sound, 0.65 )
// 			}

// 			p.anim = { anim = p.anim_wallslide }
// 			p.vel.y = 60
// 			update_animation(&p.anim)

// 			if !p.collides_in_front {
// 				set_state(p, PlayerStateWallslideToNormal {})
// 				break
// 			}
// 		case PlayerStateJumping:
// 			if p.collides_in_front && p.vel.y > 0 {
// 				grabbed := try_grab(world, p)

// 				if !grabbed {
// 					collider_diff := FrontColliderWidth - p.collides_in_front_overlap + 1
// 					p.pos.y += 5
// 					p.vel = {}
// 					set_state(p, PlayerStateWallSlide {
// 						wanted_x_offset = p.facing == .West ? -collider_diff: collider_diff,
// 					})
// 					break
// 				}
// 			}

// 			if update_animation(&p.anim) {
// 				s.charge_done = true
// 			}

// 			if s.charge_done {
// 				p.anim.cur_frame = 2
// 			}

// 			p.vel.x += input.x * dt * 300
// 			p.vel.x = clamp(p.vel.x, -max_x_vel, max_x_vel)

// 			if p.vel.y > 0 && ((p.facing == .East && (input.x > 0 || p.vel.x > 0.1)) || (p.facing == .West && (input.x < 0 || p.vel.x < -0.1)) || input.grab) {
// 				if try_grab(world, p) {
// 					affected_by_gravity = false
// 					break
// 				}
// 			}

// 			if p.grounded && s.charge_done {
// 				set_state(p, PlayerStateNormal { has_touched_ground = true })
// 				play_sound_range(.CatLanding0, .CatLanding1)
// 				break
// 			}
// 			/*
// 			// Air dash
// 			if input.dash {
// 				set_state(p, PlayerStateDashing {})
// 				break
// 			}
// 			*/
// 		case PlayerStateHangClimb:
// 			affected_by_gravity = false
// 			done := update_animation(&p.anim)

// 			cf := p.anim.cur_frame

// 			offsets := []Vec2 {
// 				{},
// 				{},
// 				{},
// 				{},
// 				{0,-1},
// 				{0,-3},
// 				{1,-5},
// 				{1,-6},
// 				{1,-14},
// 				{4,-17},
// 				{9,-15},
// 				{12,-13},
// 				{13,-13},
// 			}

// 			forward_collider := get_default_collider(s.start_pos)
// 			forward_collider.x += (p.facing == .West ? -1 : 1) * 20
// 			forward_collider.y -= 14
// 			velocity_allowed := true

// 			for c in world.colliders {
// 				if rl.CheckCollisionRecs(forward_collider, c.rect) {
// 					velocity_allowed = false
// 					p.vel = {}
// 					break
// 				}
// 			}

// 			if velocity_allowed && cf > 9 && ((input.x > 0 && p.facing == .East) || (input.x < 0 && p.facing == .West)){
// 				if input.x != 0 {
// 					p.vel.x += input.x * dt * 500
// 				} else {
// 					p.vel.x = 0
// 				}

// 				p.vel.x = clamp(p.vel.x, -max_x_vel, max_x_vel)
// 				s.velocity_offset += p.vel * dt

// 				if input.jump {
// 					jump(p)
// 					break
// 				}
// 			}

// 			if done {
// 				cf = p.anim_hangclimb.num_frames - 1
// 			}

// 			o1 := offsets[cf]
// 			o2 := cf < 12 ? offsets[cf + 1] : offsets[cf]

// 			frame_timer := min(p.anim.frame_timer, p.anim.frame_length)
// 			p.pos = s.start_pos + s.velocity_offset + math.lerp(o1, o2, (p.anim.frame_length - frame_timer) / p.anim.frame_length) * Vec2{p.facing == .West ? -1 : 1, 1}

// 			if done {
// 				p.grounded = true
// 				set_state(p, PlayerStateNormal {})
// 			}

// 		case PlayerStateSlaping, PlayerStateBaseballin:
// 			done := update_animation(&p.anim)

// 			if done {
// 				set_state(p, PlayerStateNormal {})
// 			}

// 		case PlayerStateFloating:
// 			affected_by_gravity = false

// 		case PlayerStateFloatingToEnd:
// 			affected_by_gravity = false

// 			p.vel.y -= dt

// 			if p.vel.y < -70 {
// 				p.vel.y = -70
// 			}

// 			if sqr := get_entity_raw(s.squirrel); sqr != nil {
// 				sqr.pos += p.vel * dt
// 				st := remap(p.state_time, 4, 15, 0, 1)
// 				sqr.pos.x = math.lerp(s.squirrel_pos_x_start, p.pos.x + 20, mix(smooth_start2, smooth_stop2, st, st))
// 			}

// 			g_mem.camera_state.pos += ((p.pos - {0, 20}) - g_mem.camera_state.pos) * dt * 3

// 			if p.state_time > 3 && !s.line1_said {
// 				say_single_line(s.squirrel, "Here we go!")
// 				s.line1_said = true
// 			}

// 			if p.state_time > 7 && !s.line2_said {
// 				say_single_line(p.handle, "Pancake, pancake! PANCAKE!")
// 				s.line2_said = true
// 			}

// 			if p.state_time > 19 && !s.line3_said {
// 				say_single_line(p.handle, "I can see my house from here")
// 				s.line3_said = true
// 			}

// 			f_len :: 1
// 			f1_start :: 21
// 			f2_start :: 23
// 			if p.state_time > f1_start {
// 				f1 := remap(p.state_time, f1_start, f1_start+f_len, 0, 1)
// 				g_mem.clear_color = lerp_color(ColorSky, ColorLight, f1)

// 				if p.state_time > f1_start+f_len && !s.removed_clouds {
// 					for c in world.clouds {
// 						destroy_entity(world, c.entity)
// 					}
// 					clear(&world.clouds)
// 					s.removed_clouds = true
// 				}

// 				if p.state_time > f2_start {
// 					f2 := remap(p.state_time, f2_start, f2_start+f_len, 0, 1)
// 					g_mem.clear_color = lerp_color(ColorLight, ColorMediumDark, f2)
// 				}

// 				if p.state_time > f2_start+f_len {
// 					g_mem.next_level_name = .SpaceHouse
// 					g_mem.load_next_level = true
// 					break
// 				}
// 			}

// 		case PlayerStateFloatingToKitchen:
// 			affected_by_gravity = false

// 			if p.state_time > 1 {
// 				f2 := remap(p.state_time, 1, 2, 0, 1)
// 				g_mem.clear_color = lerp_color(ColorMediumDark, ColorDark, f2)
// 			}

// 			if !s.lerp_started {
// 				s.lerp_started = true
// 				s.lerp_start = p.pos
// 				g_mem.camera_state.pos = {-59 - 10, 78 - 34}
// 				g_mem.camera_state.wanted_y = g_mem.camera_state.pos.y

// 				if sqr := get_entity_raw(s.squirrel); sqr != nil {
// 					s.sqr_lerp_start = sqr.pos
// 				}
// 			}

// 			target_cat := Vec2 { -90, -136 }
// 			camera_target_x := target_cat.x

// 			lerpt := math.smoothstep(f32(0), f32(10), p.state_time)
// 			p.pos = math.lerp(s.lerp_start, target_cat, lerpt)

// 			if sqr := get_entity_raw(s.squirrel); sqr != nil {
// 				target_sqr := Vec2 { -20, -135 }
// 				sqr.pos = math.lerp(s.sqr_lerp_start, target_sqr, lerpt)
// 				camera_target_x += target_sqr.x
// 				camera_target_x /= 2
// 			}


// 			if p.state_time > 10 {
// 				set_state(p, PlayerStateNormal{})
// 				g_mem.controlled_entity = p.handle
// 				g_mem.camera_state.mode = CameraLocked{}
// 				break
// 			}

// 			g_mem.camera_state.pos += (Vec2{camera_target_x, p.pos.y - 20} - g_mem.camera_state.pos) * dt
// 			g_mem.camera_state.wanted_y = g_mem.camera_state.pos.y

// 		case PlayerStateEnterEnd:
// 			p.vel = {}
// 			affected_by_gravity = false
// 			g_mem.camera_state.pos = p.pos

// 			spl, spl_ok := get_entity(s.player_spline, Spline)

// 			if spl_ok {
// 				camera_end := spline_last_point(spl)
// 				g_mem.camera_state.pos = math.lerp(s.camera_start_pos, camera_end, math.smoothstep(f32(0), 1.4, p.state_time))
// 				p.rot = math.lerp(f32(0), -20, math.smoothstep(f32(0.5), 1.1, p.state_time))
// 			}

// 			if p.state_time > 0.8 {
// 				g_mem.controlled_entity = EntityHandleNone
// 				t := remap(p.state_time, 0.8, 1.7, 0, 1)
// 				t5 := t * t * t * t * t
// 				g_mem.camera_state.zoom = math.lerp(s.start_zoom, default_game_camera_zoom()*100, t5)
// 			}

// 			if p.state_time > 2.5 {
// 				g_mem.next_level_name = .PancakeBatterLand
// 				g_mem.load_next_level = true
// 			}

// 		case PlayerStateButterCharge:
// 			affected_by_gravity = false

// 			p.vel = {}
// 			dir: f32 = p.facing == .East ? 1 : -1

// 			if update_animation(&p.anim) {
// 				p.pos = p.state_start_pos + {s.start_offset + dir*74, 0}
// 				set_state(p, PlayerStateNormal{})
// 			} else if p.state_time > 1 {
// 				t := remap(p.state_time, 1.7, 2.0, 0, 1)
// 				p.pos = math.lerp(p.state_start_pos, p.state_start_pos + {s.start_offset, 0 }, t)
// 			}

// 		case PlayerStateWallslideToNormal:
// 			done := update_animation(&p.anim)

// 			if done {
// 				set_state(p, PlayerStateNormal {})
// 			}

// 		case PlayerStateOneShotAnim:
// 			if p.state_time < s.delay {
// 				break
// 			}

// 			if s.walk_to_target_x && !s.walk_done {
// 				pos_to_target := s.target_x - p.pos.x

// 				if !s.started_walk {
// 					play_sound_range(SoundName.Step0, SoundName.Step4)
// 					p.anim = { anim = p.anim_walk }
// 					s.started_walk = true
// 					s.end_facing = p.facing
// 					p.facing = pos_to_target > 0 ? .East : .West
// 				}

// 				p.pos = math.lerp(p.state_start_pos, Vec2{s.target_x, p.pos.y}, p.state_time)

// 				anim_speed_mult := remap(abs(pos_to_target), 10, 40, 0.5, 1)

// 				if update_animation(&p.anim, speed_mult = anim_speed_mult) {
// 					play_sound_range(SoundName.Step0, SoundName.Step4)
// 				}

// 				if p.state_time >= 1 || math.abs(pos_to_target) < 2 {
// 					s.walk_done = true
// 					p.facing = s.end_facing

// 					if m, ok := s.manual_end_facing.?; ok {
// 						p.facing = m
// 					}

// 					p.pos.x = s.target_x
// 					p.vel = {}
// 					p.anim = { anim = s.anim }
// 				}

// 				break
// 			}

// 			done := update_animation(&p.anim)

// 			if done {
// 				if s.end_event != nil {
// 					do_event(s.end_event)
// 				}

// 				set_state(p, PlayerStateNormal {})
// 			}

// 		case PlayerStateExternallyControlled: {
// 			affected_by_gravity = false
// 		}
// 	}

// 	profile_end()

// 	if p.vel.x != 0 {
// 		p.facing = p.vel.x > 0 ? .East : .West
// 	}

// 	p.prev_pos = p.pos

// 	if p.grounded {
// 		p.last_grounded_at = time.now()
// 		p.last_grounded_pos = p.pos
// 	}

// 	p.physics_t += dt

// 	// 90 fps: dt is 0.011 s

// 	physics_dt :: 1.0/60.0 /// 0.016s

// 	profile_start("cat physics")

// 	previous_pos := p.pos

// 	if p.physics_t > physics_dt {
// 		p.collides_in_front = false
// 		p.collides_in_head = false
// 		p.collides_in_feet = false
// 		p.grounded = false

// 		for p.physics_t > physics_dt {
// 			previous_pos = p.pos

// 			if affected_by_gravity {
// 				p.vel.y += physics_dt * 1000
// 			}

// 			{
// 				p.pos.y += p.vel.y * physics_dt
// 				player_collider := get_player_collider(p.pos, &p.state)

// 				for c in world.colliders {
// 					r := c.rect
// 					col := rl.GetCollisionRec(player_collider, r)

// 					if col.height != 0 {
// 						sign: f32 = player_collider.y + player_collider.height / 2 < (r.y + r.height / 2) ? -1 : 1

// 						if c.one_direction && sign > 0 {
// 							continue
// 						}

// 						if !c.one_direction || (sign < 0 && p.vel.y > 0) {
// 							p.vel.y = 0
// 						}

// 						fix := col.height * sign
// 						p.pos.y += fix

// 						if fix < 0 {
// 							p.grounded = true
// 						}
// 						break
// 					}
// 				}
// 			}

// 			{
// 				p.pos.x += p.vel.x * physics_dt
// 				player_collider := get_player_collider(p.pos, &p.state)
// 				player_front_collider := get_player_front_collider(p)
// 				player_head_collider := get_player_head_collider(p)
// 				player_feet_collider := get_player_feet_collider(p)

// 				for c in world.colliders {
// 					r := c.rect
// 					col := rl.GetCollisionRec(player_collider, r)
// 					fix: f32

// 					if col.width != 0 && !c.one_direction {
// 						sign: f32 = player_collider.x + player_collider.width / 2 < (r.x + r.width / 2) ? -1 : 1
// 						fix = col.width * sign
// 						p.pos.x += fix
// 						p.vel.x = 0
// 					}

// 					col_front := rl.GetCollisionRec(player_front_collider, r)

// 					if col_front.width != 0 && !c.one_direction {
// 						p.collides_in_front = true
// 						p.collides_in_front_overlap = col_front.width - abs(fix)
// 					}

// 					col_head := rl.GetCollisionRec(player_head_collider, r)

// 					if col_head.height != 0 && !c.one_direction {
// 						p.collides_in_head = true
// 					}

// 					col_feet := rl.GetCollisionRec(player_feet_collider, r)

// 					if col_feet.height != 0 {
// 						p.collides_in_feet = true

// 						#partial switch &s in p.state {
// 							case PlayerStateWallSlide:
// 								p.pos.y -= 2
// 								p.pos.x += p.facing == .West ? 2 : -2
// 								set_state(p, PlayerStateWallslideToNormal {})
// 						}
// 					}
// 				}
// 			}

// 			p.physics_t -= physics_dt
// 		}
// 	}

// 	physics_blend_t := p.physics_t / f32(physics_dt)
// 	p.render_pos = math.lerp(previous_pos, p.pos, physics_blend_t)

// 	profile_end()

// 	if g_mem.controlled_entity == p.handle {
// 		when CAT_DEV {
// 			if rl.IsKeyPressed(.L) {
// 				p.lock_camera = !p.lock_camera
// 			}
// 		}

// 		if p.lock_camera == false {
// 			update_camera(p.vel.x)
// 		} else {
// 			cam_movement: Vec2

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

// 			if cam_movement.x != 0 || cam_movement.y != 0 {
// 				g_mem.camera_state.pos += cam_movement * dt * 150
// 			}
// 		}
// 	}

// 	p.num_renderables = 1
// 	p.renderables[0] = {
// 		texture = p.anim.anim.texture,
// 		rect = animation_rect(&p.anim, p.facing == .West),
// 		offset = p.anim.offset,
// 	}

// 	if p.facing == .West {
// 		p.renderables[0].offset.x *= -1
// 	}
// }

// DelayedEvent :: struct {
// 	event: Event,
// 	delay: f32,
// }

// EventCatEnterRocket :: struct {}
// EventReleaseHang :: struct {}
// EventGotOnionSeed :: struct {}
// EventGotEgg :: struct {}
// EventFlyToBookShelf :: struct {}

// EventSetProgressFlag :: struct {
// 	flag: ProgressFlag,
// }

// EventGetItem :: struct {
// 	from_pos: Vec2,
// 	has_from_pos: bool,
// 	item: PickupType,
// }
// EventAngryDoorOpened :: struct{
// 	door: EntityHandle,
// }

// EventTalkToEntity :: struct {
// 	entity: EntityHandle,
// 	auto_advance: bool,
// }

// EventSaySingleLine :: struct {
// 	entity: EntityHandle,
// 	line: string,
// 	no_sound: bool,
// }

// EventAnimateAlongSpline :: struct {
// 	entity: EntityHandle,
// 	spline: EntityHandle,
// }

// EventCatEnterRocketInFrontOfOak :: struct{}

// EventRocketSplineDone :: struct {
// 	spline: EntityHandle,
// }

// EventAcornOpen :: struct {
// }

// EventCatEnterRocketInSpace :: struct{}

// EventEndAcornSpace :: struct {}

// EventFloatIntoAir :: struct {}

// EventFlyOutFromPlanet :: struct {}

// EventTeleportEntity :: struct {
// 	entity: EntityHandle,
// 	target: EntityHandle, // just used for position
// }

// EventHideRenderable :: struct {
// 	entity: EntityHandle,
// 	renderable: int,
// }

// EventFadeRenderable :: struct {
// 	entity: EntityHandle,
// 	renderable: int,
// 	fade_time: f32,
// 	fade_in: bool,
// }

// FadingRenderable :: struct {
// 	entity: EntityHandle,
// 	renderable: int,
// 	fade_start: f64,
// 	fade_time: f32,
// 	fade_start_color: rl.Color,
// 	started: bool,
// 	fade_in: bool,
// }

// EventRemoveColliderAndAnimate :: struct {
// 	entity: EntityHandle,
// 	renderable: int,
// }

// EventStartAnimating :: struct {
// 	entity: EntityHandle,
// 	renderable: int,
// }

// EventCheckIfAllPortraitsHung :: struct {

// }

// EventJumpIntoBatter :: struct {

// }

// EventPlaySound :: struct {
// 	sound: SoundName,
// }

// EventFadePortraitToCat :: struct {
// 	portrait: Portrait,
// 	easel: EntityHandle,
// }

// EventStartEnd :: struct {}

// EventOpenCave :: struct {}

// EventFadeEntityWithTag :: struct {
// 	tag: Tag,
// }

// EventDestroyEntityWithTag :: struct {
// 	tag: Tag,
// }

// EventSetRenderable :: struct {
// 	entity: EntityHandle,
// 	renderable_idx: int,
// 	renderable: EntityRenderable,
// }

// EventFlourThrown :: struct {
// 	wall: EntityHandle,
// }

// EventFadeOutMusic :: struct {}

// Event :: union {
// 	EventAngryDoorOpened,
// 	EventCatEnterRocket,
// 	EventReleaseHang,
// 	EventGotOnionSeed,
// 	EventGotEgg,
// 	EventFlyToBookShelf,
// 	EventSetProgressFlag,
// 	EventTalkToEntity,
// 	EventGetItem,
// 	EventSaySingleLine,
// 	EventAnimateAlongSpline,
// 	EventCatEnterRocketInFrontOfOak,
// 	EventRocketSplineDone,
// 	EventAcornOpen,
// 	EventCatEnterRocketInSpace,
// 	EventEndAcornSpace,
// 	EventFloatIntoAir,
// 	EventFlyOutFromPlanet,
// 	EventTeleportEntity,
// 	EventHideRenderable,
// 	EventFadeRenderable,
// 	EventRemoveColliderAndAnimate,
// 	EventStartAnimating,
// 	EventCheckIfAllPortraitsHung,
// 	EventJumpIntoBatter,
// 	EventPlaySound,
// 	EventFadePortraitToCat,
// 	EventStartEnd,
// 	EventOpenCave,
// 	EventFadeEntityWithTag,
// 	EventDestroyEntityWithTag,
// 	EventSetRenderable,
// 	EventFlourThrown,
// 	EventFadeOutMusic,
// 	EventPutSeedInSoil,
// 	EventFadeOutBird,
// 	EventEggShake,
// }

// EventEggShake :: struct {}

// EventFadeOutBird :: struct {}

// add_clouds :: proc() {
// 	clouds := find_entities_with_tag(.Cloud)

// 	for ch in clouds {
// 		c := Cloud {
// 			entity = ch,
// 			vel = {f32(rl.GetRandomValue(80, 120))/100.0, 0},
// 		}

// 		append(&world.clouds, c)
// 	}

// 	far_clouds := find_entities_with_tag(.FarCloud)

// 	for ch in far_clouds {
// 		c := Cloud {
// 			entity = ch,
// 			vel = {f32(rl.GetRandomValue(80, 120))/300.0, 0},
// 		}

// 		append(&world.clouds, c)
// 	}
// }

// renderable_update_rect :: proc(r: ^EntityRenderable) {
// 	tex := get_texture(r.texture)

// 	rect := rl.Rectangle {
// 		x = linalg.floor(f32(r.cur_frame * int(tex.width)/r.num_frames)),
// 		y = 0,
// 		width = f32(int(tex.width)/r.num_frames),
// 		height = f32(tex.height),
// 	}

// 	r.rect = rect
// }

// post_level_load :: proc(restarting_level: bool) {
// 	switch g_mem.level_name {
// 		case .MainMenu:
// 			add_clouds()
// 			world.clouds_start_x = -250
// 			world.clouds_max_x = 330
// 			g_mem.clear_color = ColorSky
// 			g_mem.camera_state = {
// 				zoom = default_game_camera_zoom(),
// 				mode = CameraLocked {},
// 			}
// 		case .Planet:
// 			add_clouds()
// 			world.clouds_start_x = -800
// 			world.clouds_max_x = 1600

// 			g_mem.next_controlled_entity = g_mem.cat
// 			g_mem.controlled_entity = g_mem.cat
// 			g_mem.camera_state.zoom = default_game_camera_zoom()
// 			g_mem.clear_color = ColorSky

// 			if get_progress(.SpaceEnded) {
// 				destroy_entity(world, g_mem.cat)
// 				g_mem.cat = EntityHandleNone
// 				g_mem.controlled_entity = EntityHandleNone
// 				r := create_entity_from_entity_kind(.Rocket)
// 				r.layer = 4

// 				rv := &r.variant.(Rocket)
// 				r.renderables[0] = animated_renderable(.SpaceOnionTalk, 0.15, is_animating = false, animate_when_interacted_with = true )
// 				rv.state = .ExternallyControlledCameraFollow
// 				return_spline := find_entity_with_tag(.ReturnToPlanetSpline)

// 				if s, ok := get_entity(return_spline, Spline); ok {
// 					p := spline_first_point(s)
// 					g_mem.camera_state.pos = p
// 					r.pos = p
// 				}

// 				rv.cat_inside = true
// 				rv.cat_inside_time = 0
// 				g_mem.rocket = add_entity(world, r)

// 				spl := Entity {
// 					variant = SplineEvaluator {
// 						target = g_mem.rocket,
// 						spline = return_spline,
// 						interactable_on_done = true,
// 						camera_follow = true,
// 					},
// 				}

// 				add_entity(world, spl)

// 				if has_inventory_item(.LakritsPortrait) {
// 					west_walls := find_entities_with_tag(.PlanetWestWalls)

// 					for w in west_walls {
// 						make_rock_wall_floured(w)
// 					}
// 				}

// 				make_rock_wall_floured(find_entity_with_tag(.PlanetEastWall))

// 				remove := find_entities_with_tag(.RemoveWhenComingFromSpace)

// 				for r in remove {
// 					destroy_entity(world, r)
// 				}

// 				destroy_entity(world, find_entity_with_tag(.RootCellarBlocker))
// 				destroy_entity(world, find_entity_of_kind(.Egg))
// 				destroy_entity(world, find_entity_of_kind(.Butter))
// 				destroy_entity(world, find_entity_of_kind(.BaseballBat))
// 				destroy_entity(world, find_entity_of_kind(.Butter))

// 				if has_inventory_item(.KluckePortrait) {
// 					destroy_entity(world, find_entity_of_kind(.KluckePortrait))

// 					if ho := get_entity_raw(find_entity_of_kind(.HiddenOpening)); ho != nil {
// 						ho.renderables[1] = {}
// 					}
// 				}

// 				if has_inventory_item(.LakritsPortrait) {
// 					destroy_entity(world, find_entity_of_kind(.LakritsPortrait))
// 				}

// 				rcd := find_entity_of_kind(.RootCellarDoor)

// 				if rcde := get_entity_raw(rcd); rcde != nil {
// 					open_root_cellar_door(rcde)
// 				}

// 				before := find_entities_with_tag(.BeforeEgg)

// 				for b in before {
// 					disable_entity(b)
// 				}

// 				after := find_entities_with_tag(.AfterEgg)

// 				for a in after {
// 					if e := get_entity_raw(a); e != nil {
// 						if e.kind == .OnionSeed {
// 							continue
// 						}
// 					}

// 					enable_entity(&g_mem.world, a)
// 				}

// 				on_pickup := find_entities_with_tag(.OnOnionPickup)

// 				for op in on_pickup {
// 					enable_entity(world, op)

// 					if e := get_entity_raw(op); e != nil {
// 						e.interactable = false
// 					}
// 				}

// 				ent_iter := ha_make_iter(g_mem.world.entities)
// 				for e, eh in ha_iter_ptr(&ent_iter) {
// 					if v, ok := e.variant.(Trigger); ok && v.name == .FlashButterPickup {
// 						destroy_entity(world, eh)
// 						break
// 					}
// 				}

// 				ent_iter = ha_make_iter(g_mem.world.entities)
// 				for e, eh in ha_iter_ptr(&ent_iter) {
// 					if v, ok := e.variant.(Trigger); ok && v.name == .FlashTalk {
// 						destroy_entity(world, eh)
// 						break
// 					}
// 				}

// 				ent_iter = ha_make_iter(g_mem.world.entities)
// 				for e, eh in ha_iter_ptr(&ent_iter) {
// 					if v, ok := e.variant.(Trigger); ok && v.name == .FlashButter {
// 						destroy_entity(world, eh)
// 						break
// 					}
// 				}


// 				if soil := get_entity_raw(find_entity_of_kind(.Soil)); soil != nil {
// 					soil.interactable = false
// 				}

// 				if ft := get_entity_raw(find_entity_of_kind(.FlourTree)); ft != nil {
// 					ft.renderables[1].cur_frame = ft.renderables[1].num_frames - 1
// 					ft.renderables[2].cur_frame = ft.renderables[2].num_frames - 1
// 					renderable_update_rect(&ft.renderables[1])
// 					renderable_update_rect(&ft.renderables[2])
// 				}

// 				open_cave()

// 				oak := find_entity_with_tag(.Oak)

// 				if o := get_entity_raw(oak); o != nil {
// 					oak_tex := get_texture_by_name(.OakBase)
// 					stump_tex := get_texture_by_name(.Stump2)
// 					diff := oak_tex.height - stump_tex.height
// 					o.renderables[0] = { texture = get_texture_handle(.Stump2) }
// 					o.pos.y += f32(diff/2)
// 				}
// 				g_mem.save.checkpoint = .PlanetBack
// 				g_mem.hide_hud = false
// 			} else if get_progress(.GotEgg) {
// 				egg := find_entity_of_kind(.Egg)

// 				if cat := get_entity_raw(g_mem.cat); cat != nil {
// 					cat.pos = entity_pos(egg)
// 				}

// 				destroy_entity(world, egg)

// 				if has_inventory_item(.LakritsPortrait) {
// 					west_walls := find_entities_with_tag(.PlanetWestWalls)

// 					for w in west_walls {
// 						make_rock_wall_floured(w)
// 					}
// 				}

// 				make_rock_wall_floured(find_entity_with_tag(.PlanetEastWall))
// 				destroy_entity(world, find_entity_of_kind(.Butter))
// 				destroy_entity(world, find_entity_of_kind(.BaseballBat))
// 				destroy_entity(world, find_entity_of_kind(.Butter))

// 				if has_inventory_item(.KluckePortrait) {
// 					destroy_entity(world, find_entity_of_kind(.KluckePortrait))

// 					if ho := get_entity_raw(find_entity_of_kind(.HiddenOpening)); ho != nil {
// 						ho.renderables[1] = {}
// 					}
// 				}

// 				if has_inventory_item(.LakritsPortrait) {
// 					destroy_entity(world, find_entity_of_kind(.LakritsPortrait))
// 				}

// 				ent_iter := ha_make_iter(g_mem.world.entities)
// 				for e, eh in ha_iter_ptr(&ent_iter) {
// 					if v, ok := e.variant.(Trigger); ok && v.name == .FlashButterPickup {
// 						destroy_entity(world, eh)
// 						break
// 					}
// 				}

// 				ent_iter = ha_make_iter(g_mem.world.entities)
// 				for e, eh in ha_iter_ptr(&ent_iter) {
// 					if v, ok := e.variant.(Trigger); ok && v.name == .FlashTalk {
// 						destroy_entity(world, eh)
// 						break
// 					}
// 				}

// 				ent_iter = ha_make_iter(g_mem.world.entities)
// 				for e, eh in ha_iter_ptr(&ent_iter) {
// 					if v, ok := e.variant.(Trigger); ok && v.name == .FlashButter {
// 						destroy_entity(world, eh)
// 						break
// 					}
// 				}


// 				if ft := get_entity_raw(find_entity_of_kind(.FlourTree)); ft != nil {
// 					ft.renderables[1].cur_frame = ft.renderables[1].num_frames - 1
// 					ft.renderables[2].cur_frame = ft.renderables[2].num_frames - 1
// 					renderable_update_rect(&ft.renderables[1])
// 					renderable_update_rect(&ft.renderables[2])
// 				}

// 				got_egg_change_world()
// 				open_cave()
// 				g_mem.save.checkpoint = .PlanetGotEgg
// 				g_mem.hide_hud = false
// 			} else {
// 				// dialogue tutorials
// 				world.diag_tutorial_advance_counter = 3
// 				world.diag_tutorial_choice_counter = 2

// 				destroy_entity(world, find_entity_with_tag(.RootCellarHatch))
// 				g_mem.save.checkpoint = .Planet

// 				if !restarting_level {
// 					g_mem.hide_hud = true

// 					set_camera_volume_pos()

// 					g_mem.next_controlled_entity = EntityHandleNone
// 					g_mem.controlled_entity = EntityHandleNone

// 					if cat, ok := get_entity(g_mem.cat, PlayerCat); ok {
// 						set_state(cat, PlayerStateExternallyControlled{})
// 						cat.anim = { anim = cat.anim_wakeup }
// 					}

// 					set_game_state(GameStateIntroTransition{wanted_camera_pos = g_mem.camera_state.pos})
// 				}
// 			}

// 		case .House:
// 			add_clouds()
// 			world.clouds_start_x = -783
// 			world.clouds_max_x = 1433

// 			g_mem.next_controlled_entity = g_mem.rocket
// 			g_mem.controlled_entity = g_mem.rocket
// 			g_mem.camera_state.zoom = default_game_camera_zoom() * 100
// 			g_mem.clear_color = ColorOrange

// 			set_progress(.HideTutorialStuff)

// 			if r, ok := get_entity(g_mem.rocket, Rocket); ok {
// 				r.renderables[0] = animated_renderable(.SpaceOnionTalk, 0.15, is_animating = false, animate_when_interacted_with = true )
// 				if get_progress(.RocketLanded){
// 					ls := find_entity_with_tag(.RocketLandingSpline)
// 					if ls, ok := get_entity(ls, Spline); ok{
// 						if len(ls.points) >= 2{
// 							rocket_spline_done(r, ls, false)
// 						}
// 					}
// 				} else {
// 					r.state = .LeavingPlanet
// 					r.cat_inside = true
// 					play_sound_alias(.RocketEngineStatic)
// 				}
// 			}

// 			g_mem.save.checkpoint = .OtherPlace
// 			g_mem.hide_hud = false

// 		case .Space:
// 			g_mem.next_controlled_entity = g_mem.cat
// 			g_mem.controlled_entity = g_mem.cat
// 			g_mem.camera_state.zoom = default_game_camera_zoom()
// 			g_mem.clear_color = ColorDark

// 			if r, ok := get_entity(g_mem.rocket, Rocket); ok {
// 				r.renderables[0] = animated_renderable(.SpaceOnionTalk, 0.15, is_animating = false, animate_when_interacted_with = true )
// 			}

// 			set_progress(.InSpace)

// 			g_mem.save.checkpoint = .Space
// 			g_mem.hide_hud = false

// 		case .SpaceHouse:
// 			g_mem.next_controlled_entity = EntityHandleNone
// 			g_mem.controlled_entity = EntityHandleNone
// 			g_mem.camera_state.zoom = default_game_camera_zoom()
// 			g_mem.clear_color = ColorMediumDark

// 			if c, ok := get_entity(g_mem.cat, PlayerCat); ok {
// 				set_state(c, PlayerStateFloatingToKitchen{})
// 			}

// 			set_progress(.InSpaceHouse)
// 			g_mem.save.checkpoint = .SpaceHouse
// 			g_mem.hide_hud = false

// 		case .PancakeBatterLand:
// 			g_mem.next_controlled_entity = EntityHandleNone
// 			g_mem.controlled_entity = EntityHandleNone
// 			g_mem.camera_state.zoom = default_game_camera_zoom()
// 			g_mem.clear_color = ColorCat

// 			if c, ok := get_entity(g_mem.cat, PlayerCat); ok {
// 				set_state(c, PlayerStateFloating{})
// 				g_mem.camera_state.pos = c.pos
// 			}

// 			if !restarting_level {
// 				entering_pbl_start(g_mem.cat)
// 			} else {
// 				g_mem.next_controlled_entity = g_mem.cat
// 			}

// 			g_mem.save.checkpoint = .PancakeBatterLand
// 			g_mem.hide_hud = false
// 		case .IntroDream:
// 			g_mem.clear_color = ColorCat
// 			cloud := find_entity_with_tag(.IntroCloud)
// 			squirrel := find_entity_with_tag(.IntroSquirrel)

// 			spl := Entity {
// 				variant = SplineEvaluator {
// 					target = cloud,
// 					spline = find_entity_with_tag(.IntroCloudSpline),
// 				},
// 			}

// 			add_entity(world, spl)

// 			set_game_state(GameStateIntro{ cloud = cloud, squirrel = squirrel})
// 			g_mem.save.checkpoint = .Intro
// 			g_mem.hide_hud = true
// 	}

// 	set_camera_volume_pos()
// }

// set_camera_volume_pos :: proc() {
// 	if ce := get_entity_raw(g_mem.controlled_entity); ce != nil {
// 		g_mem.camera_state.pos = ce.pos
// 		coll := get_default_collider(ce.pos)

// 		for th in g_mem.world.triggers {
// 			if te, ok := get_entity(th, Trigger); ok {
// 				if te.name == .CameraVolume || te.name == .SetCameraY  {
// 					trigger_rect := trigger_world_rect(te)

// 					if rl.CheckCollisionRecs(trigger_rect, coll) {
// 						g_mem.camera_state.wanted_y = linalg.floor(rect_middle(trigger_rect).y)
// 						g_mem.camera_state.pos.y = g_mem.camera_state.wanted_y

// 						if te.name == .CameraVolume {
// 							target := linalg.floor(rect_middle(trigger_rect))
// 							g_mem.camera_state.pos = target
// 						}
// 					}
// 				}
// 			}
// 		}
// 	}
// }

// SerializedState :: struct {
// 	entity_types: json.Value,
// 	level: json.Value,
// 	dialogue_trees: json.Value,
// }

// clone_serialized_state :: proc(ss_in: SerializedState, loc := #caller_location) -> SerializedState {
// 	return {
// 		level = json.clone_value(ss_in.level),
// 		entity_types = json.clone_value(ss_in.entity_types),
// 		dialogue_trees = json.clone_value(ss_in.dialogue_trees),
// 	}
// }

// delete_serialized_state :: proc(s: SerializedState) {
// 	json.destroy_value(s.entity_types)
// 	json.destroy_value(s.level)
// 	json.destroy_value(s.dialogue_trees)
// }

// EntityTypesFilename :: "entity_types.cat_entity_types"

// DialoguesFilename :: "dialogues.cat_dialogues"

// load_level :: proc(level_name: LevelName) {
// 	level_filename := level_filename_from_level_name(level_name)

// 	if len(level_filename) == 0 {
// 		log.error("Failed bad level filename")
// 		return
// 	}

// 	set_game_state(GameStateDefault{})
// 	g_mem.camera_state = {
// 		zoom = default_game_camera_zoom(),
// 	}

// 	entity_types_json, entity_types_json_ok := load_entity_types_data()

// 	if !entity_types_json_ok {
// 		log.error("Failed to load %v", EntityTypesFilename)
// 		return
// 	}

// 	p := json.make_parser(entity_types_json, .Bitsquid, true)
// 	entity_types, entity_types_err := json.parse_array(&p)

// 	if entity_types_err != .None {
// 		log.error("Failed to parse %v", EntityTypesFilename)
// 		return
// 	}

// 	level_json, level_json_ok := load_level_data(level_name)

// 	if !level_json_ok {
// 		log.error("Failed to load %v", level_name)
// 		json.destroy_value(entity_types)
// 		return
// 	}

// 	level, level_err := json.parse(level_json, .Bitsquid, true)

// 	if level_err != .None {
// 		log.error("Failed to parse %v", level_filename)
// 		return
// 	}

// 	dialogues_json, dialogues_json_ok := load_dialogues_data()

// 	if !dialogues_json_ok {
// 		log.error("Failed to load %v", DialoguesFilename)
// 		return
// 	}

// 	dialogues, dialogues_err := json.parse(dialogues_json, .Bitsquid, true)

// 	if dialogues_err != .None {
// 		log.error("Failed to parse %v", DialoguesFilename)
// 		return
// 	}

// 	g_mem.level_name = level_name
// 	delete_serialized_state(g_mem.serialized_state)
// 	g_mem.serialized_state = {
// 		entity_types = entity_types,
// 		level = level,
// 		dialogue_trees = dialogues,
// 	}
// 	clear_interactions()
// 	delete_world(g_mem.world)
// 	g_mem.world = create_world(g_mem.serialized_state)
// 	enable_world(&g_mem.world)

// 	post_level_load(false)
// }

// check_if_in_trigger :: proc(r: Rect, tn: TriggerName) -> bool {
// 	for th in g_mem.world.triggers {
// 		if te, ok := get_entity(th, Trigger); ok {
// 			if te.name == tn  {
// 				trigger_rect := trigger_world_rect(te)

// 				if rl.CheckCollisionRecs(trigger_rect, r) {
// 					return true
// 				}
// 			}
// 		}
// 	}

// 	return false
// }

// create_entity :: proc(et: EntityType, pos: Vec2, layer: int) -> Entity {
// 	e := Entity {
// 		pos = pos,
// 		layer = layer,
// 		type = et.handle,
// 		scale = 1,
// 		id = new_uid(),
// 	}

// 	switch v in et.variant {
// 		case EntityTypeStaticObject: e.variant = StaticObject {}
// 		case EntityTypeAnimatedObject: e.variant = AnimatedObject {}
// 		case EntityTypeBuiltin: {
// 			#partial switch v.variant {
// 				case .Trigger: e.variant = Trigger {}
// 				case .Interactable: e.variant = Usable {}
// 				case .Spline: e.variant = Spline {}
// 				case .Collider: e.variant = StaticCollider{}

// 				case .None:
// 					log.error("EntityType has vriant EntityTypeBuiltin.None!")
// 			}
// 		}
// 	}

// 	return e
// }

// spline_last_point :: proc(s: EntityInst(Spline)) -> Vec2 {
// 	return world_spline_point(slice.last(s.points[:]), s.pos).point
// }

// spline_first_point :: proc(s: EntityInst(Spline)) -> Vec2 {
// 	return world_spline_point(slice.first(s.points[:]), s.pos).point
// }

// rocket_spline_done :: proc(p: EntityInst(Rocket), s: EntityInst(Spline), animate: bool = true) {
// 	p.pos = spline_last_point(s)
// 	p.state = .Standby

// 	if animate {
// 		p.renderables[0] = animated_renderable(.RocketCatLeave, 0.1, one_shot = true)
// 		p.renderables[0].offset = {-13, 0}
// 		p.oneshot_done_event = .CatJumpedOut
// 	} else {
// 		cat := create_entity_from_entity_kind(.Cat)
// 		cat.pos = p.pos + {-23, 10}
// 		cat.layer = 5
// 		cat.facing = .West
// 		g_mem.next_controlled_entity = add_entity(world, cat)
// 		g_mem.cat = g_mem.next_controlled_entity
// 	}

// 	g_mem.camera_state.zoom = default_game_camera_zoom()
// 	p.cat_inside = false
// 	p.scale = 1
// 	p.vel = {}
// 	p.rot = 0
// 	set_progress(.RocketLanded)
// }

// animate_along_spline :: proc(entity: EntityHandle, spline: EntityHandle, on_done: Event = nil) -> EntityHandle {
// 	spv := SplineEvaluator {
// 		target = entity,
// 		spline = spline,
// 		on_done_event = on_done,
// 	}

// 	if target := get_entity_raw(entity); target != nil {
// 		spv.interactable_on_done = target.interactable
// 		target.interactable = false
// 	}

// 	return add_entity(world, Entity {
// 		variant = spv,
// 	})
// }


// eval_spline :: proc(s: EntityInst(Spline), time: f32, prev_pos: Vec2) -> (pos: Vec2, rot: f32, scl: f32, speed_mult: f32, done: bool) {
// 	bezier_pt :: proc(start: Vec2, start_control: Vec2, end: Vec2, end_control: Vec2, t: f32) -> Vec2 {
// 		tm1 := 1 - t

// 		return tm1 * tm1 * tm1 * start +
// 			3 * t * tm1 * tm1 * start_control +
// 			3 * t * t * tm1 * end_control +
// 			t * t * t * end
// 	}

// 	pos = prev_pos
// 	scl = 1

// 	total_length: f32
// 	seg_lengths := make([]f32, len(s.points) - 1, context.temp_allocator)

// 	for p_idx in 0..<len(s.points)-1 {
// 		l: f32
// 		t: f32
// 		pc := s.points[p_idx]
// 		pn := s.points[p_idx + 1]
// 		prev_point := pc.point
// 		step: f32 = 0.01
// 		for t < 1 {
// 			new_pos := bezier_pt(pc.point, pc.control_out, pn.point, pn.control_in, t)
// 			diff := new_pos - prev_point
// 			l += linalg.length(diff)
// 			prev_point = new_pos
// 			t += step
// 		}

// 		seg_lengths[p_idx] = l
// 		total_length += l
// 	}

// 	if total_length > 0 {
// 		for p_idx in 0..<len(s.points)-1 {
// 			seg_lengths[p_idx] /= total_length
// 		}
// 	}

// 	t := time / total_length

// 	acc: f32

// 	for p_idx in 0..<len(s.points)-1 {
// 		sl := seg_lengths[p_idx]
// 		if acc + sl > t || p_idx == len(s.points)-1{
// 			bt := remap(t, acc, acc + sl, 0, 1)
// 			pc := s.points[p_idx]
// 			pn := s.points[p_idx + 1]
// 			pos = bezier_pt(pc.point, pc.control_out, pn.point, pn.control_in, bt) + s.pos
// 			prev_to_pos := pos - prev_pos
// 			dir := linalg.normalize0(prev_to_pos)
// 			rot_from_tangent := math.atan2(dir.y, dir.x) * rl.RAD2DEG + 90
// 			start_rot := rot_from_tangent
// 			end_rot := rot_from_tangent

// 			if pc.custom_rotation {
// 				start_rot = pc.rotation
// 			}

// 			if pn.custom_rotation {
// 				end_rot = pn.rotation
// 			}

// 			start_scl := pc.scale == 0 ? 1 : pc.scale
// 			end_scl := pn.scale == 0 ? 1 : pn.scale

// 			if start_rot > 180 {
// 				start_rot = -360 + start_rot
// 			} else if start_rot < -180 {
// 				start_rot = start_rot + 360
// 			}

// 			if end_rot > 180 {
// 				end_rot = -360 + end_rot
// 			} else if end_rot < -180 {
// 				end_rot = end_rot + 360
// 			}

// 			rot = math.lerp(start_rot, end_rot, bt)
// 			speed_mult = math.lerp(pc.speed, pn.speed, bt)
// 			scl = math.lerp(start_scl, end_scl, bt)

// 			break
// 		}

// 		acc += sl
// 	}

// 	if t >= 1 {
// 		if len(s.points) > 0 {
// 			pos = slice.last(s.points[:]).point + s.pos
// 			scl = slice.last(s.points[:]).scale
// 		}
// 		done = true
// 	}

// 	return
// }

// delete_game_state :: proc(gs: GameState) {
// 	switch v in gs {
// 		case GameStateDefault:
// 		case GameStateSpaceGame:
// 			delete(v.needed)
// 			delete(v.current)
// 			delete(v.letters)
// 			delete(v.available_bgs)
// 			delete(v.spawned_bgs)
// 		case GameStateEnteringPancakeBatterLand:

// 		case GameStateEnd:

// 		case GameStateIntro:


// 		case GameStateIntroTransition:
// 	}
// }

// set_game_state :: proc(new_gs: GameState) {
// 	delete_game_state(g_mem.game_state)
// 	g_mem.game_state = new_gs
// }

// space_game_start :: proc(end_event: Event, word: string,
// available_bgs: []TextureHandle, start_bg: TextureHandle, start_delay: f32,
// letter_color_normal: rl.Color, letter_color_need: rl.Color) {

// 	if r, ok := get_entity(g_mem.rocket, Rocket); ok {
// 		jump_into_rocket(true)
// 		r.state = .ExternallyControlled
// 		r.time_in_state = 0
// 		r.pos.x = 0
// 		g_mem.camera_state.pos = r.pos

// 		needed := make([]byte, len(word))
// 		current := make([]byte, len(word))
// 		for i in 0..<len(word) {
// 			needed[i] = word[i]
// 		}

// 		spawned_bgs := make([dynamic]SpaceGameBg)

// 		spawned := SpaceGameBg {
// 			texture = start_bg,
// 			pos = r.pos.y - 200,
// 		}

// 		append(&spawned_bgs, spawned)

// 		set_game_state(GameStateSpaceGame {
// 			rocket = r.handle,
// 			needed = needed,
// 			current = current,
// 			bottom_text_size = 20,
// 			end_event = end_event,
// 			available_bgs = slice.clone(available_bgs),
// 			spawned_bgs = spawned_bgs,
// 			spawn_timer = start_delay,
// 			vel = SpaceGameStartVel,
// 			letter_color_need = letter_color_need,
// 			letter_color_normal = letter_color_normal,
// 		})
// 	}
// }

// destroy_trigger :: proc(trigger: TriggerName) {
// 	for th in g_mem.world.triggers {
// 		if te, ok := get_entity(th, Trigger); ok {
// 			if te.name == trigger {
// 				destroy_entity(&g_mem.world, th)
// 			}
// 		}
// 	}
// }

// SpaceGameStartVel :: 40

// space_game_update :: proc(gs: ^GameStateSpaceGame) {
// 	r, r_ok := get_entity(gs.rocket, Rocket)

// 	if !r_ok {
// 		return
// 	}

// 	r.rot += math.sign(r.vel.x) * dt * 200

// 	r.rot = math.clamp(r.rot, -30, 30)

// 	if r.vel.x == 0 && r.rot != 0 {
// 		r.rot -= math.sign(r.rot) * dt * 300

// 		if math.abs(r.rot) < 2 {
// 			r.rot = 0
// 		}
// 	}

// 	r.vel.y = 0

// 	if gs.status != .DoneFlyingAway {
// 		r.vel.x = input.x * 60
// 	} else {
// 		r.vel.x = 0
// 	}

// 	r.pos += r.vel * dt
// 	r.pos.x = math.clamp(r.pos.x, -120, 120)
// 	g_mem.camera_state.pos.x = 0

// 	if gs.status == .Collecting {
// 		target_y := r.pos.y - 30
// 		diff := target_y - g_mem.camera_state.pos.y
// 		g_mem.camera_state.pos.y += diff * dt

// 		if math.abs(diff) < 0.01 {
// 			g_mem.camera_state.pos.y = target_y
// 		}
// 	}

// 	for th in g_mem.world.triggers {
// 		if te, ok := get_entity(th, Trigger); ok {
// 			trigger_rect := trigger_world_rect(te)

// 			if rl.CheckCollisionPointRec(r.pos, trigger_rect) {
// 				if te.event != nil {
// 					send_event(te.event)
// 					destroy_entity(world, th)
// 				}
// 			}
// 		}
// 	}

// 	alphabet := "abcdefghijklmnopqrstuvwxyz"
// 	gs.spawn_timer -= dt
// 	cr := g_mem.camera_rect

// 	if gs.spawn_timer <= 0 && gs.status == .Collecting {
// 		l := alphabet[rl.GetRandomValue(0, i32(len(alphabet)-1))]

// 		// force spawn letters at least every 10 sec
// 		if (g_mem.time - gs.last_needed_spawned_at) > 10 {
// 			l = gs.needed[rl.GetRandomValue(0, i32(len(gs.needed)-1))]
// 		}

// 		needed := false

// 		for _, i in gs.needed {
// 			if gs.needed[i] == l && gs.current[i] != gs.needed[i] {
// 				needed = true
// 				gs.last_needed_spawned_at = g_mem.time
// 				break
// 			}
// 		}

// 		spawn_area := Rect {
// 			cr.x + cr.width / 10,
// 			cr.y - 20,
// 			cr.width - cr.width / 5,
// 			20,
// 		}

// 		pos := Vec2 {
// 			random_in_range(spawn_area.x, spawn_area.x + spawn_area.width),
// 			random_in_range(spawn_area.y, spawn_area.y - spawn_area.height),
// 		}

// 		e := Entity {
// 			renderables = {
// 				0 = {
// 					type = .Letter,
// 					letter = l,
// 					letter_size = 20,
// 					color = needed ? gs.letter_color_need : gs.letter_color_normal,
// 				},
// 			},
// 			num_renderables = 1,
// 			pos = pos,
// 			layer = 2,
// 		}

// 		eh := add_entity(world, e)
// 		gs.spawn_timer = 0.5

// 		append(&gs.letters, SpaceGameLetter{
// 			rot_speed = random_in_range(-100, 100),
// 			letter = l,
// 			e = eh,
// 		})
// 	}

// 	rocket_rect: Rect

// 	if r := get_entity_raw(g_mem.rocket); r != nil {
// 		rocket_rect = inset_rect(rect_add_pos(r.renderables[0].rect, r.pos - rect_local_middle(r.renderables[0].rect)), 7, 7)
// 	}

// 	for i: int; i<len(gs.letters); {
// 		l := gs.letters[i]
// 		e := get_entity_raw(l.e)

// 		if e.pos.y > cr.y + cr.height {
// 			destroy_entity(world, l.e)
// 			gs.letters[i] = pop(&gs.letters)
// 			continue
// 		}

// 		r := inset_rect(rect_from_pos_size(e.pos + {0, 5}, {10, 12}), 1,1)

// 		if gs.status == .Collecting && rl.CheckCollisionRecs(r, rocket_rect) {
// 			for ni in 0..<len(gs.needed) {
// 				nl := gs.needed[ni]

// 				if nl == l.letter && gs.current[ni] != gs.needed[ni]{
// 					gs.current[ni] = gs.needed[ni]
// 					play_sound_range(.DiagIntroCloud0, .DiagIntroCloud5)
// 					break
// 				}
// 			}

// 			destroy_entity(world, l.e)
// 			gs.letters[i] = pop(&gs.letters)
// 			continue
// 		}

// 		e.rot += l.rot_speed * dt

// 		i += 1
// 		e.pos += {0, gs.vel * dt}
// 	}

// 	gs.status_time += dt

// 	when CAT_DEV {
// 		if rl.IsKeyPressed(.Z) {
// 			gs.status = .CollectingDoneDoTextAnimation
// 			gs.status_time = 0
// 		}
// 	}

// 	alpha: f32 = 1

// 	switch gs.status {
// 		case .Collecting:
// 			if gs.status_time < 3 {
// 				draw_dialogue_bubble("WHAT'S THE WORD OF THE DAY?", .Entity, g_mem.rocket, gs.status_time, true)
// 			}

// 			done := true
// 			for _, i in gs.needed {
// 				if gs.needed[i] != gs.current[i] {
// 					done = false
// 					break
// 				}
// 			}

// 			if done {
// 				gs.status = .CollectingDoneDoTextAnimation
// 				gs.status_time = 0
// 			}

// 		case .CollectingDoneDoTextAnimation:
// 			end := f32(5)
// 			t := remap(gs.status_time, 0, end, 0, 1)
// 			gs.bottom_text_size = math.lerp(f32(20), 80, t)
// 			gs.bottom_text_offset = {math.cos(t*50)*40, math.lerp(f32(0), -cr.height, t)}

// 			if gs.status_time >= end {
// 				gs.fly_away_start_pos = r.pos
// 				gs.status = .DoneFlyingAway
// 				gs.status_time = 0
// 			}

// 		case .DoneFlyingAway:
// 			end := f32(5)
// 			tt := remap(gs.status_time, 0, end, 0, 1)
// 			t := tt * tt * tt * tt
// 			if r := get_entity_raw(g_mem.rocket); r != nil {
// 				camera_mid := rect_middle(cr)
// 				r.pos = math.lerp(gs.fly_away_start_pos, camera_mid, t)
// 			}

// 			gs.vel = math.lerp(f32(SpaceGameStartVel), 6000, t)

// 			alpha = 1-remap(gs.status_time, 4.5, 5, 0, 1)

// 			str := strings.clone_from_bytes(gs.needed, context.temp_allocator)
// 			ts := rl.MeasureTextEx(g_mem.dialogue_font, temp_cstring(str), gs.bottom_text_size * default_game_camera_zoom(), 0)

// 			gs.bottom_text_offset.y = math.lerp(-cr.height, cr.height * 2 + ts.y * 2, t)

// 			if gs.status_time > end {
// 				send_event(gs.end_event)
// 			}
// 	}

// 	if len(gs.spawned_bgs) <= 2 {
// 		unused := make([dynamic]TextureHandle, context.temp_allocator)

// 		available_bgs_loop: for bg in gs.available_bgs {
// 			for s in gs.spawned_bgs {
// 				if s.texture == bg {
// 					continue available_bgs_loop
// 				}
// 			}

// 			append(&unused, bg)
// 		}

// 		new_bg: TextureHandle

// 		if len(unused) != 0 {
// 			new_bg = unused[rl.GetRandomValue(0, i32(len(unused)) - 1)]
// 		} else {
// 			new_bg = gs.available_bgs[rl.GetRandomValue(0, i32(len(gs.available_bgs)) - 1)]
// 		}

// 		top_pos: f32

// 		if len(gs.spawned_bgs) > 0 {
// 			top_pos = gs.spawned_bgs[0].pos

// 			for bg in gs.spawned_bgs {
// 				if bg.pos < top_pos {
// 					top_pos = bg.pos
// 				}
// 			}
// 		}

// 		append(&gs.spawned_bgs, SpaceGameBg{
// 			pos = top_pos - 180,
// 			texture = new_bg,
// 		})
// 	}

// 	for i: int; i<len(gs.spawned_bgs); {
// 		bg := &gs.spawned_bgs[i]

// 		if bg.pos - 120 > cr.y + cr.height {
// 			gs.spawned_bgs[i] = pop(&gs.spawned_bgs)
// 			continue
// 		}

// 		tint := rl.WHITE

// 		tint.r = u8(f32(tint.r) * alpha)
// 		tint.g = u8(f32(tint.g) * alpha)
// 		tint.b = u8(f32(tint.b) * alpha)
// 		tint.a = u8(alpha * 255)

// 		bg.pos += dt * gs.vel * 0.5
// 		render_texture(bg.texture, {0, bg.pos}, 1, false, tint = tint)

// 		i += 1
// 	}
// }

// rocket_update :: proc(p: EntityInst(Rocket)) {
// 	do_camera_update := false
// 	calc_vel := p.pos - p.prev_pos
// 	p.prev_pos = p.pos

// 	if p.renderables[0].one_shot {
// 		if p.renderables[0].cur_frame == p.renderables[0].num_frames - 1 {
// 			switch p.oneshot_done_event {
// 				case .None:

// 				case .CatJumpedOut:
// 					cat := create_entity_from_entity_kind(.Cat)
// 					cat.pos = p.pos + {-23, 10}
// 					cat.layer = 5
// 					cat.facing = .West
// 					g_mem.next_controlled_entity = add_entity(world, cat)
// 					g_mem.cat = g_mem.next_controlled_entity

// 				case .CatJumpedIn:
// 					p.doing_jump_in_anim = false
// 			}

// 			p.oneshot_done_event = .None
// 			p.renderables[0] = animated_renderable(.SpaceOnionTalk, 0.15, is_animating = false, animate_when_interacted_with = true )
// 		}
// 	}

// 	if get_event(EventFlyToBookShelf) != nil {
// 		e := find_entity_with_tag(.RocketFlyUpToBookshelfInteractable)

// 		if e != EntityHandleNone {
// 			if eu, ok := get_entity(e, Usable); ok {
// 				use_usable(eu)
// 				play_sound_alias(.RocketEngineStatic)
// 			}
// 		}
// 	}

// 	p.time_in_state += dt

// 	if p.cat_inside {
// 		if p.cat_inside_time == 0 {
// 			p.cat_inside_camera_start = g_mem.camera_state.pos
// 		}

// 		if !p.doing_jump_in_anim {
// 			p.cat_inside_time += dt
// 		}
// 	}

// 	switch p.state {
// 		case .Standby:
// 			if p.cat_inside {
// 				tt := math.saturate(p.cat_inside_time/f32(1.9))
// 				t := mix(smooth_start2, smooth_stop2, tt, tt)
// 				g_mem.camera_state.pos = math.lerp(p.cat_inside_camera_start, p.pos, t)

// 				if p.cat_inside_time > 2 {
// 					p.state = .Ignition
// 					p.time_in_state = 0
// 					play_sound_alias(.RocketEngine0)
// 				}
// 			}

// 		case .Ignition:
// 			g_mem.camera_state.shake_amp = math.remap(p.time_in_state, 0, 1, 0, 0.1)
// 			g_mem.camera_state.shake_freq = 100

// 			if p.time_in_state > 1 {
// 				p.state = .SlightRising
// 				p.time_in_state = 0
// 			}

// 			do_camera_update = true

// 		case .SlightRising:
// 			p.vel.y -= 1 * dt

// 			if p.vel.y < -5 {
// 				p.vel.y = -5
// 			}

// 			if p.time_in_state > 2 {
// 				sqr := find_entity_of_kind(.Squirrel)

// 				if sqr != EntityHandleNone {
// 					draw_dialogue_bubble("Safe journey!!", .Entity, sqr, p.time_in_state - 2)
// 				}
// 			}

// 			p.pos += p.vel * dt

// 			g_mem.camera_state.shake_amp = math.remap(p.time_in_state, 0, 4, 0.1, 1)
// 			g_mem.camera_state.shake_freq = 100

// 			if p.time_in_state > 4 {
// 				p.state = .Blastoff
// 				p.time_in_state = 0
// 			}

// 			do_camera_update = true

// 		case .Blastoff:
// 			p.vel.y -= 1000 * dt

// 			if p.vel.y < -300 {
// 				p.vel.y = -300
// 			}

// 			p.pos += p.vel * dt

// 			if p.time_in_state > 0.5 {
// 				g_mem.camera_state.shake_amp = max(0, g_mem.camera_state.shake_amp - dt * 4)
// 				g_mem.camera_state.shake_freq = 100
// 			}

// 			if p.time_in_state > 2.5 {
// 				if get_progress(.InSpace) {
// 					available_bgs := []TextureHandle {
// 						get_texture_handle(.SpaceBg0),
// 						get_texture_handle(.SpaceBg1),
// 						get_texture_handle(.SpaceBg2),
// 						get_texture_handle(.SpaceBg3),
// 					}

// 					words := [?] string {
// 						"space",
// 						"catnap",
// 						"heart",
// 						"distant",
// 						"homesick",
// 					}

// 					space_game_start(EventEndAcornSpace{}, words[rl.GetRandomValue(0, len(words)-1)], available_bgs,
// 						get_texture_handle(.SpaceBgStart), 12, ColorLight, ColorCat)
// 				} else {
// 					available_bgs := []TextureHandle {
// 						get_texture_handle(.SkyBg0),
// 						get_texture_handle(.SkyBg1),
// 						get_texture_handle(.SkyBg2),
// 					}

// 					words := [?] string {
// 						"where",
// 						"helpful",
// 						"wander",
// 						"search",
// 						"curious",
// 					}

// 					space_game_start(EventFlyOutFromPlanet{}, words[rl.GetRandomValue(0, len(words)-1)], available_bgs,
// 						get_texture_handle(.SkyBgStart), 7, ColorMediumDark, ColorCat)
// 					p.state = .ExternallyControlled
// 					p.time_in_state = 0
// 					break
// 				}
// 			}

// 			do_camera_update = true

// 		case .FlyingUp:
// 			g_mem.camera_state.pos = p.pos
// 			p.rot = remap(p.time_in_state, 3, 8, 0, 70)

// 			if p.time_in_state > 4.5 {
// 				fade_t := remap(p.time_in_state, 4.5, 8, 0, 1)
// 				g_mem.clear_color = lerp_color(ColorSky, ColorGrass, fade_t)
// 			}

// 			do_camera_update = true

// 			if p.time_in_state > 10 {
// 				g_mem.next_level_name = .House
// 				g_mem.load_next_level = true
// 			}

// 		case .LeavingPlanet:
// 			ls := find_entity_with_tag(.RocketLandingSpline)
// 			s, s_ok := get_entity(ls, Spline)

// 			if !s_ok || len(s.points) < 2 {
// 				p.state = .Standby
// 				break
// 			}

// 			when CAT_DEV {
// 				if rl.IsKeyPressed(.ENTER) {
// 					last_pt := slice.last(s.points[:])
// 					rocket_spline_done(p, s)
// 					break
// 				}
// 			}

// 			scale_t := remap(p.time_in_state, 4, 10, 0, 1)
// 			p.scale = remap(scale_t*scale_t, 0, 1, 0.01, 1)

// 			zt := remap(p.time_in_state, 1, 4, 0, 1)
// 			zoomt := 1 - (1-zt) * (1-zt) * (1-zt)

// 			g_mem.camera_state.zoom = math.lerp(default_game_camera_zoom() * 100, default_game_camera_zoom(), zoomt)
// 			do_camera_update = false

// 			pos, rot, scl, speed_mult, done := eval_spline(s, p.landing_progress, p.pos)

// 			p.pos = pos
// 			p.rot = rot

// 			if done {
// 				rocket_spline_done(p, s)
// 			}

// 			p.landing_progress += dt * speed_mult
// 			g_mem.camera_state.pos = p.pos

// 		case .ExternallyControlled:

// 		case .ExternallyControlledCameraFollow:
// 			do_camera_update = true

// 		case .ExternallyControlledCameraFollowEaseIn:
// 			if p.cat_inside {
// 				tt := math.saturate(p.cat_inside_time/f32(1.9))
// 				t := mix(smooth_start2, smooth_stop2, tt, tt)
// 				g_mem.camera_state.pos = math.lerp(p.cat_inside_camera_start, p.pos, t)

// 				if p.cat_inside_time >= 1.9 {
// 					do_camera_update = true
// 				}
// 			} else {
// 				do_camera_update = true
// 			}
// 	}

// 	if do_camera_update {
// 		g_mem.camera_state.pos = p.pos
// 	}

// 	p.num_renderables = 3

// 	if (p.state == .Standby || p.state == .ExternallyControlled) && linalg.length(calc_vel) < 0.001 && reflect.union_variant_typeid(g_mem.game_state) != GameStateSpaceGame {
// 		p.renderables[1] = {}
// 	} else {
// 		p.renderables[1].is_animating = true

// 		if p.renderables[1].texture.id == 0 {
// 			p.renderables[1] = rocket_fire_renderable()
// 		}
// 	}

// 	if p.doing_jump_in_anim && p.renderables[0].num_loops > 0 {
// 		p.doing_jump_in_anim = false
// 		p.renderables[0] = animated_renderable(.SpaceOnionTalk, 0.15, is_animating = false, animate_when_interacted_with = true )
// 	}

// 	if p.cat_inside && !p.doing_jump_in_anim {
// 		p.renderables[2] = { texture = get_texture_handle(.CatInRocket), offset = {0, -1}, relative_layer=  1 }
// 	} else {
// 		p.renderables[2] = {}
// 	}
// }

// rocket_fire_renderable :: proc() -> EntityRenderable {
// 	return animated_renderable(.Fire, 0.05, relative_layer = -1, offset = {-1, 24})
// }

// send_event :: proc(e: Event) {
// 	append(&g_mem.next_events, e)
// }

// send_delayed_event :: proc(e: Event, delay: f32) {
// 	append(&g_mem.delayed_events, DelayedEvent { event = e, delay = delay })
// }

// get_event :: proc($T: typeid) -> Event {
// 	for e in g_mem.events {
// 		if reflect.union_variant_typeid(e) == T {
// 			return e
// 		}
// 	}

// 	return nil
// }

// ProgressFlag :: enum i64 {
// 	None,
// 	GotOnionSeed,
// 	GotEgg,
// 	Snap0,
// 	RocketLanded,
// 	OnionPlanted,
// 	GotRootCellarKey,
// 	WaterfallGreeted,
// 	TalkedToSquirrel,
// 	PlayerWithOnionSeedGreeted,
// 	HasPlayedRocketGrow,
// 	MovedSquirrelToSoil,
// 	DoorGreeted,
// 	CanUseElevator,
// 	BirdGreeted,
// 	RocketGreeted,
// 	TriedToOpenDoor,
// 	RocketFlewUpToShelf,
// 	FetchButterAndFlour,
// 	SquirrelHasButter,
// 	TalkedToFlourTree,
// 	HasSmackedFlourTree,
// 	SquirrelHasFlour,
// 	OnionGrown,
// 	LandedInFrontOfOak,
// 	InSpace,
// 	SpaceEnded,
// 	InSpaceHouse,
// 	OnionOutsideHouse,
// 	HideTutorialStuff,
// 	WentUpToOakTop,
// 	AnyCats,
// 	SquirrelRocketTalked,
// 	SpaceEndedTalkedToSquirrel,
// 	UShowDialogueTutorial,
// 	HasFlouredWall,
// 	GivenWaterbucket,
// 	CaveOpened,
// 	GottenScoldedByFlourTree,

// 	BatterHasButter,
// 	BatterHasFlour,
// 	BatterHasEgg,
// }

// set_progress :: proc(pf: ProgressFlag) {
// 	g_mem.progress += {pf}
// }

// get_progress :: proc(pf: ProgressFlag) -> bool {
// 	return pf in g_mem.progress
// }

// dialogue_auto_advance_time :: proc(line: string) -> f32 {
// 	return max(f32(len(line))/DialogueAutoAdvanceLengthDivisor, 2.0)
// }

// prev_dialogue_time_on_line: f32

// dialogue_pitch_volume :: proc(kind: EntityKind) -> (f32, f32) {
// 	#partial switch kind {
// 		case .Cat:
// 			return random_in_range(1.3, 1.5), 0.8
// 		case .Squirrel:
// 			return random_in_range(1.9, 2.1), 0.5
// 		case .Stone:
// 			return random_in_range(0.5, 0.6), 1.4
// 		case .Rocket:
// 			return 0.8, 1.3
// 		case .FlourTree:
// 			return random_in_range(0.7, 0.85), 1
// 		case .AngryDoor:
// 			return random_in_range(0.8, 0.9), 0.85
// 		case .Acorn:
// 			return random_in_range(0.7, 0.9), 1
// 		case .CaveFace:
// 			return random_in_range(0.5, 0.6), 0.7
// 	}

// 	return random_in_range(0.9, 1.1), 1
// }

// draw_dialogue_bubble :: proc(text: string, actor: DialogueActor, talking_with: EntityHandle,
// 	time_on_line: f32, flip_bubble: bool = false, override_color: bool = false,
// 	override_color_bg: rl.Color = ColorCat, override_color_text: rl.Color = ColorDark, override_color_border: rl.Color = ColorDark,
// 	override_kind_enable: bool = false, override_kind: EntityKind = {}, dont_animate: bool = false,
// 	first_frame: bool = false, no_sound: bool = false) -> (bool, Rect) {
// 	talking_with_e := get_entity_raw(talking_with)

// 	if talking_with_e == nil {
// 		return false, {}
// 	}

// 	eh := talking_with
// 	controlled_entity := get_entity_raw(g_mem.controlled_entity)

// 	if controlled_entity == nil {
// 		controlled_entity = get_entity_raw(g_mem.cat)
// 	}

// 	if actor == .Player {
// 		if g_mem.controlled_entity != EntityHandleNone {
// 			eh = g_mem.controlled_entity
// 		} else {
// 			eh = g_mem.cat
// 		}
// 	}

// 	if eh == EntityHandleNone {
// 		return false, {}
// 	}

// 	e := get_entity_raw(eh)

// 	if e == nil {
// 		return false, {}
// 	}

// 	on_the_left := true
// 	flip := Vec2{1, 1}

// 	if e.facing == .West || e.flip_x {
// 		flip.x = -1
// 	}

// 	anchor_point := e.pos + e.interactable_offset * flip + e.interactable_icon_offset *flip + {1, 4}

// 	if controlled_entity != nil {
// 		if actor == .Player {
// 			anchor_point.x += controlled_entity.facing == .East ? 3 : -3
// 			anchor_point.y = e.pos.y - 10

// 			if controlled_entity.pos.x > talking_with_e.pos.x {
// 				on_the_left = false
// 			}
// 		} else {
// 			if talking_with_e.pos.x > controlled_entity.pos.x {
// 				on_the_left = false
// 			}
// 		}
// 	}

// 	if flip_bubble {
// 		on_the_left = !on_the_left
// 	}

// 	lines, max_line_width := get_gui_lines(text, MetricDialogueWidth, g_mem.dialogue_font, MetricDialogueFontHeight)

// 	draw_area_width := (max_line_width + MetricDialogueMargin*2)
// 	draw_area_height := f32(MetricDialogueFontHeight*len(lines)) + MetricDialogueVerticalMargin*2

// 	x := on_the_left ? anchor_point.x - (draw_area_width - 6) : anchor_point.x - 6
// 	y := anchor_point.y - draw_area_height - 3

// 	edge_right := g_mem.camera_state.pos.x + camera_width(g_mem.camera_state.zoom)/2 - 10
// 	edge_left := g_mem.camera_state.pos.x - camera_width(g_mem.camera_state.zoom)/2 + 10

// 	if (x + draw_area_width) > edge_right {
// 		x -= (x + draw_area_width) - edge_right
// 	}

// 	if x < edge_left {
// 		x -= x - edge_left
// 	}

// 	bg_rect := Rect { x, y, draw_area_width, draw_area_height }

// 	bg_color := ColorCat
// 	text_color := ColorDark
// 	border_color := ColorDark

// 	kind := talking_with_e.kind
// 	kind_talk_sound := e.kind

// 	sound_start := SoundName.DiagIntroCloud0
// 	sound_end := SoundName.DiagIntroCloud5

// 	sound_inanimate_start := SoundName.TalkInanimate0
// 	sound_inanimate_end := SoundName.TalkInanimate5

// 	sound_time: f32 = 0.1

// 	if override_kind_enable {
// 		kind = override_kind
// 		kind_talk_sound = override_kind
// 	}

// 	if actor == .Entity {
// 		#partial switch kind {
// 			case .FlourTree:
// 				bg_color = ColorLight
// 				sound_start = sound_inanimate_start
// 				sound_end = sound_inanimate_end

// 			case .Stone:
// 				bg_color = ColorDark
// 				text_color = ColorOrange
// 				border_color = ColorBrown
// 				sound_start = sound_inanimate_start
// 				sound_end = sound_inanimate_end
// 				sound_time = 0.15
// 			case .Waterfall:
// 				bg_color = ColorSky
// 				text_color = ColorDark
// 				border_color = ColorDark
// 			case .Bird:
// 				bg_color = ColorLight
// 			case .Rocket:
// 				border_color = ColorCat
// 				bg_color = ColorDark
// 				text_color = ColorCat
// 			case .AngryDoor:
// 				bg_color = ColorOrange
// 				sound_start = sound_inanimate_start
// 				sound_end = sound_inanimate_end
// 			case .Squirrel:
// 				bg_color = ColorOrange
// 			case .Acorn:
// 				bg_color = ColorGrass
// 				text_color = ColorMediumDark
// 				border_color = ColorMediumDark
// 				sound_start = sound_inanimate_start
// 				sound_end = sound_inanimate_end
// 				sound_time = 0.13

// 			case .CaveFace:
// 				sound_start = sound_inanimate_start
// 				sound_end = sound_inanimate_end

// 		}

// 		#partial switch talking_with_e.tag {
// 			case .EndKlucke:
// 				bg_color = ColorBrown
// 				border_color = ColorDark
// 				text_color = ColorOrange
// 			case .EndLakrits:
// 				bg_color = ColorDark
// 				border_color = ColorLight
// 				text_color = ColorLight
// 			case .EndLillemor:
// 				bg_color = ColorBrown
// 				border_color = ColorDark
// 				text_color = ColorLight
// 			case .EndPontus:
// 				bg_color = ColorLight
// 				border_color = ColorDark
// 				text_color = ColorDark
// 		}
// 	}

// 	if override_color {
// 		bg_color = override_color_bg
// 		text_color = override_color_text
// 		border_color = override_color_border
// 	}

// 	draw_rectangle(pad_rect(bg_rect, 1, 0), border_color, 19)
// 	draw_rectangle(pad_rect(bg_rect, 0, 1), border_color, 19)

// 	// arrow drawing
// 	{
// 		arrow_dark_bg_1 := rect_from_pos_size(anchor_point - {2, 2}, {4, 1})
// 		arrow_dark_bg_2 := rect_from_pos_size(anchor_point - {2, 1}, {3, 1})
// 		arrow_dark_bg_3 := rect_from_pos_size(anchor_point - {2, 0}, {2, 1})
// 		draw_rectangle(arrow_dark_bg_1, border_color, 21)
// 		draw_rectangle(arrow_dark_bg_2, border_color, 21)
// 		draw_rectangle(arrow_dark_bg_3, border_color, 21)

// 		arrow_bg_1 := rect_from_pos_size(anchor_point - {1, 3}, {2,2})
// 		draw_rectangle(arrow_bg_1, bg_color, 22)

// 		arrow_bg_2 := rect_from_pos_size(anchor_point - {1, 1}, {1,1})
// 		draw_rectangle(arrow_bg_2, bg_color, 22)
// 	}

// 	draw_rectangle(bg_rect, bg_color, 20)

// 	text_pos := Vec2 {
// 		x + MetricDialogueMargin,
// 		y + MetricDialogueVerticalMargin - 0.5,
// 	}

// 	b := strings.builder_make(context.temp_allocator)
// 	ui.active_buffer = b.buf

// 	for l, i in lines {
// 		strings.write_string(&b, l)
// 		if i != len(lines) - 1{
// 			strings.write_string(&b, "\n")
// 		}
// 	}

// 	render_text(strings.to_string(b), text_pos, 23, time_on_line = time_on_line, color = text_color)

// 	if prev_dialogue_time_on_line > time_on_line {
// 		prev_dialogue_time_on_line = 0
// 	}

// 	if !no_sound && (time_on_line >= 0 && (first_frame || time_on_line > (prev_dialogue_time_on_line + sound_time))) {
// 		if time_on_line < f32(len(text)) * DialogueRuneAppearTime {
// 			s := play_sound_range(sound_start, sound_end)
// 			pitch, vol := dialogue_pitch_volume(kind_talk_sound)
// 			rl.SetSoundPitch(s, pitch)
// 			rl.SetSoundVolume(s, vol)
// 			prev_dialogue_time_on_line = time_on_line
// 		}
// 	}

// 	return true, bg_rect
// }

// update_interaction_dialogue :: proc(i: ^InteractionDialogue) {
// 	// time_on_line == -1 means make all text appear at once etc

// 	first_frame := i.time_on_line == 0

// 	if i.time_on_line >= 0 {
// 		i.time_on_line += dt
// 	}

// 	if len(i.single_line) > 0 {
// 		ok, _ := draw_dialogue_bubble(i.single_line, i.entity == g_mem.controlled_entity ? .Player : .Entity, i.entity, i.time_on_line, i.flip_bubble, first_frame = first_frame, no_sound = i.no_sound)

// 		if !ok {
// 			i.done = true
// 			return
// 		}

// 		if i.manual_end {
// 			return
// 		}

// 		if input.dialogue_skip {
// 			clear_input()

// 			if i.time_on_line >= 0 && i.time_on_line < f32(len(i.single_line)) * DialogueRuneAppearTime {
// 				i.time_on_line = -1
// 			} else {
// 				i.done = true
// 			}
// 		} else if i.auto_advance && i.time_on_line > dialogue_auto_advance_time(i.single_line) {
// 			clear_input()
// 			i.done = true
// 		}

// 		if i.done && i.end_event != nil {
// 			do_event(i.end_event)
// 			i.end_event = nil
// 		}

// 		return
// 	}

// 	if c, ok := get_entity(g_mem.cat, PlayerCat); ok {
// 		if i, ok := c.state.(PlayerStateInteracting); ok {
// 			if !i.in_position {
// 				return
// 			}
// 		}
// 	}

// 	d := &world.dialogue_trees[i.dialogue]

// 	if len(d.nodes) == 0 {
// 		i.done = true
// 		return
// 	}


// 	g_mem.had_active_interactions_this_frame = true

// 	n := &d.nodes[i.current_node]

// 	go_to_next_node :: proc(d: ^DialogueTree, i: ^InteractionDialogue, from_choice: int = -1) -> bool {
// 		if e := get_entity_raw(i.entity); e != nil {
// 			if e.renderables[0].interaction_wait_for_anim {
// 				n := d.nodes[i.current_node]
// 				if norm, ok := n.variant.(DialogueNodeVariantNormal); ok {
// 					if norm.actor == .Entity && e.renderables[0].num_loops == 0 {
// 						return true
// 					}
// 				}
// 			}
// 		}

// 		for c in d.connections {
// 			if c.from == i.current_node && (from_choice == -1 || c.from_choice == from_choice) {
// 				if c.to < len(d.nodes) {
// 					i.current_node = c.to
// 					i.current_node_do_choices = false
// 					i.time_on_line = 0
// 					return true
// 				}
// 			}
// 		}

// 		i.done = true
// 		return false
// 	}

// 	if i.current_node_do_choices {
// 		v, ok := &n.variant.(DialogueNodeVariantNormal)

// 		if !ok {
// 			i.done = true
// 			return
// 		}

// 		eh := g_mem.controlled_entity
// 		e := get_entity_raw(eh)

// 		if e == nil {
// 			i.done = true
// 			return
// 		}

// 		on_the_left := true
// 		anchor_point := e.pos - {0, 10}
// 		cat, cat_ok := get_entity(eh, PlayerCat)

// 		talking_with := get_entity_raw(i.entity)

// 		if cat_ok && talking_with != nil {
// 			anchor_point.x += cat.facing == .East ? 5 : -3

// 			if cat.pos.x > talking_with.pos.x {
// 				on_the_left = false
// 			}
// 		}

// 		available_choices := num_available_choices(v^)

// 		if available_choices == 0 {
// 			i.done = true
// 			return
// 		}

// 		if v.cur_choice >= available_choices || v.cur_choice < 0 {
// 			v.cur_choice = 0
// 		}

// 		if input.ui_up && v.cur_choice > 0 {
// 			v.cur_choice -= 1
// 		}

// 		if input.ui_down && v.cur_choice < available_choices - 1 {
// 			v.cur_choice += 1
// 		}

// 		width: f32
// 		num_lines: int

// 		passes_item_check :: proc(c: DialogueChoice) -> bool {
// 			if !c.check_item || c.item_to_check == .None {
// 				return true
// 			}

// 			inventory_match := has_inventory_item(c.item_to_check)

// 			if c.does_not_have_item {
// 				if inventory_match {
// 					return false
// 				}
// 			} else {
// 				if !inventory_match {
// 					return false
// 				}
// 			}

// 			return true
// 		}

// 		num_available_choices :: proc(n: DialogueNodeVariantNormal) -> (res: int) {
// 			for ch_idx in 0..<n.num_choices {
// 				c := n.choices[ch_idx]

// 				if passes_item_check(c) && passes_progress_check(c) {
// 					res += 1
// 				}
// 			}

// 			return
// 		}

// 		passes_progress_check :: proc(c: DialogueChoice) -> bool {
// 			if !c.check_progress || c.progress_to_check == {} {
// 				return true
// 			}

// 			progress_match := (g_mem.progress & c.progress_to_check) == c.progress_to_check
// 			return c.does_not_have_progress ? !progress_match : progress_match
// 		}

// 		for ch_idx in 0..<v.num_choices {
// 			c := v.choices[ch_idx]

// 			if !passes_item_check(c) || !passes_progress_check(c) {
// 				continue
// 			}

// 			lines, max_line_width := get_gui_lines(c.text, MetricDialogueWidth, g_mem.dialogue_font, MetricDialogueFontHeight)

// 			if max_line_width > width {
// 				width = max_line_width
// 			}

// 			num_lines += len(lines)
// 		}

// 		draw_area_width := (width + MetricDialogueMargin*2 + 1)
// 		draw_area_height := f32(MetricDialogueFontHeight*num_lines) + MetricDialogueVerticalMargin*2 + f32(MetricDialogueChoiceMargin*(available_choices - 1)) + 3

// 		x := on_the_left ? anchor_point.x - (draw_area_width - 6) : anchor_point.x - 6
// 		y := anchor_point.y - draw_area_height - 3

// 		edge_right := g_mem.camera_state.pos.x + camera_width(g_mem.camera_state.zoom)/2 - 5
// 		edge_left := g_mem.camera_state.pos.x - camera_width(g_mem.camera_state.zoom)/2 + 5

// 		choice_width: f32 = 0

// 		if (x + draw_area_width + choice_width) > edge_right {
// 			x -= (x + draw_area_width + choice_width) - edge_right
// 		}

// 		if (x - choice_width) < edge_left {
// 			x -= (x - choice_width) - edge_left
// 		}

// 		blip_extra :: 1
// 		bg_rect := Rect { x - choice_width, y, draw_area_width+choice_width + blip_extra, draw_area_height }

// 		draw_rectangle(pad_rect(bg_rect, 1, 0), ColorDark, 18)
// 		draw_rectangle(pad_rect(bg_rect, 0, 1), ColorDark, 18)
// 		draw_rectangle(bg_rect, ColorCat, 19)
// 		render_texture(g_mem.talk_bg_arrow, anchor_point - {0, 2}, 22, false)

// 		text_pos := Vec2 {
// 			x + MetricDialogueMargin,
// 			y + MetricDialogueVerticalMargin + 1,
// 		}

// 		choice_counter := 0

// 		for ch_idx in 0..<v.num_choices {
// 			c := v.choices[ch_idx]

// 			if !passes_item_check(c) || !passes_progress_check(c) {
// 				continue
// 			}

// 			lines, max_line_width := get_gui_lines(c.text, MetricDialogueWidth, g_mem.dialogue_font, MetricDialogueFontHeight)

// 			current_choice := choice_counter == v.cur_choice

// 			if current_choice {
// 				cur_bg_rect := rect_from_pos_size({x + 2, text_pos.y}, {bg_rect.width - 4, f32(len(lines)) * MetricDialogueFontHeight + 1})

// 				outline := ColorOrange

// 				if math.floor(g_mem.time) < math.round(g_mem.time) {
// 					//outline = ColorLight
// 				}

// 				draw_rectangle(pad_rect(cur_bg_rect, 1, 0), outline, 20)
// 				draw_rectangle(pad_rect(cur_bg_rect, 0, 1), outline, 20)
// 				draw_rectangle(cur_bg_rect, ColorLight, 21)
// 				//draw_rectangle_lines(cur_bg_rect, ColorLight, 22)

// 				/*{
// 					blip_pos := Vec2{x + 1, text_pos.y + 1}
// 					blip_rect := rect_from_pos_size(blip_pos, {1, 5})
// 					draw_rectangle(blip_rect, ColorCat, 22)
// 				}

// 				{
// 					blip_pos := Vec2{x + 2, text_pos.y + 2}
// 					blip_rect := rect_from_pos_size(blip_pos, {1, 3})
// 					draw_rectangle(blip_rect, ColorCat, 22)
// 				}


// 				{
// 					blip_pos := Vec2{x + 3, text_pos.y + 3}
// 					blip_rect := rect_from_pos_size(blip_pos, {1, 1})
// 					draw_rectangle(blip_rect, ColorCat, 22)
// 				}
// */
// 				if input.ui_select {
// 					world.diag_tutorial_choice_counter -= 1
// 					if !go_to_next_node(d, i, ch_idx) {
// 						clear_input()
// 						return
// 					}
// 				}
// 			}

// 			lines_y_begin := text_pos.y

// 			for l in lines {
// 				render_text(l, text_pos + {blip_extra, 0.5}, 21, ColorDark)
// 				text_pos.y += MetricDialogueFontHeight
// 			}

// 			lines_h := text_pos.y - lines_y_begin

// 			if show_dialogue_tutorial() && choice_counter == v.cur_choice {
// 				p := rect_top_middle(bg_rect)
// 				if input.gamepad {
// 					p -= {5, 10}
// 					render_gamepad_glyph(settings.gamepad_bindings[.Use], settings.gamepad_type, p + {10, 0}, 30)
// 				} else {
// 					use := keyboard_binding_text(.Use)
// 					ts := dialogue_text_size(use)
// 					p -= {5 + ts.x/2, 10}
// 					text_pos := p + {7, -ts.y/2}
// 					bg_rect := pad_rect(rect_from_pos_size(text_pos, ts), 1, 0)
// 					draw_rectangle(pad_rect(bg_rect, 0, 1), ColorCat, 27)
// 					draw_rectangle(pad_rect(bg_rect, 1, 0), ColorCat, 27)
// 					draw_rectangle(bg_rect, ColorDark, 29)
// 					render_text(use, text_pos, 31, ColorCat)
// 				}

// 				render_texture(get_texture_handle(.DiagChoiceTutorial), p, 32)
// 			}

// 			text_pos.y += MetricDialogueChoiceMargin
// 			choice_counter += 1
// 		}
// 	} else {
// 		switch v in n.variant {
// 			case DialogueNodeVariantNormal:
// 				if len(v.text) > 0 {
// 					_, r := draw_dialogue_bubble(v.text, v.actor, i.entity, i.time_on_line, override_kind_enable = v.override_kind_enable, override_kind = v.override_kind, dont_animate = v.dont_animate, first_frame = first_frame, no_sound = i.no_sound)

// 					if show_dialogue_tutorial() && !i.auto_advance {
// 						if input.gamepad {
// 							tr := rect_top_right(r) + {2, -2}
// 							render_gamepad_glyph(settings.gamepad_bindings[.Use], settings.gamepad_type, tr, 30)
// 						} else {
// 							tm := rect_top_middle(r)
// 							use := keyboard_binding_text(.Use)
// 							ts := dialogue_text_size(use)
// 							tm.y -= ts.y + 3
// 							tm.x -= ts.x /2
// 							bg_rect := pad_rect(rect_from_pos_size(tm, ts), 1, 0)
// 							draw_rectangle(pad_rect(bg_rect, 1, 0), ColorCat, 28)
// 							draw_rectangle(pad_rect(bg_rect, 0, 1), ColorCat, 28)
// 							draw_rectangle(bg_rect, ColorDark, 29)
// 							render_text(use, tm, 30, ColorCat)
// 						}
// 					}
// 				}

// 				skip := input.dialogue_skip || input.ui_select

// 				if skip && i.time_on_line >= 0 && i.time_on_line < f32(len(v.text)) * DialogueRuneAppearTime {
// 					i.time_on_line = -1
// 				} else if (!i.auto_advance && skip) || len(v.text) == 0 || (i.auto_advance && i.time_on_line > max(f32(len(i.single_line))/DialogueAutoAdvanceLengthDivisor, 2.0) ){
// 					world.diag_tutorial_advance_counter -= 1

// 					if v.num_choices > 0 && i.current_node_do_choices == false {
// 						i.current_node_do_choices = true
// 					} else {
// 						if !go_to_next_node(d, i) {
// 							clear_input()
// 							return
// 						}
// 					}
// 				}
// 			case DialogueNodeVariantStart:
// 				go_to_next_node(d, i)

// 			case DialogueNodeVariantProgressCheck:
// 				choice_idx := 0

// 				if (g_mem.progress & v.progress_to_check) == v.progress_to_check {
// 					choice_idx = 0
// 				} else {
// 					choice_idx = 1
// 				}

// 				go_to_next_node(d, i, choice_idx)

// 			case DialogueNodeVariantSetProgress:
// 				set_progress(v.progress)
// 				go_to_next_node(d, i)

// 			case DialogueNodeVariantGivePlayerItem:
// 				if !has_inventory_item(v.item) {
// 					has_pos := false
// 					pos: Vec2

// 					if e := get_entity_raw(i.entity); e != nil {
// 						pos = e.pos + e.interactable_offset
// 						has_pos = true
// 					}
// 					add_to_inventory(v.item, pos, has_pos)
// 					play_sound_range(.Pickup1, .Pickup1)
// 				}

// 				go_to_next_node(d, i)

// 			case DialogueNodeVariantTriggerEvent:
// 				send_event(v.event)
// 				go_to_next_node(d, i)

// 			case DialogueNodeVariantTakeItem:
// 				remove_inventory_item(v.item)
// 				go_to_next_node(d, i)

// 			case DialogueNodeVariantItemCheck:
// 				choice_idx := 0

// 				if has_inventory_item(v.item) {
// 					choice_idx = 0
// 				} else {
// 					choice_idx = 1
// 				}

// 				go_to_next_node(d, i, choice_idx)
// 		}
// 	}
// }

// DialogueAutoAdvanceLengthDivisor :: 14.5

// jump_into_rocket :: proc(skip_animation: bool) {
// 	if r, ok := get_entity(g_mem.rocket, Rocket); ok {
// 		g_mem.next_controlled_entity = g_mem.rocket
// 		destroy_entity(&g_mem.world, g_mem.cat)
// 		g_mem.cat = EntityHandleNone
// 		r.cat_inside = true
// 		r.cat_inside_time = 0

// 		if !skip_animation {
// 			r.renderables[0] = animated_renderable(.RocketCatJumpIn, 0.1, one_shot = true)
// 			r.renderables[0].offset = {-13, 0}
// 			r.doing_jump_in_anim = true
// 			r.oneshot_done_event = .CatJumpedIn
// 		}

// 		g_mem.interactable_in_range = {}
// 		g_mem.camera_state.pause_camera_until = g_mem.time + 1.5
// 	}
// }

// got_egg_change_world :: proc() {
// 	oak := find_entity_with_tag(.Oak)

// 	if o := get_entity_raw(oak); o != nil {
// 		oak_tex := get_texture_by_name(.OakBase)
// 		stump_tex := get_texture_by_name(.Stump2)
// 		diff := oak_tex.height - stump_tex.height
// 		o.renderables[0] = { texture = get_texture_handle(.Stump2) }
// 		o.pos.y += f32(diff/2)
// 	}

// 	before := find_entities_with_tag(.BeforeEgg)

// 	for b in before {
// 		disable_entity(b)
// 	}

// 	after := find_entities_with_tag(.AfterEgg)

// 	for a in after {
// 		enable_entity(&g_mem.world, a)
// 	}

// 	squirrel := find_entity_with_tag(.Squirrel)

// 	if s := get_entity_raw(squirrel); s != nil {
// 		s.facing = .East
// 		s.flip_x = false
// 		s.renderables[0] = animated_renderable(.Squirrel, 0.2)
// 	}
// }

// do_event :: proc(e: Event) {
// 	switch v in e {
// 		case EventAngryDoorOpened:
// 			if d := get_entity_raw(v.door); d != nil {
// 				d.interactable = true
// 				d.dialogue_name = .Door
// 				d.renderables[0] = animated_renderable(.DoorFace, 0.2, is_animating = false, animate_when_interacted_with = true, relative_layer = 1, offset = {-1, 10})
// 				start_dialogue(d.handle, d.dialogue_name, false)
// 				d.interactable_offset = {0, 30}
// 				d.interactable_icon_offset = {0, -35}
// 				d.use_item_handler = .AngryDoorOpened
// 			}

// 		case EventCatEnterRocket:
// 			jump_into_rocket(false)

// 		case EventCatEnterRocketInFrontOfOak:
// 			set_progress(.WentUpToOakTop)
// 			jump_into_rocket(false)
// 			play_sound_alias(.RocketEngine0)
// 			if r, ok := get_entity(g_mem.rocket, Rocket); ok {
// 				r.state = .ExternallyControlledCameraFollowEaseIn

// 				spline := find_entity_with_tag(.FlyUpOakSpline)

// 				spv := SplineEvaluator {
// 					target = g_mem.rocket,
// 					spline = spline,
// 					interactable_on_done = true,
// 				}

// 				add_entity(world, Entity {
// 					variant = spv,
// 				})
// 			}

// 		case EventCatEnterRocketInSpace:
// 			jump_into_rocket(false)

// 		case EventRocketSplineDone:
// 			if r, ok := get_entity(g_mem.rocket, Rocket); ok {
// 				if s, ok := get_entity(v.spline, Spline); ok {
// 					rocket_spline_done(r, s)
// 				}
// 			}

// 		case EventReleaseHang:
// 		case EventGotOnionSeed:
// 			sq := find_entity_with_tag(.Squirrel)

// 			if e := get_entity_raw(sq); e != nil {
// 				e.facing = .West
// 			}

// 		case EventEggShake:
// 			g_mem.camera_state.shake_until = g_mem.time + 2
// 			g_mem.camera_state.shake_amp = 1
// 			g_mem.camera_state.shake_freq = 100
// 			send_delayed_event(EventSaySingleLine { entity = g_mem.cat, line = strings.clone("WHAT WAS THAT?") }, 2.1)

// 		case EventGotEgg:
// 			send_delayed_event(EventEggShake{}, 3)
// 			got_egg_change_world()
// 			set_progress(.GotEgg)
// 			g_mem.save.checkpoint = .PlanetGotEgg
// 			save_game_to_disk()
// 		case EventFlyToBookShelf:
// 			rocket := g_mem.rocket

// 			if r, ok := get_entity(rocket, Rocket); ok {

// 			}

// 		case EventSetProgressFlag:
// 			set_progress(v.flag)

// 		case EventTalkToEntity:
// 			if e := get_entity_raw(v.entity); e != nil && e.dialogue_name != .None {
// 				start_dialogue(v.entity, e.dialogue_name, v.auto_advance)
// 			}

// 		case EventGetItem:
// 			add_to_inventory(v.item, v.from_pos, v.has_from_pos)

// 		case EventSaySingleLine:
// 			say_single_line(v.entity, v.line, no_sound = v.no_sound)
// 			delete(v.line)

// 		case EventAnimateAlongSpline:
// 			animate_along_spline(v.entity, v.spline)

// 		case EventAcornOpen:
// 			acorn := find_entity_with_tag(.Acorn)

// 			if a := get_entity_raw(acorn); a != nil {
// 				e := create_entity_from_entity_kind(.AcornAnimator)
// 				e.pos = a.pos + {-2, -8}
// 				add_entity(world, e)

// 				cs := find_entity_with_tag(.CatIntoAcornSpline)
// 				rs := find_entity_with_tag(.RocketIntoAcornSpline)

// 				if cs != EntityHandleNone {
// 					e := Entity {
// 						variant = SplineEvaluator {
// 							target = g_mem.cat,
// 							spline = cs,
// 						},
// 					}

// 					add_entity(world, e)
// 				}

// 				if c, ok := get_entity(g_mem.cat, PlayerCat); ok {
// 					set_state(c, PlayerStateFloating{})
// 				}

// 				if rs != EntityHandleNone {
// 					e := Entity {
// 						variant = SplineEvaluator {
// 							target = g_mem.rocket,
// 							spline = rs,
// 						},
// 					}

// 					add_entity(world, e)
// 				}
// 			}

// 		case EventEndAcornSpace:
// 			set_game_state(GameStateDefault{})
// 			set_progress(.SpaceEnded)
// 			g_mem.next_level_name = .Planet
// 			g_mem.load_next_level = true

// 		case EventFloatIntoAir:
// 			if c, ok := get_entity(g_mem.cat, PlayerCat); ok {
// 				set_state(c, PlayerStateFloatingToEnd { squirrel_pos_x_start = entity_pos(find_entity_of_kind(.Squirrel)).x } )
// 				g_mem.controlled_entity = EntityHandleNone
// 			}

// 		case EventFlyOutFromPlanet:
// 			set_game_state(GameStateDefault{})

// 			if r, ok := get_entity(g_mem.rocket, Rocket); ok {
// 				r.state = .FlyingUp
// 				r.time_in_state = 0
// 			}

// 		case EventTeleportEntity:
// 			e := get_entity_raw(v.entity)
// 			t := get_entity_raw(v.target)

// 			if e != nil && t != nil {
// 				e.pos = t.pos
// 			}

// 		case EventHideRenderable:
// 			if e := get_entity_raw(v.entity); e != nil {
// 				if v.renderable < MaxRenderables {
// 					e.renderables[v.renderable] = {}
// 				}
// 			}

// 		case EventFadeRenderable:
// 			append(&world.fading_renderables, FadingRenderable {
// 				entity = v.entity,
// 				renderable = v.renderable,
// 				fade_time = v.fade_time,
// 				fade_in = v.fade_in,
// 			})

// 		case EventRemoveColliderAndAnimate:
// 			remove_colliders_for_entity(world, v.entity)

// 			if e := get_entity_raw(v.entity); e != nil {
// 				if v.renderable < MaxRenderables {
// 					e.renderables[v.renderable].is_animating = true
// 				}
// 			}

// 		case EventStartAnimating:
// 			if e := get_entity_raw(v.entity); e != nil {
// 				if v.renderable < MaxRenderables {
// 					e.renderables[v.renderable].is_animating = true
// 				}
// 			}

// 		case EventCheckIfAllPortraitsHung:
// 			if !has_inventory_item(.KluckePortrait) && !has_inventory_item(.LakritsPortrait) && !has_inventory_item(.LillemorPortrait) && !has_inventory_item(.PontusPortrait) {
// 				s := find_entity_with_tag(.EndingSplineEnterSquirrel)

// 				if spl, ok := get_entity(s, Spline); ok {
// 					sr := Entity {
// 						renderables = {
// 							0 = animated_renderable(.SpaceOnionTalkOutline, 0.15, is_animating = false, animate_when_interacted_with = true ),
// 							1 = rocket_fire_renderable(),
// 							2 = { texture = get_texture_handle(.SquirrelInRocket), offset = {-1, -1}, relative_layer = 1 },
// 						},
// 						num_renderables = 3,
// 						pos = spline_first_point(spl),
// 						layer = 8,
// 						interactable = true,
// 						dialogue_name = .RocketSquirrel,
// 						interactable_offset = {0, 10},
// 						interactable_icon_offset = {-7, -25},
// 						interactable_dir_from_facing = true,
// 						flip_with_facing = false,
// 						facing = .West,
// 						interaction_position_offset = 25,
// 						tag = .SquirrelRocket,
// 						examine_text = "What is this, A CROSS-OVER EPISODE? Squirrel and the Space Onion has teamed up!",
// 					}

// 					squirrel_rocket := add_entity(world, sr)

// 					animate_along_spline(squirrel_rocket, s, EventHideRenderable{entity = squirrel_rocket, renderable = 1})
// 				}

// 				//send_delayed_event(EventAnimateAlongSpline { entity = find_entity_with_tag(.PancakeStack), spline = find_entity_with_tag(.PancakeStackSpline)}, 1)
// 				//enter_end_state()
// 			} else {
// 				send_delayed_event(EventCheckIfAllPortraitsHung{}, 0.5)
// 			}

// 		case EventJumpIntoBatter:
// 			if c, ok := get_entity(g_mem.cat, PlayerCat); ok {
// 				spline := find_entity_with_tag(.JumpIntoBatterSpline)
// 				set_state(c, PlayerStateEnterEnd{ player_spline = spline })
// 				e := Entity {
// 					variant = SplineEvaluator {
// 						target = c.handle,
// 						spline = spline,
// 					},
// 				}

// 				add_entity(world, e)
// 			}
// 		case EventPlaySound:
// 			play_sound_alias(v.sound)

// 		case EventFadePortraitToCat:
// 			/*p_lakrits := get_texture_handle(.LakritsPortrait)
// 			p_klucke := get_texture_handle(.KluckePortrait)
// 			p_lillemor := get_texture_handle(.LillemorPortrait)
// 			p_pontus := get_texture_handle(.PontusPortrait)*/

// 			if e := get_entity_raw(v.easel); e != nil {
// 				tex: TextureHandle
// 				offset: Vec2
// 				dialogue: DialogueName
// 				tag: Tag

// 				switch v.portrait {
// 					case .Klucke:
// 						tex = get_texture_handle(.KluckeIdle)
// 						offset = {-1, -7}
// 						dialogue = .Klucke
// 						tag = .EndKlucke
// 					case .Lakrits:
// 						tex = get_texture_handle(.LakritsIdle)
// 						offset = {2, -8}
// 						dialogue = .Lakrits
// 						tag = .EndLakrits
// 					case .Lillemor:
// 						tex = get_texture_handle(.LillemorIdle)
// 						offset = {2, -7}
// 						dialogue = .Lillemor
// 						tag = .EndLillemor
// 					case .Pontus:
// 						tex = get_texture_handle(.PontusIdle)
// 						offset = {4, -8}
// 						dialogue = .Pontus
// 						tag = .EndPontus
// 				}

// 				e.renderables[2] = {
// 					texture = tex,
// 					color = {},
// 					apply_color = true,
// 					offset = {0, 3},
// 				}
// 				e.num_renderables = 3
// 				e.interactable_icon_offset = offset
// 				e.tag = tag
// 				e.use_item_handler = .None

// 				send_event(EventFadeRenderable { entity = v.easel, renderable = 0, fade_time = 2})
// 				send_event(EventFadeRenderable { entity = v.easel, renderable = 1, fade_time = 2})
// 				send_event(EventFadeRenderable { entity = v.easel, renderable = 2, fade_time = 2, fade_in = true})

// 				e.dialogue_name = dialogue
// 				e.interactable = true

// 				set_progress(.AnyCats)
// 			}

// 		case EventStartEnd:
// 			enter_end_state()

// 		case EventOpenCave:
// 			open_cave()

// 		case EventDestroyEntityWithTag:
// 			destroy_entity(world, find_entity_with_tag(v.tag))

// 		case EventFadeEntityWithTag:
// 			e := find_entity_with_tag(v.tag)

// 			send_event(EventFadeRenderable{entity = e, renderable = 0, fade_time = 1})


// 		case EventSetRenderable:
// 			if e := get_entity_raw(v.entity); e != nil {
// 				if v.renderable_idx < MaxRenderables && v.renderable_idx >= 0 {
// 					e.renderables[v.renderable_idx] = v.renderable

// 					if v.renderable_idx >= e.num_renderables {
// 						e.num_renderables = min(e.num_renderables + 1, MaxRenderables)
// 					}
// 				}
// 			}

// 		case EventFlourThrown:
// 			make_rock_wall_floured(v.wall)

// 		case EventFadeOutMusic:
// 			music_fade(&g_mem.music)

// 		case EventPutSeedInSoil:
// 			handle_put_seed_in_soil(v)

// 		case EventFadeOutBird:
// 			b := find_entity_of_kind(.Bird)

// 			if be := get_entity_raw(b); be != nil {
// 				be.interactable = false
// 			}

// 			send_event(EventFadeRenderable{entity = b, renderable = 0, fade_time = 3})
// 	}
// }

// make_rock_wall_floured :: proc(wall: EntityHandle) {
// 	if e := get_entity_raw(wall); e != nil {
// 		rect_pos := pos_from_rect(e.collider)

// 		climb_high_trigger := Entity {
// 			pos = e.pos + rect_pos - {10, 0},
// 			variant = Trigger {
// 				rect = pad_rect(rect_from_size(size_from_rect(e.collider)), 10, 0),
// 				name = .ClimbHighVolume,
// 			},
// 		}
// 		add_entity(world, climb_high_trigger)

// 		e.renderables[1] = {
// 			texture = get_texture_handle(.RockWallChalk),
// 			relative_layer = 1,
// 		}

// 		e.num_renderables = 2

// 		if !get_progress(.HasFlouredWall) {
// 			player_say("The wall is extra grippy now! It'll be like climbing a mountain of pastries")
// 			set_progress(.HasFlouredWall)
// 		}
// 	}
// }

// update_default :: proc() {
// 	g_mem.camera_state.zoom = default_game_camera_zoom()
// 	profile_scope()

// 	gather_input()

// 	if _, ok := g_mem.show_portrait.?; ok {
// 		return
// 	}

// 	g_mem.time += f64(dt)

// 	for i := 0; i < len(g_mem.delayed_events); i += 1{
// 		de := &g_mem.delayed_events[i]
// 		de.delay -= dt

// 		if de.delay <= 0 {
// 			append(&g_mem.next_events, de.event)
// 			unordered_remove(&g_mem.delayed_events, i)
// 			i -= 1
// 		}
// 	}

// 	g_mem.events = slice.clone(g_mem.next_events[:], context.temp_allocator)
// 	clear(&g_mem.next_events)

// 	g_mem.had_active_interactions_this_frame = false

// 	ai_loop: for idx := 0; idx < len(g_mem.active_interactions); {
// 		switch &i in g_mem.active_interactions[idx] {
// 			case InteractionDialogue:
// 				if i.done {
// 					delete_interaction(g_mem.active_interactions[idx])
// 					unordered_remove(&g_mem.active_interactions, idx)
// 					continue ai_loop
// 				}
// 				update_interaction_dialogue(&i)
// 				if i.done {
// 					delete_interaction(g_mem.active_interactions[idx])
// 					unordered_remove(&g_mem.active_interactions, idx)
// 					continue ai_loop
// 				}

// 			case nil:
// 				unordered_remove(&g_mem.active_interactions, idx)
// 				continue ai_loop
// 		}

// 		idx += 1
// 	}


// 	for cloud in world.clouds {
// 		if c := get_entity_raw(cloud.entity); c != nil {
// 			c.pos += cloud.vel * dt

// 			if c.pos.x > world.clouds_max_x {
// 				c.pos.x = world.clouds_start_x
// 			}
// 		}
// 	}

// 	for i: int; i<len(world.fading_renderables); {
// 		f := &world.fading_renderables[i]
// 		e := get_entity_raw(f.entity)
// 		r := f.renderable

// 		if r >= MaxRenderables || e == nil {
// 			world.fading_renderables[i] = pop(&world.fading_renderables)
// 			continue
// 		}

// 		if f.started == false {
// 			f.started = true
// 			f.fade_start = g_mem.time

// 			if f.fade_in {
// 				f.fade_start_color = rl.Color{}
// 			} else {
// 				f.fade_start_color = e.renderables[r].apply_color ? e.renderables[r].color : rl.WHITE
// 			}
// 		}

// 		e.renderables[r].apply_color = true

// 		if g_mem.time > f.fade_start + f64(f.fade_time) {
// 			if f.fade_in {
// 				e.renderables[r].color = rl.WHITE
// 			} else {
// 				e.renderables[r].color = {}
// 			}

// 			world.fading_renderables[i] = pop(&world.fading_renderables)
// 			continue
// 		}

// 		if f.fade_in {
// 			e.renderables[r].color = lerp_color(f.fade_start_color, rl.WHITE, f32(linalg.smoothstep(f.fade_start, f.fade_start + f64(f.fade_time), g_mem.time)))
// 		} else {
// 			e.renderables[r].color = lerp_color(f.fade_start_color, rl.Color {}, f32(linalg.smoothstep(f.fade_start, f.fade_start + f64(f.fade_time), g_mem.time)))
// 		}

// 		i += 1
// 	}

// 	for e in g_mem.events {
// 		do_event(e)
// 	}

// 	when CAT_DEV {
// 		if rl.IsKeyPressed(.T) {
// 			if p, ok := get_entity(g_mem.cat, PlayerCat); ok {
// 				p.pos = mouse_world_position(get_camera(g_mem.camera_state.pos, g_mem.camera_state.zoom))
// 				p.vel = {}
// 				set_state(p, PlayerStateNormal{})
// 				g_mem.controlled_entity = p.handle
// 				g_mem.camera_state.wanted_y = p.pos.y
// 			}
// 		}
// 	}

// 	currently_speaking_entity: EntityHandle

// 	for ai in g_mem.active_interactions {
// 		if i, ok := ai.(InteractionDialogue); ok {
// 			if i.single_line != "" && i.entity != EntityHandleNone {
// 				currently_speaking_entity = i.entity
// 				continue
// 			}

// 			t := world.dialogue_trees[i.dialogue]

// 			if i.current_node < len(t.nodes) {
// 				node := t.nodes[i.current_node]

// 				if nn, ok := node.variant.(DialogueNodeVariantNormal); ok {
// 					if nn.actor == .Entity && !i.current_node_do_choices && !nn.dont_animate {
// 						currently_speaking_entity = i.entity
// 					}
// 				}
// 			}
// 		}
// 	}

// 	profile_start("update closest interactable")
// 	g_mem.interactable_in_range = {}
// 	if g_mem.time > g_mem.disable_interaction_until {
// 		closest_interactable := max(f32)

// 		ent_iter := ha_make_iter(g_mem.world.entities)
// 		for e, eh in ha_iter_ptr(&ent_iter) {
// 			if e.disabled || !e.interactable || eh == g_mem.controlled_entity {
// 				continue
// 			}

// 			if closest, dist := is_closer_interactable(eh, g_mem.controlled_entity, closest_interactable, e.interactable_distance == 0 ? InteractMaxDistance : e.interactable_distance); closest {
// 				if p, ok := get_entity(g_mem.controlled_entity, PlayerCat); ok && reflect.union_variant_typeid(p.state) == PlayerStateNormal {
// 					g_mem.interactable_in_range = eh
// 					closest_interactable = dist
// 				}
// 			}
// 		}
// 	}
// 	profile_end()

// 	profile_start("update entities")
// 	ent_iter := ha_make_iter(g_mem.world.entities)
// 	for e, eh in ha_iter_ptr(&ent_iter) {
// 		if e.disabled {
// 			continue
// 		}

// 		for ri in 0 ..< e.num_renderables {
// 			r := &e.renderables[ri]

// 			if r.type == .Animation {
// 				should_animate := r.is_animating || (currently_speaking_entity == eh && r.animate_when_interacted_with)

// 				if r.animate_when_interacted_with && currently_speaking_entity != eh {
// 					r.cur_frame = 0
// 					r.frame_timer = r.frame_length
// 					should_animate = true
// 				}

// 				if should_animate && r.frame_length > 0 && r.num_frames > 0 {
// 					r.frame_timer -= dt

// 					if r.frame_timer <= 0 {
// 						r.cur_frame += 1

// 						if r.cur_frame >= r.num_frames {
// 							if r.one_shot {
// 								r.cur_frame = r.num_frames - 1
// 								r.is_animating = false
// 							} else {
// 								r.cur_frame = 0
// 							}

// 							r.num_loops += 1
// 						}

// 						if !r.one_shot || r.one_shot && r.num_loops == 0 {
// 							play_animation_frame_sound(r.texture_name, r.cur_frame)
// 						}

// 						r.frame_timer = r.frame_length
// 					}

// 					renderable_update_rect(r)
// 				}
// 			}
// 		}

// 		#partial switch &v in e.variant {
// 			case PlayerCat:
// 				cat_update(entity_inst(e, &v))

// 			case Rocket:
// 				rocket_update(entity_inst(e, &v))

// 			case AnimatedObject:
// 				if v.playing {
// 					update_animation(&v.anim, v.oneshot)
// 				}

// 				if v.anim.frame_length == 0.75 {
// 					e.pos.x = -90 + f32(math.round(math.cos(g_mem.time*20)))
// 				}

// 				e.num_renderables = 1
// 				e.renderables[0] = {
// 					texture = v.anim.anim.texture,
// 					rect = animation_rect(&v.anim, false),
// 				}

// 			case SplineEvaluator:
// 				if s, ok := get_entity(v.spline, Spline); ok {
// 					if t := get_entity_raw(v.target); t != nil {
// 						pos, rot, scl, speed_mult, done := eval_spline(s, v.time, t.pos)
// 						t.pos = pos

// 						if v.camera_follow {
// 							g_mem.camera_state.pos = t.pos
// 						}

// 						t.rot = rot

// 						if s.dont_scale == false {
// 							t.scale = scl
// 						}

// 						v.time += dt * speed_mult

// 						if done {
// 							if i, ok := get_entity(v.on_done, Usable); ok {
// 								use_usable(i)
// 							}

// 							if v.on_done_event != nil {
// 								send_event(v.on_done_event)
// 							}

// 							t.interactable = v.interactable_on_done
// 							destroy_entity(world, e.handle)

// 							if s.on_done_event != nil {
// 								send_event(s.on_done_event)
// 							}
// 						}
// 					}
// 				}

// 			case AcornAnimator:
// 				g_mem.controlled_entity = EntityHandleNone

// 				tr := f32(g_mem.time - e.enabled_at)

// 				acorn := find_entity_with_tag(.Acorn)

// 				if a := get_entity_raw(acorn); a != nil {
// 					a.renderables[2].offset -= {0, tr}
// 				}


// 				if tr > 0.5 && tr < 2 {
// 					draw_dialogue_bubble("Oooo aaaAAAA", .Player, g_mem.cat, tr - 0.5)
// 				}

// 				tz := remap(tr, 0, 12, 0, 1)
// 				tp := remap(tr, 0, 4, 0, 1)
// 				zoom: f32 = 200
// 				zoom_inv := 1.0/zoom
// 				g_mem.camera_state.zoom = math.lerp(v.start_zoom, default_game_camera_zoom() * zoom, tz*tz*tz*tz*tz)
// 				g_mem.camera_state.pos = math.lerp(v.start_pos, e.pos, mix(smooth_start2, smooth_stop2, tp, tp))

// 				cate := get_entity_raw(v.cat)

// 				if cate != nil {
// 					r := remap(tr, 1, 5, 0, 1)
// 					rr := mix(smooth_start2, smooth_stop2, r, r)
// 					cate.scale = 1-rr*(1-zoom_inv)
// 				}

// 				rockete, rocket_ok := get_entity(v.rocket, Rocket)
// 				rockete.state = .ExternallyControlled
// 				rockete.renderables[1] = {}

// 				if rocket_ok {
// 					r := remap(tr, 1, 5, 0, 1)
// 					rr := mix(smooth_start2, smooth_stop2, r, r)
// 					rockete.scale = 1-rr*(1-zoom_inv)
// 				}

// 				if tr > 5 {
// 					camera_in_next_level_pos := Vec2 {-33, -26}

// 					if cate != nil {
// 						if !v.cat_lerp_start_pos_set {
// 							v.cat_lerp_start_pos_set = true
// 							v.cat_lerp_start_pos = cate.pos
// 						}
// 						cat_in_next_level_pos := Vec2 {-72, -8}
// 						final_pos := e.pos + (cat_in_next_level_pos - camera_in_next_level_pos) * zoom_inv
// 						lt := remap(tr, 5, 11.5, 0, 1)
// 						cate.pos = math.lerp(v.cat_lerp_start_pos, final_pos, mix(smooth_start2, smooth_stop2, lt, lt))
// 					}

// 					if rocket_ok {
// 						if !v.rocket_lerp_start_pos_set {
// 							v.rocket_lerp_start_pos_set = true
// 							v.rocket_lerp_start_pos = rockete.pos
// 						}
// 						rocket_in_next_level_pos := Vec2 {0, -16}
// 						final_pos := e.pos + (rocket_in_next_level_pos - camera_in_next_level_pos) * zoom_inv
// 						lt := remap(tr, 5, 11.5, 0, 1)
// 						rockete.pos = math.lerp(v.rocket_lerp_start_pos, final_pos, mix(smooth_start2, smooth_stop2, lt, lt))
// 					}
// 				}

// 				if tr >= 12 {
// 					g_mem.next_level_name = .Space
// 					g_mem.load_next_level = true
// 				}
// 		}
// 	}
// 	profile_end()

// 	if input.toggle_menu && reflect.union_variant_typeid(g_mem.root_state) != RootStateIngameMenu && reflect.union_variant_typeid(g_mem.root_state) != RootStateMainMenu {
// 		g_mem.root_state = RootStateIngameMenu{}
// 	}
// }

// open_cave :: proc() {
// 	cave := find_entity_with_tag(.CaveFace)

// 	if ce := get_entity_raw(cave); ce != nil {
// 		ce.renderables[0] = animated_renderable(.CaveFace, 0.15, is_animating = true, one_shot = true)
// 	}

// 	remove_colliders_for_entity(world, cave)
// 	set_progress(.CaveOpened)
// }

// PickupAnimateTime :: 1

// draw_default :: proc() {
// 	profile_scope()

// 	profile_start("clear")
// 	rl.ClearBackground(g_mem.clear_color)
// 	screen_rectangle := Rect { 0, 0, screen_width(), screen_height() }
// 	profile_end()

// 	gs := gui_scale()

// 	item_s_no_scale :: 12
// 	item_s := item_s_no_scale * gs
// 	item_padding_no_scale :: 2
// 	item_padding := item_padding_no_scale * gs
// 	all_actions := get_all_player_actions()

// 	_, inv_row := split_rect_bottom(screen_rectangle, item_s + item_padding, item_padding)
// 	inv_row.height -= item_padding
// 	gpb := &settings.gamepad_bindings
// 	draw_world(get_camera(g_mem.camera_state), .All, 0, false)

// 	when CatProfile {
// 		dtms := rl.GetFrameTime() * 1000

// 		ft_avg[ft_avg_i] = dtms
// 		ft_avg_i += 1
// 		if ft_avg_i >= len(ft_avg) {
// 			ft_avg_i = 0
// 		}

// 		dt_n: f32
// 		for i in 0..<len(ft_avg) {
// 			dt_n += ft_avg[i]
// 		}

// 		dt_n /= len(ft_avg)

// 		if dtms > 20 {
// 			last_spike = dtms
// 		}

// 		if rl.IsKeyPressed(.F8) {
// 			g_mem.show_fps = !g_mem.show_fps
// 		}

// 		if g_mem.show_fps {
// 			pos := Vec2 { 4*gs, 4*gs }
// 			rl.DrawTextEx(g_mem.font, fmt.ctprintf("%.5f ms - last spike: %.5f ms", dt_n, last_spike), pos, 10*gs, 0, rl.WHITE)
// 		}

// 		if g_mem.profiling {
// 			pos := Vec2 { screen_width() - 14*gs, 4*gs }
// 			rl.DrawTextEx(g_mem.font, "P", pos, 10*gs, 0, rl.RED)
// 		}
// 	}

//  	if c, ok := get_entity(g_mem.cat, PlayerCat); ok && g_mem.controlled_entity == g_mem.cat && !g_mem.hide_hud && g_mem.show_portrait == nil {
//  		in_dialogue := reflect.union_variant_typeid(c.state) == PlayerStateInteracting || g_mem.had_active_interactions_this_frame

// 		num_actions := len(all_actions)

// 		if g_mem.selected_action > num_actions {
// 			g_mem.selected_action = max(0, num_actions - 1)
// 		}

// 		if input.prev_item && !in_dialogue {
// 			g_mem.selected_action -= 1

// 			if g_mem.selected_action < 0 {
// 				g_mem.selected_action = num_actions - 1
// 			}

// 			play_sound_alias(.MenuUp)
// 		}

// 		if input.next_item && !in_dialogue {
// 			g_mem.selected_action += 1

// 			if g_mem.selected_action >= num_actions {
// 				g_mem.selected_action = 0
// 			}

// 			play_sound_alias(.MenuDown)
// 		}

// 		flash_idx := -1

// 		for a, idx in all_actions {
// 			if a.type == .Pickup && check_if_in_trigger(get_default_collider(c.pos), .FlashButterPickup) {
// 				flash_idx = idx
// 			}

// 			if a.type == .Talk && check_if_in_trigger(get_default_collider(c.pos), .FlashTalk) {
// 				flash_idx = idx
// 			}

// 			if a.type == .UseItem && a.item == .Butter && check_if_in_trigger(get_default_collider(c.pos), .FlashButter) {
// 				flash_idx = idx
// 			}
// 		}

// 		if !get_progress(.HideTutorialStuff) {
// 			arrow := get_texture_handle(.UiArrow)
// 			actions_row_start := pos_from_rect(inv_row)

// 			if input.gamepad {
// 				{
// 					left_arrow_bg_pos := actions_row_start + {2*gs, inv_row.height/2 - 3 * gs}
// 					pvth := get_gamepad_glyph(gpb[.PreviousItem], settings.gamepad_type)

// 					if at, ok := get_texture(arrow); ok {
// 						source := draw_texture_source_rect(at, false)
// 						dest := rect_from_pos_size(left_arrow_bg_pos, size_from_rect(source) * gs)
// 						rl.DrawTexturePro(at, source, dest, {}, 0, rl.WHITE)
// 						inv_row.x += dest.width
// 					}

// 					if pvt, ok := get_texture(pvth); ok {
// 						pvtw := f32(pvt.width)
// 						source := draw_texture_source_rect(pvt, false)
// 						dest := rect_from_pos_size(actions_row_start + {10, 1}*gs, size_from_rect(source) * gs)
// 						rl.DrawTexturePro(pvt, source, dest, {}, 0, rl.WHITE)
// 						inv_row.x += dest.width - 1*gs
// 					}
// 				}

// 				actions_row_end := pos_from_rect(inv_row) + {f32(len(all_actions))*item_s_no_scale + item_padding_no_scale*(f32(len(all_actions)) - 1), 0} * gs

// 				{
// 					right_binding_pos := actions_row_end + {4*gs, inv_row.height/2 - 3 * gs}
// 					pvth := get_gamepad_glyph(gpb[.NextItem], settings.gamepad_type)
// 					pvt, pvt_ok := get_texture(pvth)

// 					if at, ok := get_texture(arrow); ok {
// 						source := draw_texture_source_rect(at, true)
// 						dest := rect_from_pos_size(right_binding_pos + {pvt_ok ? f32(pvt.width-3) : 0, 0}*gs, size_from_rect(source) * gs)
// 						rl.DrawTexturePro(at, source, dest, {}, 0, rl.WHITE)
// 					}

// 					if pvt_ok {
// 						pvtw := f32(pvt.width)
// 						source := draw_texture_source_rect(pvt, false)
// 						dest := rect_from_pos_size(right_binding_pos + {0, -2}*gs, size_from_rect(source) * gs)
// 						rl.DrawTexturePro(pvt, source, dest, {}, 0, rl.WHITE)
// 					}
// 				}
// 			} else {
// 				draw_keyboard_binding_ui :: proc(binding: Binding, pos: Vec2, dont_draw: bool = false) -> Vec2 {
// 					pos := pos
// 					gs := gui_scale()
// 					bt := keyboard_binding_text(binding)
// 					bts := rl.MeasureTextEx(g_mem.dialogue_font, temp_cstring(bt), 8, 0)
// 					binding_bg := rect_from_pos_size(pos, bts * gs)
// 					binding_bg.height -= 1 * gs
// 					binding_bg.y += 2 * gs
// 					binding_bg.width += 2*gs
// 					pos.x += 1*gs
// 					pos.y += 1.5*gs

// 					if dont_draw {
// 						return size_from_rect(binding_bg)
// 					}

// 					render_rectangle(pad_rect(binding_bg, 0*gs, 1*gs), ColorCat)
// 					render_rectangle(pad_rect(binding_bg, 1*gs, 0*gs), ColorCat)
// 					render_rectangle(binding_bg, ColorDark)
// 					rl.DrawTextEx(g_mem.dialogue_font, temp_cstring(bt), pos, 8*gs, 0, ColorCat)
// 					return size_from_rect(binding_bg)
// 				}

// 				{
// 					left_arrow_bg_pos := actions_row_start + {2*gs, inv_row.height/2 - 3 * gs}

// 					if at, ok := get_texture(arrow); ok {
// 						source := draw_texture_source_rect(at, false)
// 						dest := rect_from_pos_size(left_arrow_bg_pos, size_from_rect(source) * gs)
// 						rl.DrawTexturePro(at, source, dest, {}, 0, rl.WHITE)
// 					}

// 					drawn_size := draw_keyboard_binding_ui(.PreviousItem, left_arrow_bg_pos + {9, -2}*gs)
// 					inv_row.x += (drawn_size.x + 12 * gs)
// 				}

// 				actions_row_end := pos_from_rect(inv_row) + {f32(len(all_actions))*item_s_no_scale + item_padding_no_scale*(f32(len(all_actions)) - 1), 0} * gs

// 				{
// 					right_binding_pos := actions_row_end + {4 * gs, inv_row.height/2 - 3 * gs}
// 					binding_size := draw_keyboard_binding_ui(.NextItem, right_binding_pos + {1, -2}*gs, true)

// 					if at, ok := get_texture(arrow); ok {
// 						source := draw_texture_source_rect(at, true)
// 						dest := rect_from_pos_size(right_binding_pos + {binding_size.x - 1*gs, 0}, size_from_rect(source) * gs)
// 						rl.DrawTexturePro(at, source, dest, {}, 0, rl.WHITE)
// 					}
// 					draw_keyboard_binding_ui(.NextItem, right_binding_pos + {1, -2}*gs)
// 				}
// 			}
// 		}

// 		arrow_down := get_texture_by_name(.UiArrowDown)

// 		for a, idx in all_actions {
// 			tex := get_player_action_texture(a)

// 			selected := g_mem.selected_action == idx

// 			if selected && !in_dialogue {
// 				arrow_source := draw_texture_source_rect(arrow_down, false)
// 				arrow_dest := rect_from_pos_size(pos_from_rect(inv_row) + {5.5, -4}*gs, size_from_rect(arrow_source) * gs)
// 				text: string

// 				switch a.type {
// 					case .UseItem:
// 						text = item_name[a.item]
// 					case .Talk:
// 						text = "Talk"
// 					case .Pickup:
// 						text = "Pickup"
// 					case .Inspect:
// 						text = "Inspect"
// 				}

// 				ctext := temp_cstring(text)
// 				ts := rl.MeasureTextEx(g_mem.dialogue_font, ctext, 7, 0)

// 				text_pos := rect_top_left(arrow_dest) + {-ts.x/2 + 2, -7}*gs

// 				if text_pos.x < 5*gs {
// 					text_pos.x += math.abs(text_pos.x) + 5*gs
// 				}
// 				bg_rect := pad_rect(rect_from_pos_size(text_pos, {ts.x*gs, 7 * gs}), 2 * gs, 0)
// 				bg_rect.width += 2 * gs
// 				render_rectangle(pad_rect(bg_rect, 1*gs, 1*gs), ColorCat)
// 				render_rectangle(bg_rect, ColorDark)
// 				rl.DrawTextEx(g_mem.dialogue_font, ctext, text_pos, 7*gs, 0, ColorCat)
// 				rl.DrawTexturePro(arrow_down, arrow_source, arrow_dest, {}, 0, rl.WHITE)

// 				if input.gamepad {
// 					useth := get_gamepad_glyph(gpb[.Use], settings.gamepad_type)
// 					if uset, ok := get_texture(useth); ok {
// 						use_source := draw_texture_source_rect(uset, false)
// 						use_dest := rect_from_pos_size(rect_top_right(bg_rect) + {f32(-4 + 2), -2}*gs, size_from_rect(use_source) * gs)
// 						rl.DrawTexturePro(uset, use_source, use_dest, {}, 0, rl.WHITE)
// 					}
// 				} else {
// 					bt := keyboard_binding_text(.Use)
// 					draw_pos := rect_top_right(bg_rect) + {f32(-3 + 2), -2}*gs
// 					bts := rl.MeasureTextEx(g_mem.dialogue_font, temp_cstring(bt), 8, 0)
// 					binding_bg := rect_from_pos_size(draw_pos, bts * gs)
// 					binding_bg.height -= 1 * gs
// 					binding_bg.y += 2 * gs
// 					binding_bg.width += 2*gs
// 					draw_pos.x += 1*gs
// 					draw_pos.y += 1.5*gs
// 					render_rectangle(pad_rect(binding_bg, 0*gs, 1*gs), ColorCat)
// 					render_rectangle(pad_rect(binding_bg, 1*gs, 0*gs), ColorCat)
// 					render_rectangle(binding_bg, ColorDark)
// 					rl.DrawTextEx(g_mem.dialogue_font, temp_cstring(bt), draw_pos, 8*gs, 0, ColorCat)
// 				}
// 			}

// 			dest_bg_outline := cut_rect_left(&inv_row, item_s, item_padding)
// 			outline_color := selected ? ColorLight : ColorCat
// 			cur_time := g_mem.time

// 			if flash_idx == idx {
// 				if int(cur_time*2) % 2 == 0 {
// 					outline_color = ColorOrange
// 				}
// 			}

// 			render_rectangle(inset_rect(dest_bg_outline, 0*gs, 1*gs), outline_color)
// 			render_rectangle(inset_rect(dest_bg_outline, 1*gs, 0*gs), outline_color)

// 			dest_bg := inset_rect(dest_bg_outline, 1*gs, 1*gs)
// 			render_rectangle(dest_bg, ColorDark)

// 			if t := get_texture(tex); t.id != 0 {
// 				source := draw_texture_source_rect(t, false)
// 				dest := inset_rect(dest_bg, 1*gs, 1*gs)

// 				if source.height > source.width {
// 					ar := f32(source.width) / f32(source.height)
// 					new_width := ar * dest.width
// 					diff := dest.width - new_width
// 					dest.width = new_width
// 					dest.x += diff / 2
// 				} else if source.width > source.height {
// 					ar := f32(source.height) / f32(source.width)
// 					new_height := ar * dest.height
// 					diff := dest.height - new_height
// 					dest.height = new_height
// 					dest.y += diff / 2
// 				}

// 				sp, has_sp := a.item_original_screen_pos.?
// 				origin: Vec2

// 				if has_sp && cur_time < a.added_at + PickupAnimateTime {
// 					tt := f32(remap(cur_time, a.added_at, a.added_at + PickupAnimateTime, 0, 1))
// 					t := mix(smooth_start2, smooth_stop2, tt, tt)

// 					scl := 25 * t * t * (1 - t) * (1 - t) + 1

// 					dest.width *= scl
// 					dest.height *= scl

// 					anim_pos := math.lerp(sp, pos_from_rect(dest), t)
// 					origin = math.lerp(size_from_rect(dest)/2, Vec2{}, t)

// 					dest.x = anim_pos.x
// 					dest.y = anim_pos.y
// 				}

// 				rl.DrawTexturePro(t, source, dest, origin, 0, rl.WHITE)
// 			}
// 		}
// 	}

// 	if p, ok := g_mem.show_portrait.?; ok {
// 		t: rl.Texture
// 		f: rl.Texture
// 		plaque := get_texture_by_name(.Plaque)
// 		d: string

// 		switch p {
// 			case .Klucke:
// 				t = get_texture_by_name(.Klucke)
// 				f = get_texture_by_name(.KluckeFrame)
// 				d = portrait_descriptions[.Klucke]
// 			case .Lakrits:
// 				t = get_texture_by_name(.Lakrits)
// 				f = get_texture_by_name(.LakritsFrame)
// 				d = portrait_descriptions[.Lakrits]
// 			case .Lillemor:
// 				t = get_texture_by_name(.Lillemor)
// 				f = get_texture_by_name(.LillemorFrame)
// 				d = portrait_descriptions[.Lillemor]
// 			case .Pontus:
// 				t = get_texture_by_name(.Pontus)
// 				f = get_texture_by_name(.PontusFrame)
// 				d = portrait_descriptions[.Pontus]
// 		}

// 		source := draw_texture_source_rect(t, false)
// 		ar := f32(source.width) /  f32(source.height)

// 		screen_rectangle := Rect { 0, 0, screen_width(), screen_height() }
// 		h := screen_height() * (3.0/4)
// 		w := h * ar
// 		dest := rect_add_pos(rect_from_pos_size(rect_middle(screen_rectangle), {w, h}), {-w, -h/2 - screen_height() * (1.0/30)})
// 		rl.DrawTexturePro(t, source, dest, {}, 3, rl.WHITE)

// 		fsource := draw_texture_source_rect(f, false)
// 		rl.DrawTexturePro(f, fsource, dest, {}, 3, rl.WHITE)
// 		dest_br := rect_bottom_right(dest)

// 		s :: 8

// 		rl.SetTextLineSpacing(i32(5.5 * gs))

// 		ps := texture_size(plaque) * gs
// 		text_r := Rect {
// 			dest_br.x + 10 * gs, dest_br.y - ps.y/2 - h /2,
// 			ps.x,
// 			ps.y,
// 		}


// 		plaque_dest := draw_texture_dest_rect(plaque, pos_from_rect(text_r), gs)
// 		text_r = inset_rect(text_r, gs * 11, gs * 9)

// 		rl.DrawTexturePro(plaque, draw_texture_source_rect(plaque, false), plaque_dest,  {}, 0, rl.WHITE)
// 		lines := strings.split_lines(d, context.temp_allocator)

// 		for l in lines {
// 			if len(l) == 0 {
// 				text_r.y += 5 * gs
// 				continue
// 			}

// 			lc := temp_cstring(l)
// 			rl.DrawTextPro(g_mem.dialogue_font, lc, pos_from_rect(text_r), {}, 0, s*gs, 0, ColorLight)
// 			text_r.y += 7*gs
// 		}

// 		{
// 			text := "Put away"//input.gamepad ? "Put away" : fmt.tprintf("Put away: %v", keyboard_binding_text(.Use))

// 			close_pos := pos_from_rect(plaque_dest) + {4*gs, -16*gs}
// 			ts := rl.MeasureTextEx(g_mem.dialogue_font, temp_cstring(text), s*gs, 0)
// 			bg_rect := pad_rect(rect_from_pos_size(close_pos, ts), 2*gs, 0*gs)
// 			render_rectangle(pad_rect(bg_rect, 1*gs, 0), ColorCat)
// 			render_rectangle(pad_rect(bg_rect, 0, 1*gs), ColorCat)
// 			render_rectangle(bg_rect, ColorDark)
// 			rl.DrawTextPro(g_mem.dialogue_font, temp_cstring(text), close_pos, {}, 0, s*gs, 0, ColorLight)

// 			if input.gamepad {
// 				g := get_gamepad_glyph(gpb[.Use], settings.gamepad_type)

// 				if gt, ok := get_texture(g); ok {
// 					dest := draw_texture_dest_rect_scl(gt, rect_top_right(bg_rect) - {3*gs, 6*gs}, {gs,gs})
// 					source = draw_texture_source_rect(gt, false)
// 					rl.DrawTexturePro(gt, source, dest, {0, 0}, 0, rl.WHITE)
// 				}
// 			} else {
// 				bt := keyboard_binding_text(.Use)
// 				draw_pos := rect_top_right(bg_rect) + {0, 1}*gs
// 				bts := rl.MeasureTextEx(g_mem.dialogue_font, temp_cstring(bt), 8, 0)
// 				binding_bg := rect_from_pos_size(draw_pos, bts * gs)
// 				binding_bg.y -= 1 * gs
// 				binding_bg.width += 2*gs
// 				draw_pos.x += 1*gs
// 				draw_pos.y -= 1*gs
// 				render_rectangle(pad_rect(binding_bg, 0*gs, 1*gs), ColorCat)
// 				render_rectangle(pad_rect(binding_bg, 1*gs, 0*gs), ColorCat)
// 				render_rectangle(binding_bg, ColorDark)
// 				rl.DrawTextEx(g_mem.dialogue_font, temp_cstring(bt), draw_pos, 8*gs, 0, ColorCat)
// 			}
// 		}

// 		if input.use {
// 			g_mem.show_portrait = nil
// 		}
// 	}
// }

// RootStateMainMenu :: struct {
// 	menu_state: MenuState,
// }

// main_menu_update :: proc(s: ^RootStateMainMenu) {
// 	gs := gui_scale()

// 	if l, ok := get_texture_by_name(.LogoEnd); ok {
// 		src := draw_texture_source_rect(l, false)
// 		src_ar := f32(src.height)/f32(src.width)
// 		s := Vec2{f32(src.width) * gs, f32(src.height) * gs}
// 		dest := Rect { screen_width()/2-s.x/2, s.y*0.25, s.x, s.y }
// 		rl.DrawTexturePro(l, src, dest, {}, 0, rl.WHITE)
// 	}

// 	ms := &s.menu_state
// 	menu_depth := 0
// 	menu_pos := Vec2 {65*gs - ar_width_offset(), 60*gs}

// 	if s.menu_state.depth > 0 && !s.menu_state.focused && (rl.IsKeyPressed(.ESCAPE) || input.gamepad_pressed[.RIGHT_FACE_RIGHT]) {
// 		s.menu_state.depth -= 1
// 		play_sound_alias(.MenuLeave)
// 	}

// 	m := &ms.submenus[menu_depth]

// 	MainMenuChoice :: enum {
// 		Continue,
// 		NewGame,
// 		Options,
// 		Exit,
// 	}

// 	{
// 		s :: 14
// 		ts := rl.MeasureTextEx(g_mem.font, "Zylinski Games", s*gs, 0)
// 		rl.DrawTextEx(g_mem.font, "Zylinski Games", {screen_width() - ts.x - 6 * gs, screen_height() - 15*gs}, s*gs, 0, ColorDark)
// 	}


// 	{
// 		s :: 7

// 		os := ODIN_OS_STRING

// 		// if steam_running_on_deck() {
// 		// 	os = fmt.tprintf("steam os (%v)", os)
// 		// }

// 		version_str := fmt.ctprintf("{} {}", os, Version)
// 		ts := rl.MeasureTextEx(g_mem.font, version_str, s*gs, 0)
// 		rl.DrawTextEx(g_mem.font, version_str, {screen_width() - ts.x - 6 * gs, screen_height() - 22*gs}, s*gs, 0, ColorDark)
// 	}


// 	// tutorial stuff
// 	{
// 		ts :: 9
// 		tp := Vec2 {4*gs, screen_height() - 12*gs}
// 		sel_text := "Select: Enter /"

// 		// if steam_running_on_deck() {
// 		// 	sel_text = "Select:"
// 		// }

// 		rl.DrawTextEx(g_mem.dialogue_font, temp_cstring(sel_text) ,tp, ts*gs, 0, ColorDark)
// 		sel_text_ts := rl.MeasureTextEx(g_mem.dialogue_font, temp_cstring(sel_text), ts*gs, 0)

// 		tp.x += sel_text_ts.x + 1*gs

// 		useth := get_gamepad_glyph(settings.gamepad_bindings[.Use], settings.gamepad_type)
// 		if uset, ok := get_texture(useth); ok {
// 			use_source := draw_texture_source_rect(uset, false)
// 			use_dest := rect_from_pos_size(tp + {1 * gs, -1 *gs}, size_from_rect(use_source) * gs)
// 			rl.DrawTexturePro(uset, use_source, use_dest, {}, 0, rl.WHITE)

// 			tp.x += use_dest.width + 12 *gs
// 		}

// 		if s.menu_state.depth > 0 {
// 			back_text := "Back: ESC /"

// 			// if steam_running_on_deck() {
// 			// 	back_text = "Back:"
// 			// }

// 			rl.DrawTextEx(g_mem.dialogue_font, temp_cstring(back_text) ,tp, ts*gs, 0, ColorDark)
// 			back_text_ts := rl.MeasureTextEx(g_mem.dialogue_font, temp_cstring(back_text), ts*gs, 0)
// 			tp.x += back_text_ts.x + 1*gs

// 			back_gp_tex := get_texture_handle(.GamepadXboxRfRight)

// 			if settings.gamepad_type == .PlayStation {
// 				back_gp_tex = get_texture_handle(.GamepadPsRfRight)
// 			}

// 			if backt, ok := get_texture(back_gp_tex); ok {
// 				use_source := draw_texture_source_rect(backt, false)
// 				use_dest := rect_from_pos_size(tp + {1 * gs, -1 * gs}, size_from_rect(use_source) * gs)
// 				rl.DrawTexturePro(backt, use_source, use_dest, {}, 0, rl.WHITE)
// 			}
// 		}

// 	}


// 	items := make([dynamic]MenuItem, context.temp_allocator)

// 	if g_mem.save.checkpoint != .None {
// 		append(&items, MenuItem {
// 			id = int(MainMenuChoice.Continue),
// 			title = "Continue",
// 		})
// 	}

// 	new_game :: proc() {
// 		load_checkpoint(.Intro, {})
// 		save_game_to_disk()
// 		g_mem.root_state = RootStatePlaying{}
// 		play_sound(.MenuNewGame)
// 	}

// 	append(&items, MenuItem {
// 		id = int(MainMenuChoice.NewGame),
// 		title = "New game",
// 	})

// 	append(&items, MenuItem {
// 		id = int(MainMenuChoice.Options),
// 		title = "Options",
// 	})

// 	append(&items, MenuItem {
// 		id = int(MainMenuChoice.Exit),
// 		title = "Exit",
// 	})

// 	new_game_menu :: proc(s: ^MenuState, start_pos: Vec2, menu_depth: int) {
// 		m := &s.submenus[menu_depth]
// 		pos := start_pos
// 		gs := gui_scale()
// 		rl.DrawTextEx(g_mem.dialogue_font, "Are you sure?", pos, 12*gs, 0, ColorLight)
// 		pos += { 0, 12*gs }
// 		rl.DrawTextEx(g_mem.dialogue_font, "This will delete your old save", pos, 10*gs, 0, ColorLight)
// 		pos += { 0, 14*gs }

// 		MenuChoiceNewGame :: enum {
// 			No, Yes,
// 		}

// 		items := [?]MenuItem {
// 			{
// 				id = int(MenuChoiceNewGame.No),
// 				title = "No",
// 			},
// 			{
// 				id = int(MenuChoiceNewGame.Yes),
// 				title = "Yes",
// 			},
// 		}

// 		selected_in_menu: bool
// 		m.cur, selected_in_menu = do_menu(items[:], m.cur, pos, 10, 10)

// 		if selected_in_menu {
// 			switch MenuChoiceNewGame(m.cur) {
// 				case .No:
// 					s.depth -= 1
// 					play_sound_alias(.MenuLeave)

// 				case .Yes:
// 					new_game()
// 			}
// 		}
// 	}

// 	if menu_depth != ms.depth {
// 		if items[m.cur].id == int(MainMenuChoice.Options) {
// 			options_menu(ms, menu_pos, menu_depth + 1, 12, 12, 10)
// 		} else if items[m.cur].id == int(MainMenuChoice.NewGame) {
// 			new_game_menu(ms, menu_pos, menu_depth + 1)
// 		}
// 	} else {
// 		menu_selected: bool
// 		m.cur, menu_selected = do_menu(items[:], m.cur, menu_pos, 15, 15)

// 		if menu_selected {
// 			switch MainMenuChoice(items[m.cur].id) {
// 				case .NewGame:
// 					if g_mem.save.checkpoint == .None {
// 						new_game()
// 					} else {
// 						enter_submenu(ms)
// 					}
// 				case .Continue:
// 					load_checkpoint(g_mem.save.checkpoint, g_mem.save.portraits)
// 					g_mem.root_state = RootStatePlaying{}
// 					play_sound(.MenuNewGame)

// 				case .Options:
// 					enter_submenu(ms)

// 				case .Exit:
// 					g_mem.run = false
// 			}
// 		}
// 	}
// }

// get_current_ability_name :: proc() -> string {
// 	all_actions := get_all_player_actions()

// 	for a, idx in all_actions {
// 		if g_mem.selected_action == idx {
// 			switch a.type {
// 				case .UseItem:
// 					return item_name[a.item]
// 				case .Talk:
// 					return "Talk"
// 				case .Pickup:
// 					return "Pickup"
// 				case .Inspect:
// 					return "Inspect"
// 			}
// 		}
// 	}

// 	return ""
// }

// SubMenu :: struct {
// 	cur: int,
// 	state: [1024]byte,
// }

// MenuState :: struct {
// 	submenus: [8]SubMenu,
// 	depth: int,
// 	focused: bool,
// }

// enter_submenu :: proc(ms: ^MenuState) {
// 	ms.depth += 1
// 	ms.submenus[ms.depth] = {}
// 	play_sound_alias(.MenuEnter)
// }

// RootStateIngameMenu :: struct {
// 	menu_state: MenuState,
// }

// full_screen_rect :: proc() -> Rect {
// 	sw := screen_width()
// 	sh := screen_height()

// 	return {
// 		0, 0,
// 		sw, sh,
// 	}
// }

// MenuItem :: struct {
// 	id: int,
// 	title: string,
// }

// do_menu :: proc(items: []MenuItem, cur: int, start_pos: Vec2, text_size: f32, line_height: f32) -> (int, bool) {
// 	cur := cur
// 	gs := gui_scale()

// 	for e, idx in items {
// 		pos := start_pos + { 8*gs, f32(idx)*line_height*gs }
// 		t := e.title

// 		rl.DrawTextEx(g_mem.dialogue_font, temp_cstring(t), pos, text_size*gs, 0, ColorLight)

// 		if cur == idx {
// 			render_rectangle(rect_from_pos_size(pos + {-7*gs, ((text_size/2)*gs) - (line_height/6)*gs}, {(line_height/3)*gs, (line_height/3)*gs}), ColorLight)
// 		}
// 	}

// 	if input.ui_up {
// 		cur = int(cur) - 1
// 		clear_input()

// 		if cur < 0 {
// 			cur = len(items) - 1
// 		}

// 		play_sound_alias(.MenuUp)
// 	}

// 	if input.ui_down {
// 		cur = int(cur) + 1
// 		clear_input()

// 		if cur >= len(items) {
// 			cur = 0
// 		}

// 		play_sound_alias(.MenuDown)
// 	}

// 	if input.ui_select {
// 		clear_input()
// 		return cur, true
// 	}

// 	return cur, false
// }


// options_menu :: proc(s: ^MenuState, pos: Vec2, menu_depth: int, text_size: f32, line_height: f32, bindings_text_size: f32) {
// 	keyboard_bindings_menu :: proc(ms: ^MenuState, pos: Vec2, menu_depth: int, text_size: f32, line_height: f32) {
// 		m := &ms.submenus[menu_depth]
// 		gs := gui_scale()

// 		b := &settings.keyboard_bindings

// 		widest_binding := rl.MeasureTextEx(g_mem.dialogue_font, temp_cstring("Reset defaults"), text_size*gs, 0).x

// 		for e in Binding {
// 			s := rl.MeasureTextEx(g_mem.dialogue_font, temp_cstring(to_sentence(fmt.tprintf("%v", e))), text_size*gs, 0).x
// 			if s > widest_binding {
// 				widest_binding = s
// 			}
// 		}

// 		for e, idx in Binding {
// 			row_pos := pos + { 8*gs, f32(idx)*line_height*gs }
// 			rl.DrawTextEx(g_mem.dialogue_font, temp_cstring(to_sentence(fmt.tprintf("%v", e))), row_pos, text_size*gs, 0, ColorLight)
// 			binding_text := temp_cstring(to_sentence(fmt.tprintf("%v", b[e])))

// 			if m.cur == int(e) {
// 				render_rectangle(rect_from_pos_size(row_pos + {-7*gs, ((text_size/2)*gs) - (line_height/6)*gs}, {(line_height/3)*gs, (line_height/3)*gs}), ColorLight)

// 				if ms.focused {
// 					binding_text = "Press a key"
// 					if rl.IsKeyPressed(.ESCAPE) {
// 						ms.focused = false
// 					}

// 					pressed_key := rl.GetKeyPressed()

// 					if pressed_key != nil {
// 						b[e] = pressed_key
// 						ms.focused = false
// 					}
// 				}

// 				if rl.IsKeyPressed(.ENTER) {
// 					ms.focused = true
// 				}
// 			}

// 			rl.DrawTextEx(g_mem.dialogue_font, binding_text, row_pos + {widest_binding + 5*gs, 0}, text_size*gs, 0, ColorLight)
// 		}

// 		num_items := len(Binding) + 1

// 		// reset row
// 		{
// 			row_pos := pos + { 8*gs, f32(num_items - 1)*line_height*gs }
// 			rl.DrawTextEx(g_mem.dialogue_font, "Reset defaults", row_pos, text_size*gs, 0, ColorLight)

// 			if m.cur == num_items -1 {
// 				render_rectangle(rect_from_pos_size(row_pos + {-7*gs, ((text_size/2)*gs) - (line_height/6)*gs}, {(line_height/3)*gs, (line_height/3)*gs}), ColorLight)

// 				if input.ui_select {
// 					clear_input()
// 					settings.keyboard_bindings = default_keyboard_bindings
// 				}
// 			}
// 		}

// 		if input.ui_up {
// 			m.cur = int(m.cur) - 1

// 			if m.cur < 0 {
// 				m.cur = num_items - 1
// 			}
// 			play_sound_alias(.MenuUp)
// 		}

// 		if input.ui_down {
// 			m.cur = int(m.cur) + 1

// 			if m.cur >= num_items {
// 				m.cur = 0
// 			}
// 			play_sound_alias(.MenuDown)
// 		}
// 	}

// 	gamepad_bindings_menu :: proc(ms: ^MenuState, pos: Vec2, menu_depth: int, text_size: f32, line_height: f32) {
// 		m := &ms.submenus[menu_depth]
// 		gs := gui_scale()

// 		b := &settings.gamepad_bindings
// 		binding := false

// 		widest_binding := rl.MeasureTextEx(g_mem.dialogue_font, temp_cstring("Reset defaults"), text_size*gs, 0).x

// 		for e in Binding {
// 			s := rl.MeasureTextEx(g_mem.dialogue_font, temp_cstring(to_sentence(fmt.tprintf("%v", e))), text_size*gs, 0).x
// 			if s > widest_binding {
// 				widest_binding = s
// 			}
// 		}

// 		for e, idx in Binding {
// 			row_pos := pos + { 8*gs, f32(idx)*line_height*gs }
// 			rl.DrawTextEx(g_mem.dialogue_font, temp_cstring(to_sentence(fmt.tprintf("%v", e))), row_pos, text_size*gs, 0, ColorLight)
// 			binding_text := temp_cstring(to_sentence(fmt.tprintf("%v", b[e])))
// 			binding_cur := false

// 			if m.cur == int(e) {
// 				render_rectangle(rect_from_pos_size(row_pos + {-7*gs, ((text_size/2)*gs) - (line_height/6)*gs}, {(line_height/3)*gs, (line_height/3)*gs}), ColorLight)

// 				pressed_key := rl.GetGamepadButtonPressed()

// 				if ms.focused {
// 					binding = true
// 					binding_cur = true
// 					binding_text = "Press a button"
// 					if rl.IsKeyPressed(.ESCAPE) {
// 						ms.focused = false
// 					}

// 					if pressed_key != nil && input.gamepad_pressed[pressed_key] {
// 						b[e] = pressed_key
// 						ms.focused = false
// 					}
// 				} else if input.ui_select {
// 					clear_input()
// 					ms.focused = true
// 				}
// 			}

// 			glyph_tex := get_gamepad_glyph(b[e], g_mem.settings.gamepad_type)
// 			if tex, ok := get_texture(glyph_tex); ok && !binding_cur {
// 				src := draw_texture_source_rect(tex, false)
// 				dest := Rect {
// 					x = row_pos.x + widest_binding + 5 * gs,
// 					y = row_pos.y + line_height/2 - src.height/2,
// 					width = src.width * gs,
// 					height = src.height * gs,
// 				}
// 				rl.DrawTexturePro(tex, src, dest, {}, 0, rl.WHITE)
// 			} else {
// 				rl.DrawTextEx(g_mem.dialogue_font, binding_text, row_pos + {widest_binding + 5 * gs, 0}, text_size*gs, 0, ColorLight)
// 			}
// 		}

// 		num_items := len(Binding) + 1

// 		// reset row
// 		{
// 			row_pos := pos + { 8*gs, f32(num_items - 1)*line_height*gs }
// 			rl.DrawTextEx(g_mem.dialogue_font, "Reset defaults", row_pos, text_size*gs, 0, ColorLight)

// 			if m.cur == num_items - 1 {
// 				render_rectangle(rect_from_pos_size(row_pos + {-7*gs, ((text_size/2)*gs) - (line_height/6)*gs}, {(line_height/3)*gs, (line_height/3)*gs}), ColorLight)

// 				if input.ui_select {
// 					clear_input()
// 					settings.gamepad_bindings = default_gamepad_bindings
// 				}
// 			}
// 		}

// 		if !binding {
// 			if input.ui_up {
// 				m.cur = int(m.cur) - 1

// 				if m.cur < 0 {
// 					m.cur = num_items - 1
// 				}
// 				play_sound_alias(.MenuUp)
// 			}

// 			if input.ui_down {
// 				m.cur = int(m.cur) + 1

// 				if m.cur >= num_items {
// 					m.cur = 0
// 				}
// 				play_sound_alias(.MenuDown)
// 			}
// 		}
// 	}

// 	m := &s.submenus[menu_depth]
// 	line_height := line_height

// 	if line_height == 0 {
// 		line_height = text_size
// 	}

// 	if menu_depth != s.depth {
// 		if m.cur == int(MenuChoiceOptions.KeyboardBindings) {
// 			keyboard_bindings_menu(s, pos, menu_depth + 1, bindings_text_size, bindings_text_size)
// 			return
// 		} else if m.cur == int(MenuChoiceOptions.GamepadBindings) {
// 			gamepad_bindings_menu(s, pos, menu_depth + 1, bindings_text_size, bindings_text_size)
// 			return
// 		}
// 	}

// 	MenuChoiceOptions :: enum {
// 		KeyboardBindings,
// 		GamepadBindings,
// 		GamepadIcons,
// 		MusicVolume,
// 		EffectsVolume,
// 		Fullscreen,
// 	}

// 	items := [?]MenuItem {
// 		{
// 			id = int(MenuChoiceOptions.KeyboardBindings),
// 			title = "Keyboard bindings",
// 		},
// 		{
// 			id = int(MenuChoiceOptions.GamepadBindings),
// 			title = "Gamepad bindings",
// 		},
// 		{
// 			id = int(MenuChoiceOptions.GamepadIcons),
// 			title = settings.gamepad_type == .PlayStation ? "Gamepad Icons: PS" : "Gamepad Icons: Xbox",
// 		},
// 		{
// 			id = int(MenuChoiceOptions.MusicVolume),
// 			title = fmt.tprint("Music Volume: ", settings.music_volume),
// 		},
// 		{
// 			id = int(MenuChoiceOptions.EffectsVolume),
// 			title = fmt.tprint("Effects Volume: ", settings.effects_volume),
// 		},
// 		{
// 			id = int(MenuChoiceOptions.Fullscreen),
// 			title = (rl.IsWindowFullscreen() ? "Fullscreen: On" : "Fullscreen: Off"),
// 		},
// 	}

// 	selected_in_menu: bool
// 	m.cur, selected_in_menu = do_menu(items[:], m.cur, pos, text_size, line_height)

// 	if selected_in_menu {
// 		switch MenuChoiceOptions(m.cur) {
// 			case .KeyboardBindings:
// 				enter_submenu(s)

// 			case .GamepadBindings:
// 				enter_submenu(s)

// 			case .GamepadIcons:
// 				settings.gamepad_type = GamepadType(int(settings.gamepad_type) + 1)

// 				if settings.gamepad_type > max(GamepadType) {
// 					settings.gamepad_type = {}
// 				}

// 			case .MusicVolume:
// 				settings.music_volume += 1

// 				if settings.music_volume > 10 {
// 					settings.music_volume = 0
// 				}

// 			case .EffectsVolume:
// 				settings.effects_volume += 1

// 				if settings.effects_volume > 10 {
// 					settings.effects_volume = 0
// 				}

// 			case .Fullscreen:
// 				toggle_fullscreen()
// 		}
// 	}
// }

// /*
// */

// ingame_menu_update :: proc(s: ^RootStateIngameMenu) {
// 	gather_input()

// 	if s.menu_state.depth >= 0 && !s.menu_state.focused && (input.toggle_menu || input.gamepad_pressed[.RIGHT_FACE_RIGHT]) {
// 		if s.menu_state.depth == 0 {
// 			g_mem.root_state = RootStatePlaying{}
// 			return
// 		} else {
// 			s.menu_state.depth -= 1
// 			play_sound_alias(.MenuLeave)
// 		}
// 	}

// 	gs := gui_scale()
// 	sr := full_screen_rect()

// 	menu_bg := cut_rect_right(&sr, 115 * gs, 0)

// 	render_rectangle(menu_bg, ColorCat)

// 	menu_rect := inset_rect(menu_bg, 5 * gs, 3 * gs)

// 	rl.DrawTextEx(g_mem.dialogue_font, "Paused", { menu_rect.x, menu_rect.y }, 20*gs, 0, ColorLight)

// 	ms := &s.menu_state

// 	assert(ms.depth < len(ms.submenus), "Too deep menu")
// 	menu_depth := 0
// 	menu_pos := Vec2 {menu_rect.x, menu_rect.y + 30*gs}

// 	m := &ms.submenus[menu_depth]

// 	// tutorial stuff
// 	{
// 		ts :: 9
// 		tp := rect_bottom_left(menu_bg) + {11*gs, -12*gs}

// 		if s.menu_state.depth > 0 {
// 			back_text := "Back: ESC /"

// 			// if steam_running_on_deck() {
// 			// 	back_text = "Back:"
// 			// }

// 			rl.DrawTextEx(g_mem.dialogue_font, temp_cstring(back_text) ,tp, ts*gs, 0, ColorLight)
// 			back_text_ts := rl.MeasureTextEx(g_mem.dialogue_font, temp_cstring(back_text), ts*gs, 0)
// 			tp.x += back_text_ts.x + 1*gs

// 			back_gp_tex := get_texture_handle(.GamepadXboxRfRight)

// 			if settings.gamepad_type == .PlayStation {
// 				back_gp_tex = get_texture_handle(.GamepadPsRfRight)
// 			}

// 			if backt, ok := get_texture(back_gp_tex); ok {
// 				use_source := draw_texture_source_rect(backt, false)
// 				use_dest := rect_from_pos_size(tp + {0, -1} * gs, size_from_rect(use_source) * gs)

// 				rl.DrawTexturePro(backt, use_source, use_dest, {}, 0, rl.WHITE)
// 			}
// 		}

// 	}

// 	if menu_depth != ms.depth {
// 		if m.cur == int(IngameMenuChoice.Options) {
// 			options_menu(ms, menu_pos, menu_depth + 1, 12, 12, 10)
// 			return
// 		}
// 	}

// 	IngameMenuChoice :: enum {
// 		Continue,
// 		Options,
// 		QuitToMainMenu,
// 		Quit,
// 	}

// 	items := [?]MenuItem {
// 		{
// 			id = int(IngameMenuChoice.Continue),
// 			title = "Continue",
// 		},
// 		{
// 			id = int(IngameMenuChoice.Options),
// 			title = "Options",
// 		},
// 		{
// 			id = int(IngameMenuChoice.QuitToMainMenu),
// 			title = "Quit to main menu",
// 		},
// 		{
// 			id = int(IngameMenuChoice.Quit),
// 			title = "Quit to desktop",
// 		},
// 	}

// 	selected_in_menu: bool
// 	m.cur, selected_in_menu = do_menu(items[:], m.cur, menu_pos, 12, 12)

// 	if g_mem.last_saved_at != {} {
// 		time_since_save := int(time.duration_minutes(time.since(g_mem.last_saved_at)))

// 		fmt_string := "Saved %v minutes ago"

// 		if time_since_save == 1 {
// 			fmt_string = "Saved %v minute ago"
// 		}

// 		rl.DrawTextEx(g_mem.dialogue_font, fmt.ctprintf(fmt_string, time_since_save), menu_pos + {9*gs, 55 * gs}, 9*gs, 0, ColorLight)
// 	}

// 	if selected_in_menu {
// 		switch IngameMenuChoice(m.cur) {
// 			case .Continue:
// 				g_mem.root_state = RootStatePlaying{}

// 			case .Options:
// 				enter_submenu(ms)

// 			case .QuitToMainMenu:
// 				enter_main_menu()

// 			case .Quit:
// 				g_mem.run = false
// 		}
// 	}
// }

// cat_end_final_pos :: Vec2 {1148, 168}
// squirrel_rocket_going_right_p1 :: Vec2 { 987,16}
// squirrel_rocket_going_right_p2 :: Vec2 { 1519,239}

// squirrel_rocket_going_left_p1 :: Vec2 { 1351,16}
// squirrel_rocket_going_left_p2 :: Vec2 { 914,321}

// end_update :: proc(gs: ^GameStateEnd) {
// 	p, cat_ok := get_entity(gs.cat, PlayerCat)

// 	if !cat_ok {
// 		return
// 	}

// 	gs.timer += dt

// 	next_random_cat :: proc(gs: ^GameStateEnd) -> EntityHandle {
// 		if gs.random_cats_idx < 0 {
// 			for i in 0..<gs.num_cats {
// 				gs.random_cats[i] = i
// 			}
// 			gs.random_cats_idx = gs.num_cats - 1
// 			rand.shuffle(gs.random_cats[0:gs.num_cats])
// 		}

// 		cat_idx := gs.random_cats[gs.random_cats_idx]
// 		cat := gs.cats[cat_idx]
// 		gs.random_cats_idx -= 1
// 		return cat
// 	}

// 	switch gs.status {
// 		case .MovingCat:
// 			tt := math.saturate(gs.timer)
// 			t := mix(smooth_start2, smooth_stop2, tt, tt)

// 			p.pos = math.lerp(gs.cat_start_pos, cat_end_final_pos, t)

// 			anim_speed_mult := remap(abs(cat_end_final_pos.x - gs.cat_start_pos.x), 10, 40, 0.5, 1)

// 			if update_animation(&p.anim, speed_mult = anim_speed_mult) {
// 				play_sound_range(SoundName.Step0, SoundName.Step4)
// 			}

// 			if gs.timer >= 1 {
// 				gs.sqr_rocket_spline_evaluator = animate_along_spline(gs.sqr_rocket, find_entity_with_tag(.EndingSplineFetchPancakes))

// 				if sqr_rocket := get_entity_raw(gs.sqr_rocket); sqr_rocket != nil {
// 					sqr_rocket.renderables[1] = rocket_fire_renderable()
// 				}
// 				p.facing = .East
// 				gs.status = .RocketFlyingToFetchPancakes

// 				send_delayed_event(EventSaySingleLine {entity = gs.cat, line = strings.clone("What's the word of the day?")}, 1)

// 				gs.random_cat_timer = 4

// 				if cat, ok := get_entity(gs.cat, PlayerCat); ok {
// 					cat.anim = {anim = cat.anim_idle}
// 				}


// 				// The Cat
// 				gs.cats[0] = gs.cat
// 				gs.num_cats += 1

// 				if c := find_entity_with_tag(.EndKlucke); c != EntityHandleNone {
// 					gs.cats[gs.num_cats] = c
// 					gs.num_cats += 1
// 				}

// 				if c := find_entity_with_tag(.EndLakrits); c != EntityHandleNone {
// 					gs.cats[gs.num_cats] = c
// 					gs.num_cats += 1
// 				}

// 				if c := find_entity_with_tag(.EndLillemor); c != EntityHandleNone {
// 					gs.cats[gs.num_cats] = c
// 					gs.num_cats += 1
// 				}

// 				if c := find_entity_with_tag(.EndPontus); c != EntityHandleNone {
// 					gs.cats[gs.num_cats] = c
// 					gs.num_cats += 1
// 				}

// 				gs.random_cats[0] = 0
// 			}


// 		case .RocketFlyingToFetchPancakes:
// 			gs.random_cat_timer -= dt
// 			// the evalutator destroys itself when done
// 			if !entity_raw_valid(gs.sqr_rocket_spline_evaluator) {
// 				gs.status = .RocketComingWithPancakes
// 				gs.sqr_rocket_spline_evaluator = animate_along_spline(gs.sqr_rocket, find_entity_with_tag(.EndingSplineWithPancakes))
// 				gs.pancakes = find_entity_with_tag(.PancakeStack)
// 			}

// 			if gs.random_cat_timer <= 0 {
// 				say_single_line(next_random_cat(gs), "Pancake!")
// 				gs.random_cat_timer = 1.5
// 			}

// 		case .RocketComingWithPancakes:
// 			gs.random_cat_timer -= dt

// 			ps := get_entity_raw(gs.pancakes)

// 			if ps != nil {
// 				ps.pos = entity_pos(gs.sqr_rocket) + {0, 36}
// 			}

// 			if gs.random_cat_timer <= 0 {
// 				say_single_line(next_random_cat(gs), "PANCAKE!")
// 				gs.random_cat_timer = 1
// 			}

// 			if !entity_raw_valid(gs.sqr_rocket_spline_evaluator) {
// 				gs.status = .PancakeServed

// 				if ps != nil {
// 					ps.renderables[0].is_animating = true
// 					gs.pancake_lerp_start = ps.pos
// 				}

// 				gs.timer = 0
// 			}

// 		case .PancakeServed:
// 			if ps := get_entity_raw(gs.pancakes); ps != nil {
// 				t := gs.timer
// 				t5 := math.saturate(t*t*t*t*t)
// 				ps.pos = math.lerp(gs.pancake_lerp_start, gs.pancake_lerp_start + {0, 38}, t5)
// 			}

// 			if gs.timer >= 1 {
// 				play_sound_alias(.PancakeLanding)

// 				rands := [?]f32 {
// 					0.2,
// 					0.3,
// 					0.4,
// 					0.5,
// 					0.6,
// 				}

// 				rand.shuffle(rands[:])

// 				for i in 0..<gs.num_cats {
// 					send_delayed_event(EventSaySingleLine { entity = gs.cats[i], line = strings.clone("PANCAKE!"), no_sound = i != 0}, rands[i])
// 				}
// 				gs.status = .Credits

// 				gs.timer = 0

// 				logo := Entity {
// 					renderables = {
// 						0 = { texture = get_texture_handle(.LogoEnd) },
// 					},
// 					num_renderables = 1,
// 					pos = {4000, 86},
// 				}

// 				gs.logo = add_entity(world, logo)
// 				gs.logo_start_pos = logo.pos

// 			}
// 		case .Credits:

// 			if !gs.squirrel_flew_away {
// 				say_single_line(gs.sqr_rocket, "Enjoy!", no_sound = true)
// 				gs.squirrel_flew_away = true
// 				gs.sqr_rocket_spline_evaluator = animate_along_spline(gs.sqr_rocket, find_entity_with_tag(.EndingSplineFlyAway))

// 				// check -1 later and set rot
// 				gs.squirrel_timer = -1
// 			}

// 			if gs.timer > 5 {
// 				if l := get_entity_raw(gs.logo); l != nil {
// 					logo_time := remap(gs.timer, 6, 7, 0, 1)
// 					l.pos = math.lerp(gs.logo_start_pos, Vec2{1199, 90}, mix(smooth_start2, smooth_stop2, logo_time, logo_time))
// 				}
// 			}

// 			credits_done: bool

// 			if gs.squirrel_growing {
// 				credits_done = true
// 			}

// 			if gs.timer > 8 && !gs.squirrel_growing {
// 				gs.credits_timer += dt

// 				if gs.credits_timer > (gs.credits_idx <= 3 ? 4 : 3) {
// 					gs.random_cats_idx -= 1
// 					gs.credits_idx += 1
// 					gs.credits_timer = 0
// 				}

// 				if gs.random_cats_idx < 0 {
// 					for i in 0..<gs.num_cats {
// 						gs.random_cats[i] = i
// 					}
// 					gs.random_cats_idx = gs.num_cats - 1
// 					rand.shuffle(gs.random_cats[0:gs.num_cats])
// 				}

// 				cat_idx := gs.random_cats[gs.random_cats_idx]
// 				cat := gs.cats[cat_idx]

// 				credits := []string {
// 					"Created by Zylinski Games",
// 					"Code, art, music and sound by Karl Zylinski",
// 					"Marketing by Karl Zylinski and Geraldine Lee",
// 					"Playtesters:",
// 					"Johanz, Gerry, zannzen,",
// 					"Jeff23, PeterAlabaster,",
// 					"Perkele, lucy, Fix, z64,",
// 					"Jakub, piguman3, Skytrias",
// 					"laytan & flysand",
// 					"Color palette: retrocal-8 by polyphrog",
// 					"Font: Pixelify Sans by Stefie Justprince",
// 					"Special thanks to:",
// 					"Johanz for early feedback",
// 					"Gerry for extreme cat excitement",
// 					"Jakub for Steamworks bindings and ideas",
// 					"gingerBill for Odinlang and Ray for raylib",
// 				}

// 				when CAT_DEV {
// 					if rl.IsKeyPressed(.C) {
// 						gs.credits_idx = len(credits)
// 					}
// 				}

// 				credits_done = gs.credits_idx >= len(credits)

// 				if !credits_done {
// 					draw_dialogue_bubble(credits[gs.credits_idx], cat_idx > 0 ? DialogueActor.Entity : DialogueActor.Player, cat, gs.credits_timer, no_sound = true)
// 				} else if gs.num_cats == 5 {
// 					gs.thankscakes_timer += dt
// 					draw_dialogue_bubble("Thanks for pancakes...", .Player, gs.cat, gs.thankscakes_timer)

// 					if gs.thankscakes_timer > 4 && !gs.thankscakes_spawned {
// 						play_sound(.DiagIntroCloud0)
// 						send_delayed_event(EventPlaySound { sound = .DiagIntroCloud1}, 0.1)
// 						send_delayed_event(EventPlaySound { sound = .DiagIntroCloud2}, 0.2)

// 						thankscakes := Entity {
// 							renderables = {
// 								0 = { texture = get_texture_handle(.Thankscakes) },
// 							},
// 							num_renderables = 1,
// 							pos = Vec2{1199, 127},
// 						}

// 						add_entity(world, thankscakes)
// 						gs.thankscakes_spawned = true

// 						// steam_add_achievement(.Thankscakes)
// 					}
// 				} else {
// 					gs.thankscakes_timer += dt
// 					draw_dialogue_bubble("Thanks for playing!", .Player, gs.cat, gs.thankscakes_timer)
// 				}
// 			}

// 			if gs.timer > 15 {
// 				if sr := get_entity_raw(gs.sqr_rocket); sr != nil {
// 					if gs.squirrel_timer < 0 {
// 						sr.rot = 119
// 						gs.squirrel_timer = 0
// 					}

// 					gs.squirrel_timer += dt

// 					if gs.num_cats == 5 && gs.squirrel_passes_since_credits_done >= 2 {
// 						cam := get_camera(g_mem.camera_state)
// 						world_mid := rect_middle(g_mem.camera_rect)

// 						t := gs.squirrel_timer
// 						lt := remap(t, 0, 5, 0, 1)
// 						ltt := mix(smooth_start2, smooth_stop2, lt, lt)

// 						if gs.squirrel_going_left {
// 							sr.pos = math.lerp(squirrel_rocket_going_left_p2, world_mid, ltt)
// 						} else {
// 							sr.pos = math.lerp(squirrel_rocket_going_right_p1, world_mid, ltt)
// 						}

// 						if t > 3.5 {
// 							tr := remap(t, 3.5, 7, 0, 1)
// 							ttr := mix(smooth_start2, smooth_stop2, tr, tr)
// 							sr.rot = math.lerp(f32(gs.squirrel_going_left ? 38 : 119), 0, ttr)
// 						}

// 						if t > 7 {
// 							gs.squirrel_growing = true
// 							ts := remap(t, 7, 12, 0, 1)
// 							tts := mix(smooth_start2, smooth_stop2, ts, ts)
// 							sr.scale = math.lerp(f32(1), 6, tts)

// 							if t > 12 && t < 20 {
// 								sr.interactable_icon_offset = {5, -45}
// 								draw_dialogue_bubble("Thank you for finding me these cat friends. Have a lovely day, goodbye!", .Entity, gs.sqr_rocket, t - 12, override_kind = .Squirrel, override_kind_enable = true)
// 							}
// 						}

// 						if t > 20 {
// 							g_mem.run = false
// 						}
// 					} else {
// 						t := gs.squirrel_timer / 10.0

// 						if gs.squirrel_going_left {
// 							sr.pos = math.lerp(squirrel_rocket_going_left_p2, squirrel_rocket_going_left_p1, t)
// 						} else {
// 							sr.pos = math.lerp(squirrel_rocket_going_right_p1, squirrel_rocket_going_right_p2, t)
// 						}

// 						if t > 1 {
// 							gs.squirrel_going_left = !gs.squirrel_going_left
// 							gs.squirrel_timer = 0
// 							sr.rot = gs.squirrel_going_left ? 38 : 119

// 							if credits_done {
// 								gs.squirrel_passes_since_credits_done += 1
// 							}
// 						}
// 					}
// 				}
// 			}
// 		}
// }

// intro_update :: proc(gs: ^GameStateIntro) {
// 	gs.time += dt

// 	c := get_entity_raw(gs.cloud)

// 	if c == nil {
// 		return
// 	}

// 	if gs.time > 7 {
// 		if !c.renderables[0].is_animating && c.renderables[0].num_loops == 0 {
// 			c.renderables[0].is_animating = true
// 		}
// 	}

// 	if gs.time > 12 && gs.time < 15 {
// 		draw_dialogue_bubble("Oh my... I'm a cloud today!", .Entity, gs.cloud,
// 			gs.time - 12, override_color = true,
// 			override_color_bg = ColorLight,
// 			override_color_border = ColorOrange,
// 			override_color_text = ColorDark)
// 	}

// 	if gs.time > 16 && gs.time < 20 {
// 		draw_dialogue_bubble("Feels quite nice and fluffy actually...", .Entity, gs.cloud,
// 			gs.time - 16, override_color = true,
// 			override_color_bg = ColorLight,
// 			override_color_border = ColorOrange,
// 			override_color_text = ColorDark)
// 	}

// 	if gs.time > 21 && !gs.squirrel_moving {
// 		spl := Entity {
// 			variant = SplineEvaluator {
// 				target = gs.squirrel,
// 				spline = find_entity_with_tag(.IntroSquirrelSpline),
// 			},
// 		}

// 		add_entity(world, spl)
// 		gs.squirrel_moving = true
// 	}

// 	if gs.time > 23 && gs.time < 27 {
// 		draw_dialogue_bubble("Wake up Kitty! It's time to make pancakes!", .Entity, gs.squirrel,
// 			gs.time - 23, flip_bubble = true)
// 	}

// 	if gs.time >= 27 && gs.time < 31 {
// 		draw_dialogue_bubble("Oh hi Squirrel! WAIT, DID YOU SAY PA-", .Entity, gs.cloud,
// 			gs.time - 27, override_color = true,
// 			override_color_bg = ColorLight,
// 			override_color_border = ColorOrange,
// 			override_color_text = ColorDark)
// 	}

// 	if gs.time > 29 {
// 		if !gs.music_started {
// 			play_music(&g_mem.music, .Catnap)
// 			gs.music_started = true
// 		}
// 	}

// 	if gs.time > 32.5 {
// 		g_mem.next_level_name = .Planet
// 		g_mem.load_next_level = true
// 	}
// }

// intro_transition_update :: proc(gs: ^GameStateIntroTransition) {
// 	gs.time += dt
// 	t := remap(gs.time, 0.1, 10, 0, 1)
// 	tp := remap(gs.time, 0.1, 9, 0, 1)
// 	zt := 1 - (1-t) * (1-t) * (1-t) * (1-t)
// 	g_mem.camera_state.zoom = math.lerp(f32(100)*default_game_camera_zoom(), default_game_camera_zoom(), zt)
// 	g_mem.camera_state.pos = math.lerp(entity_pos(g_mem.cat) + {-4, 6.5}, gs.wanted_camera_pos, tp*tp)
// 	g_mem.camera_state.wanted_y = g_mem.camera_state.pos.y
// 	cat, cat_ok := get_entity(g_mem.cat, PlayerCat)

// 	if !cat_ok {
// 		set_game_state(GameStateDefault{})
// 		return
// 	}

// 	skip := false

// 	when CAT_DEV {
// 		skip = rl.IsKeyPressed(.ENTER)
// 	}

// 	if gs.time > 8 || skip {
// 		if update_animation(&cat.anim) || skip {
// 			g_mem.next_controlled_entity = g_mem.cat
// 			g_mem.controlled_entity = g_mem.cat
// 			g_mem.hide_hud = false
// 			set_state(cat, PlayerStateNormal{})
// 			set_game_state(GameStateDefault{})
// 		}
// 	}
// }

// EndStateStatus :: enum {
// 	MovingCat,
// 	RocketFlyingToFetchPancakes,
// 	RocketComingWithPancakes,
// 	PancakeServed,
// 	Credits,
// }

// enter_end_state :: proc() {
// 	cat := g_mem.cat

// 	p, cat_ok := get_entity(cat, PlayerCat)

// 	if !cat_ok {
// 		return
// 	}

// 	sqr_rocket := find_entity_with_tag(.SquirrelRocket)

// 	set_state(p, PlayerStateExternallyControlled{})

// 	set_game_state(GameStateEnd {
// 		cat_start_pos = p.pos,
// 		cat = cat,
// 		sqr_rocket = sqr_rocket,
// 	})

// 	play_music(&g_mem.music, .Credits)

// 	pos_to_target := cat_end_final_pos - p.pos
// 	p.anim = { anim = p.anim_walk }
// 	p.facing = pos_to_target.x > 0 ? .East : .West
// 	g_mem.hide_hud = true
// }

// play_mode_update :: proc() {
// 	profile_scope()

// 	if settings.try_autodetect_gamepad {
// 		for gp in 0..<MaxGamepads {
// 			if !rl.IsGamepadAvailable(i32(gp)) {
// 				continue
// 			}

// 			gp_name := string(rl.GetGamepadName(i32(gp)))

// 			if strings.contains(gp_name, "PlayStation") || strings.contains(gp_name, "DualShock") || strings.contains(gp_name, "DualSense") || gp_name == "Wireless Controller" {
// 				settings.gamepad_type = .PlayStation
// 			}

// 			settings.try_autodetect_gamepad = false
// 		}
// 	}

// 	when CAT_DEV {
// 		if rl.IsKeyPressed(.P) {
// 			fmt.println(mouse_world_position(get_camera(g_mem.camera_state)))
// 		}

// 		if rl.IsKeyPressed(.H) {
// 			g_mem.hide_hud = !g_mem.hide_hud
// 		}

// 		if rl.IsKeyPressed(.C) {
// 			steam_clear_all_stats()
// 		}
// 	}

// 	// game doesn't work properly below 0.1 s frametime anyways, so cap it so we don't get
// 	// strange issues from big dts when moving window etc
// 	dt = min(rl.GetFrameTime(), 0.1)

// 	sound_update()

// 	rl.BeginShaderMode(g_mem.pixel_filter_shader)
// 	rl.BeginBlendMode(.ALPHA_PREMULTIPLY)

// 	switch &rs in g_mem.root_state {
// 		case RootStateMainMenu:
// 			update_default()
// 			draw_default()
// 			main_menu_update(&rs)
// 		case RootStateIngameMenu:
// 			draw_default()
// 			ingame_menu_update(&rs)
// 		case RootStatePlaying:
// 			switch &gs in g_mem.game_state {
// 				case GameStateDefault:
// 					update_default()
// 					draw_default()

// 				case GameStateSpaceGame:
// 					update_default()
// 					space_game_update(&gs)

// 					draw_default()

// 				case GameStateEnteringPancakeBatterLand:
// 					update_default()
// 					entering_pbl_update(&gs)

// 					draw_default()

// 				case GameStateEnd:
// 					update_default()
// 					end_update(&gs)

// 					draw_default()

// 				case GameStateIntro:
// 					update_default()
// 					intro_update(&gs)


// 					draw_default()

// 				case GameStateIntroTransition:
// 					update_default()
// 					intro_transition_update(&gs)

// 					draw_default()
// 			}
// 	}

// 	rl.EndBlendMode()
// 	rl.EndShaderMode()
// }

// rect_from_pos_size :: proc(p: Vec2, s: Vec2) -> rl.Rectangle {
// 	return rl.Rectangle {
// 		p.x, p.y,
// 		s.x, s.y,
// 	}
// }

// screen_rect_from_pos_size :: proc(p: Vec2, s: Vec2, c: rl.Camera2D) -> rl.Rectangle {
// 	sp := rl.GetWorldToScreen2D(p, c)
// 	ss := s

// 	if c.zoom != 0 {
// 		ss *= c.zoom
// 	}

// 	return {
// 		x = sp.x,
// 		y = sp.y,
// 		width = ss.x,
// 		height = ss.y,
// 	}
// }

// screen_rect_from_rect :: proc(r: Rect, c: rl.Camera2D) -> Rect {
// 	return screen_rect_from_pos_size({r.x, r.y}, {r.width, r.height}, c)
// }

// screen_rect :: proc { screen_rect_from_pos_size, screen_rect_from_rect }

// color_a :: proc(c: [3]u8, a: u8) -> rl.Color {
// 	return rl.Color { u8(f32(c.r)*(f32(a)/255)), u8(f32(c.g)*(f32(a)/255)), u8(f32(c.b)*(f32(a)/255)), a}
// }

// text_size :: proc(s: string) -> Vec2 {
// 	sc := strings.clone_to_cstring(s, context.temp_allocator)
// 	return rl.MeasureTextEx(g_mem.font, sc, MetricFontHeight, 0)
// }

// dialogue_text_size :: proc(s: string) -> Vec2 {
// 	sc := strings.clone_to_cstring(s, context.temp_allocator)
// 	return rl.MeasureTextEx(g_mem.dialogue_font, sc, MetricDialogueFontHeight, 0)
// }

// button_width :: proc(s: cstring) -> f32 {
// 	return rl.MeasureTextEx(g_mem.font, s, MetricFontHeight, 0).x + MetricControlTextMargin * 2
// }

// TextAlign :: enum {
// 	Left,
// 	Center,
// 	Right,
// }

// inset_rect :: proc(r: rl.Rectangle, x: f32, y: f32) -> rl.Rectangle {
// 	return {
// 		r.x + x,
// 		r.y + y,
// 		r.width - x * 2,
// 		r.height - y * 2,
// 	}
// }

// pad_rect :: proc(r: rl.Rectangle, x: f32, y: f32) -> rl.Rectangle {
// 	return {
// 		r.x - x,
// 		r.y - y,
// 		r.width + x * 2,
// 		r.height + y * 2,
// 	}
// }

// cut_rect_top :: proc(r: ^rl.Rectangle, y: f32, m: f32) -> rl.Rectangle {
// 	res := r^
// 	res.y += m
// 	res.height = y
// 	r.y += y + m
// 	r.height -= y + m
// 	return res
// }

// cut_rect_bottom :: proc(r: ^rl.Rectangle, h: f32, m: f32) -> rl.Rectangle {
// 	res := r^
// 	res.height = h
// 	res.y = r.y + r.height - h - m
// 	r.height -= h + m
// 	return res
// }

// split_rect_bottom :: proc(r: rl.Rectangle, y: f32, m: f32) -> (top, bottom: rl.Rectangle) {
// 	top = r
// 	top.height -= y + m
// 	bottom = r
// 	bottom.y = top.y + top.height + m
// 	bottom.height = y
// 	return
// }

// split_rect_top :: proc(r: rl.Rectangle, y: f32, m: f32) -> (top, bottom: rl.Rectangle) {
// 	top = r
// 	bottom = r
// 	top.y += m
// 	top.height = y
// 	bottom.y += y + m
// 	bottom.height -= y + m
// 	return
// }

// cut_rect_left :: proc(r: ^rl.Rectangle, x, m: f32) -> rl.Rectangle {
// 	res := r^
// 	res.x += m
// 	res.width = x
// 	r.x += x + m
// 	r.width -= x + m
// 	return res
// }

// cut_rect_right :: proc(r: ^rl.Rectangle, w, m: f32) -> rl.Rectangle {
// 	res := r^
// 	res.width = w
// 	res.x = r.x + r.width - w - m
// 	r.width -= w + m
// 	return res
// }

// split_rect_left :: proc(r: rl.Rectangle, x: f32, m: f32) -> (left, right: rl.Rectangle) {
// 	left = r
// 	right = r
// 	left.width = x
// 	right.x += x + m
// 	right.width -= x +m
// 	return
// }

// rect_top_left :: proc(r: Rect) -> Vec2 {
// 	return {r.x, r.y}
// }

// rect_top_middle :: proc(r: Rect) -> Vec2 {
// 	return {r.x + r.width /2, r.y}
// }

// rect_bottom_left :: proc(r: Rect) -> Vec2 {
// 	return {r.x, r.y + r.height}
// }

// rect_top_right :: proc(r: Rect) -> Vec2 {
// 	return {r.x + r.width, r.y}
// }

// rect_bottom_right :: proc(r: Rect) -> Vec2 {
// 	return {r.x + r.width, r.y + r.height}
// }

// fix_negative_rect :: proc(r: Rect) -> Rect {
// 	r := r

// 	if r.width < 0 {
// 		r.x += r.width
// 		r.width = -r.width
// 	}

// 	if r.height < 0 {
// 		r.y += r.height
// 		r.height = -r.height
// 	}

// 	return r
// }

// cut_property_row :: proc(r: ^Rect, m_extra: f32 = 0) -> Rect {
// 	return cut_rect_top(r, MetricPropertyHeight, MetricPropertyMargin + m_extra)
// }

// property_line :: proc(r: ^Rect) {
// 	line_rect := cut_property_row(r)
// 	rl.DrawLineV({line_rect.x, line_rect.y + line_rect.height / 2}, {line_rect.x + line_rect.width, line_rect.y + line_rect.height / 2}, ColorControlText)
// }


// is_builtin_entity_type :: proc(et: EntityType) -> bool {
// 	_, is_code_defined := et.variant.(EntityTypeBuiltin)
// 	return is_code_defined
// }


// TilesetWidth :: 4
// TileHeight :: 16


// @(deferred_none=rl.EndScissorMode)
// scissor_scope :: proc(r: Rect) {
// 	rl.BeginScissorMode(i32(r.x), i32(r.y), i32(r.width), i32(r.height))
// }

// union_type :: proc(a: any) -> typeid {
// 	return reflect.union_variant_typeid(a)
// }

// mouse_pos :: proc() -> Vec2 {
// 	mouse_window := rl.GetMousePosition()

// 	if g_mem.editing {
// 		return mouse_window
// 	}

// 	return mouse_window - screen_top_left()
// }

// mouse_in_rect :: proc(r: Rect) -> bool {
// 	return rl.CheckCollisionPointRec(mouse_pos(), r)
// }

// mouse_in_world_rect :: proc(r: Rect, camera: rl.Camera2D) -> bool {
// 	return rl.CheckCollisionPointRec(rl.GetScreenToWorld2D(mouse_pos(), camera), r)
// }

// point_in_rect :: proc(p: Vec2, r: Rect) -> bool {
// 	return rl.CheckCollisionPointRec(p, r)
// }

// temp_cstring :: proc(s: string) -> cstring {
// 	return strings.clone_to_cstring(s, context.temp_allocator)
// }

// pos_from_rect :: proc(r: rl.Rectangle) -> Vec2 {
// 	return {r.x, r.y}
// }

// size_from_rect :: proc(r: rl.Rectangle) -> Vec2 {
// 	return {math.abs(r.width), math.abs(r.height)}
// }

// rect_from_size :: proc(s: Vec2) -> rl.Rectangle {
// 	return {0, 0, s.x, s.y}
// }

// texture_size :: proc(t: rl.Texture2D) -> Vec2 {
// 	return { f32(t.width), f32(t.height) }
// }

// enum_values :: proc($T: typeid) -> []T {
// 	return transmute([]T)reflect.enum_field_values(T)
// }

// white_alpha :: proc(a: u8) -> rl.Color {
// 	return {255,255,255,a}
// }

// RenderableTexture :: struct {
// 	texture: rl.Texture2D,
// 	texture_rect: rl.Rectangle,
// 	dest_rect: rl.Rectangle,
// 	rotation: f32,
// 	origin: Vec2,
// 	tint: bool,
// 	tint_color: rl.Color,
// }

// RenderableCircle :: struct {
// 	pos: Vec2,
// 	radius: f32,
// 	color: rl.Color,
// }

// RenderableRect :: struct {
// 	rect: Rect,
// 	color: rl.Color,
// }

// RenderableRectLines :: struct {
// 	rect: Rect,
// 	color: rl.Color,
// }

// RenderableLine :: struct {
// 	start, end: Vec2,
// 	color: rl.Color,
// }

// RenderableLineBezierCubic :: struct {
// 	start, start_control: Vec2,
// 	end_control, end: Vec2,
// 	color: rl.Color,
// }

// RenderableString :: struct {
// 	str: string,
// 	size: f32,
// 	font: rl.Font,
// 	color: rl.Color,
// 	pos: Vec2,
// 	rot: f32,
// }

// GamepadType :: enum {
// 	XBox,
// 	PlayStation,
// }

// Renderable :: struct {
// 	variant: union {
// 		RenderableTexture,
// 		RenderableCircle,
// 		RenderableRect,
// 		RenderableLine,
// 		RenderableRectLines,
// 		RenderableLineBezierCubic,
// 		RenderableString,
// 	},
// 	layer: int,
// }

// Pivot :: enum {
// 	Center,
// 	UpperLeft,
// }

// render_texture :: proc(tex: TextureHandle, pos: Vec2, layer: int, flip: bool = false, scl := Vec2{1,1}, pivot := Pivot.Center, tint : rl.Color = rl.WHITE) {
// 	if tex == TextureHandleNone {
// 		return
// 	}

// 	if tex, ok := get_texture(tex); ok {
// 		dest := draw_texture_dest_rect_scl(tex, pos, scl)
// 		append(&g_mem.to_render, Renderable {
// 			variant = RenderableTexture {
// 				texture = tex,
// 				texture_rect = draw_texture_source_rect(tex, flip),
// 				dest_rect = dest,
// 				origin = pivot == .Center ? linalg.floor(rect_local_middle(dest)) : {},
// 				tint = true,
// 				tint_color = tint,
// 			},
// 			layer = layer,
// 		})
// 	}
// }


// render_texture_pro :: proc(tex: TextureHandle, source: Rect, dest: Rect, layer: int, pivot := Pivot.Center, tint : rl.Color = rl.WHITE) {
// 	if tex == TextureHandleNone {
// 		return
// 	}

// 	if tex, ok := get_texture(tex); ok {
// 		append(&g_mem.to_render, Renderable {
// 			variant = RenderableTexture {
// 				texture = tex,
// 				texture_rect = source,
// 				dest_rect = dest,
// 				origin = pivot == .Center ? linalg.floor(rect_local_middle(dest)) : {},
// 				tint = true,
// 				tint_color = tint,
// 			},
// 			layer = layer,
// 		})
// 	}
// }

// render_text :: proc(s: string, pos: Vec2, layer: int, color: rl.Color = ColorDark, time_on_line: f32 = -1) {
// 	if len(s) == 0 {
// 		return
// 	}

// 	append(&g_mem.text_to_render, RenderText {
// 		text = s,
// 		pos = pos,
// 		color = color,
// 		time_on_line = time_on_line,
// 	})
// }

// random_in_range :: proc(min: f32, max: f32) -> f32 {
// 	r := rl.GetRandomValue(0, 32767)
// 	rf := f32(r)/32767.0
// 	return rf * (max - min) + min
// }

// camera_rect :: proc(camera: rl.Camera2D) -> Rect {
// 	profile_scope()
// 	pos := rl.GetScreenToWorld2D({}, camera)
// 	size := screen_size() / camera.zoom
// 	return rect_from_pos_size(pos, size)
// }

// GamepadGlyphVariant :: enum {
// 	Default,
// 	Cave,
// }

// render_rectangle :: proc(r: Rect, c: rl.Color) {
// 	c := c
// 	c.rgb = {
// 		u8(f32(c.r) * (f32(c.a)/255)),
// 		u8(f32(c.g) * (f32(c.a)/255)),
// 		u8(f32(c.b) * (f32(c.a)/255)),
// 	}
// 	rl.DrawRectangleRec(r, c)
// }

// get_gamepad_glyph :: proc(b: rl.GamepadButton, type: GamepadType, variant: GamepadGlyphVariant = .Default) -> TextureHandle {
// 	rf_up: TextureHandle
// 	rf_right: TextureHandle
// 	rf_down: TextureHandle
// 	rf_left: TextureHandle
// 	lf_up := get_texture_handle(.GamepadDpadUp)
// 	lf_right := get_texture_handle(.GamepadDpadRight)
// 	lf_down := get_texture_handle(.GamepadDpadDown)
// 	lf_left := get_texture_handle(.GamepadDpadLeft)
// 	l1 := get_texture_handle(.GamepadL1)
// 	r1 := get_texture_handle(.GamepadR1)

// 	switch type {
// 		case .PlayStation:
// 			rf_up = get_texture_handle(.GamepadPsRfUp)
// 			rf_right = get_texture_handle(.GamepadPsRfRight)
// 			rf_down = get_texture_handle(.GamepadPsRfDown)
// 			rf_left = get_texture_handle(.GamepadPsRfLeft)

// 		case .XBox:
// 			rf_up = get_texture_handle(.GamepadXboxRfUp)
// 			rf_right = get_texture_handle(.GamepadXboxRfRight)
// 			rf_down = get_texture_handle(.GamepadXboxRfDown)
// 			rf_left = get_texture_handle(.GamepadXboxRfLeft)
// 	}

// 	if variant == .Cave {
// 		lf_up = get_texture_handle(.GamepadDpadUpCave)
// 		lf_right = get_texture_handle(.GamepadDpadRightCave)
// 		lf_down = get_texture_handle(.GamepadDpadDownCave)
// 		lf_left = get_texture_handle(.GamepadDpadLeftCave)
// 		l1 = get_texture_handle(.GamepadL1Cave)
// 		r1 = get_texture_handle(.GamepadR1Cave)

// 		switch type {
// 			case .PlayStation:
// 				rf_up = get_texture_handle(.GamepadPsRfUpCave)
// 				rf_right = get_texture_handle(.GamepadPsRfRightCave)
// 				rf_down = get_texture_handle(.GamepadPsRfDownCave)
// 				rf_left = get_texture_handle(.GamepadPsRfLeftCave)

// 			case .XBox:
// 				rf_up = get_texture_handle(.GamepadXboxRfUpCave)
// 				rf_right = get_texture_handle(.GamepadXboxRfRightCave)
// 				rf_down = get_texture_handle(.GamepadXboxRfDownCave)
// 				rf_left = get_texture_handle(.GamepadXboxRfLeftCave)
// 		}
// 	}

// 	switch b {
// 		case .LEFT_FACE_UP:
// 			return lf_up
// 		case .LEFT_FACE_RIGHT:
// 			return lf_right
// 		case .LEFT_FACE_DOWN:
// 			return lf_down
// 		case .LEFT_FACE_LEFT:
// 			return lf_left
// 		case .RIGHT_FACE_UP:
// 			return rf_up
// 		case .RIGHT_FACE_RIGHT:
// 			return rf_right
// 		case .RIGHT_FACE_DOWN:
// 			return rf_down
// 		case .RIGHT_FACE_LEFT:
// 			return rf_left
// 		case .LEFT_TRIGGER_1:
// 			return l1
// 		case .RIGHT_TRIGGER_1:
// 			return r1
// 		case .RIGHT_TRIGGER_2:
// 		case .LEFT_TRIGGER_2:
// 		case .UNKNOWN:
// 		case .MIDDLE_LEFT:
// 		case .MIDDLE:
// 		case .MIDDLE_RIGHT:
// 		case .LEFT_THUMB:
// 		case .RIGHT_THUMB:
// 			return TextureHandleNone
// 	}


// 	return TextureHandleNone
// }

// render_gamepad_glyph :: proc(b: rl.GamepadButton, type: GamepadType, pos: Vec2, layer: int, pivot := Pivot.Center, variant: GamepadGlyphVariant = .Default, tint: rl.Color = rl.WHITE) -> Vec2 {
// 	h := get_gamepad_glyph(b, type, variant)

// 	if h != TextureHandleNone {
// 		render_texture(h, pos, layer, pivot = pivot, tint = tint)

// 		if tex, ok := get_texture(h); ok {
// 			return texture_size(tex)
// 		}
// 	}

// 	return {}
// }

// DialogueRuneAppearTime :: 0.025

// keyboard_binding_text :: proc(b: Binding) -> string {
// 	key := settings.keyboard_bindings[b]
// 	binding: string
// 	#partial switch key {
// 		case .RIGHT_CONTROL:
// 			binding = "R CTRL"
// 		case .LEFT_CONTROL:
// 			binding = "L CTRL"
// 		case .RIGHT_ALT:
// 			binding = "R ALT"
// 		case .LEFT_ALT:
// 			binding = "L ALT"
// 		case .RIGHT_SHIFT:
// 			binding = "R SHIFT"
// 		case .LEFT_SHIFT:
// 			binding = "L SHIFT"
// 		case:
// 			binding = fmt.tprint(settings.keyboard_bindings[b])
// 	}
// 	return binding
// }

// level_based_drawing :: proc() {
// 	if g_mem.level_name == .PancakeBatterLand  {
// 		bg_pancake := Rect {-530, 120, 4000, 400 }
// 		render_rectangle(bg_pancake, ColorOrange)
// 		bg_pancake_mountain := Rect {-4000, -400, 4208, 1600 }
// 		render_rectangle(bg_pancake_mountain, ColorOrange)
// 	}

// }

// draw_world :: proc(camera: rl.Camera2D, layer_view_mode: LayerViewMode, layer: int, in_editor: bool) {
// 	profile_scope()

// 	profile_start("enter mode 2d and set modes")
// 	rl.BeginMode2D(camera)
// 	profile_end()

// 	level_based_drawing()

// 	rens := &g_mem.to_render
// 	g_mem.camera_rect = camera_rect(camera)
// 	cr := g_mem.camera_rect

// 	// tile culling values
// 	tc_y_min := int(cr.y - TileHeight)/TileHeight
// 	tc_y_max := int(math.ceil((cr.y + cr.height)/TileHeight))
// 	tc_x_min := int(cr.x - TileHeight)/TileHeight
// 	tc_x_max := int(math.ceil((cr.x + cr.width)/TileHeight))

// 	profile_start("reserve renderables")
// 	reserve(rens, 1024)
// 	profile_end()

// 	profile_start("draw tiles")
// 	for t in &g_mem.world.tiles {
// 		if t.x < tc_x_min || t.x > tc_x_max || t.y < tc_y_min || t.y > tc_y_max {
// 			continue
// 		}

// 		i := t.tile_idx
// 		x := i % TilesetWidth
// 		y := i / TilesetWidth

// 		append(rens, Renderable {
// 			variant = RenderableTexture {
// 				texture = g_mem.tileset_padded,
// 				texture_rect = tile_tileset_rect(x, y, 1, 1, t.flip_x, t.flip_y),
// 				dest_rect = tile_world_rect(t.x, t.y),
// 			},
// 			layer = t.layer,
// 		})
// 	}
// 	profile_end()

// 	camera_mid := camera_middle(camera)
// 	gpb := &settings.gamepad_bindings

// 	draw_keyboard_binding :: proc(b: Binding, pos: Vec2, text_size: f32, layer: int, rens: ^[dynamic]Renderable, align: TextAlign = .Center) -> Vec2 {
// 		pos := pos

// 		key := settings.keyboard_bindings[b]

// 		draw_keyboard_binding_texture :: proc(tex: TextureName, pos: Vec2, layer: int, rens: ^[dynamic]Renderable, align: TextAlign) -> Vec2 {
// 			if t, ok := get_texture_by_name(tex); ok {
// 				source := draw_texture_source_rect(t, false)
// 				dest := rect_from_pos_size(pos, size_from_rect(source))

// 				consumed_size := texture_size(t)

// 				origin: Vec2
// 				source_middle := rect_middle(source)

// 				switch align {
// 					case .Left:
// 						origin = linalg.floor(Vec2 { 0, source_middle.y })

// 					case .Center:
// 						origin = linalg.floor(source_middle)
// 						consumed_size = linalg.floor(consumed_size / 2) + {1, 0}

// 					case .Right:
// 						origin = linalg.floor(Vec2 { source.width, source_middle.y })
// 						consumed_size = 0
// 				}

// 				append(rens, Renderable {
// 					variant = RenderableTexture {
// 						texture = t,
// 						texture_rect = source,
// 						dest_rect = dest,
// 						origin = origin,
// 					},
// 					layer = layer,
// 				})
// 				return consumed_size
// 			}

// 			return {}
// 		}

// 		#partial switch key {
// 			case .LEFT: return draw_keyboard_binding_texture(.ArrowLeft, pos, layer, rens, align)
// 			case .RIGHT: return draw_keyboard_binding_texture(.ArrowRight, pos, layer, rens, align)
// 			case .UP: return draw_keyboard_binding_texture(.ArrowUp, pos, layer, rens, align)
// 			case .DOWN: return draw_keyboard_binding_texture(.ArrowDown, pos, layer, rens, align)
// 		}

// 		binding_text := keyboard_binding_text(b)
// 		binding_size := linalg.floor(rl.MeasureTextEx(g_mem.dialogue_font, temp_cstring(binding_text), text_size, 0))
// 		consumed_size := binding_size

// 		switch align {
// 			case .Left:
// 				consumed_size += {4, 0}
// 			case .Center:
// 				pos -= linalg.floor(binding_size * 0.5)
// 				consumed_size = {binding_size.x/2 + 2, binding_size.y}
// 			case .Right:
// 				pos -= {binding_size.x + 2, binding_size.y/2}
// 				consumed_size = {2, 0}
// 		}

// 		bg := pad_rect(rect_from_pos_size(pos, binding_size), 1, -1)
// 		append(rens, Renderable {
// 			variant = RenderableRect {
// 				rect = bg,
// 				color = ColorDark,
// 			},
// 			layer = layer+1,
// 		})

// 		append(rens, Renderable {
// 			variant = RenderableRect {
// 				rect = pad_rect(bg, 0, 1),
// 				color = ColorBrown,
// 			},
// 			layer = layer,
// 		})

// 		append(rens, Renderable {
// 			variant = RenderableRect {
// 				rect = pad_rect(bg, 1, 0),
// 				color = ColorBrown,
// 			},
// 			layer = layer,
// 		})

// 		append(rens, Renderable {
// 			variant = RenderableString {
// 				str = binding_text,
// 				size = text_size,
// 				color = ColorBrown,
// 				font = g_mem.dialogue_font,
// 				pos = pos,
// 			},
// 			layer = layer+2,
// 		})

// 		return consumed_size
// 	}

// 	profile_start("draw entities")
// 	ent_iter := ha_make_iter(g_mem.world.entities)
// 	for e, eh in ha_iter_ptr(&ent_iter) {
// 		if e.hidden || e.disabled {
// 			continue
// 		}

// 		pos := e.pos + parallax_offset(e.parallax, camera_mid, e.parallax_y_lock)

// 		if rp, ok := e.render_pos.?; ok {
// 			pos = rp + parallax_offset(e.parallax, camera_mid, e.parallax_y_lock)
// 		}

// 		r0 := e.renderables[0]
// 		r0_color := rl.WHITE

// 		if r0.apply_color {
// 			r0_color = r0.color
// 		}

// 		#partial switch e.kind {
// 			case .UseAbilityTutorial:
// 				if input.gamepad {
// 					use_glyph_size := render_gamepad_glyph(gpb[.Use], settings.gamepad_type, e.pos, e.layer, pivot = .UpperLeft, variant = .Cave)
// 					ability_name := get_current_ability_name()

// 					append(rens, Renderable {
// 						variant = RenderableString {
// 							str = ability_name,
// 							size = 10,
// 							color = ColorBrown,
// 							font = g_mem.dialogue_font,
// 							pos = e.pos + {use_glyph_size.x + 2, 0},
// 						},
// 						layer = e.layer,
// 					})
// 				} else {
// 					pos.y += draw_keyboard_binding(.Use, pos- {8,8}, 10, e.layer, rens).y + 1
// 					pos.y += draw_keyboard_binding(.NextItem, pos- {8,8}, 10, e.layer, rens).y + 1
// 				}
// 			case .DrawBindingLeft:
// 				pos := e.pos + {-5, 0}
// 				pos.x += draw_keyboard_binding(.Left, pos, 10, 3, rens).x
// 				render_texture(get_texture_handle(.CaveSlash), pos + {2, 0}, 3)
// 				render_texture(get_texture_handle(.GamepadAnalogStick), pos + {10, -2}, 3)
// 			case .DrawBindingRight:
// 				pos := e.pos + {-5, 0}
// 				pos.x += draw_keyboard_binding(.Right, pos, 10, 3, rens).x
// 				render_texture(get_texture_handle(.CaveSlash), pos + {2, 0}, 3)
// 				render_texture(get_texture_handle(.GamepadAnalogStick), pos + {10, -2}, 3, flip = true)
// 			case .DrawBindingJump:
// 				if input.gamepad {
// 					render_gamepad_glyph(gpb[.Jump], settings.gamepad_type, pos, 3, variant = .Cave, tint = r0_color)
// 				} else {
// 					draw_keyboard_binding(.Jump, pos, 10, e.layer, rens)
// 				}

// 			case .DrawBindingJumpHold:
// 				str := "Hold"
// 				ts := rl.MeasureTextEx(g_mem.dialogue_font, temp_cstring(str), 10, 0)


// 				if input.gamepad {
// 					append(rens, Renderable {
// 						variant = RenderableString {
// 							str = str,
// 							size = 10,
// 							color = ColorBrown,
// 							font = g_mem.dialogue_font,
// 							pos = pos - {ts.x - 8, 0},
// 						},
// 						layer = layer,
// 					})

// 					pos.y += ts.y + 4
// 					render_gamepad_glyph(gpb[.Jump], settings.gamepad_type, pos, 3, variant = .Cave)
// 				} else {
// 					append(rens, Renderable {
// 						variant = RenderableString {
// 							str = str,
// 							size = 10,
// 							color = ColorBrown,
// 							font = g_mem.dialogue_font,
// 							pos = pos - {ts.x - 8, 0},
// 						},
// 						layer = layer,
// 					})

// 					draw_keyboard_binding(.Jump, pos + {8, ts.y + 4}, 10, e.layer, rens, .Right)
// 				}

// 			case .DrawBindingUse:
// 				if input.gamepad {
// 					str := "Use: "
// 					ts := rl.MeasureTextEx(g_mem.dialogue_font, temp_cstring(str), 10, 0)

// 					append(rens, Renderable {
// 						variant = RenderableString {
// 							str = str,
// 							size = 10,
// 							color = ColorLight,
// 							font = g_mem.dialogue_font,
// 							pos = e.pos,
// 						},
// 						layer = e.layer,
// 					})

// 					render_gamepad_glyph(gpb[.Use], settings.gamepad_type, e.pos + {ts.x + 3, ts.y/2}, 3)
// 				} else {
// 					pos.y += draw_keyboard_binding(.Use, pos- {8,8}, 10, e.layer, rens).y + 1
// 					pos.y += draw_keyboard_binding(.NextItem, pos- {8,8}, 10, e.layer, rens).y + 1
// 				}
// 		}

// 		for r_idx in 0..<e.num_renderables {
// 			r := &e.renderables[r_idx]
// 			switch r.type {
// 				case .Texture, .Animation:
// 					if t, ok := get_texture(r.texture); ok {
// 						source := r.rect

// 						if rect_is_empty(source) {
// 							source = {
// 								0,
// 								0,
// 								f32(t.width),
// 								f32(t.height),
// 							}
// 						}

// 						scl := e.scale == 0 ? 1 : e.scale

// 						offset_rot := vec2_rot(r.offset * scl, e.rot)

// 						if (e.flip_with_facing && e.facing == .West) || e.flip_x {
// 							source.width = -source.width
// 						}

// 						dest := Rect {
// 							pos.x + offset_rot.x,
// 							pos.y + offset_rot.y,
// 							math.abs(source.width) * scl,
// 							math.abs(source.height) * scl,
// 						}

// 						origin := scl != 1 ? rect_local_middle(dest) : linalg.floor(rect_local_middle(dest))

// 						if !rl.CheckCollisionRecs(cr, rect_add_pos(dest, -origin)) {
// 							continue
// 						}

// 						append(rens, Renderable {
// 							variant = RenderableTexture {
// 								texture = t,
// 								texture_rect = source,
// 								dest_rect = dest,
// 								origin = origin,
// 								rotation = e.rot,
// 								tint_color = r.color,
// 								tint = r.apply_color,
// 							},
// 							layer = e.layer + r.relative_layer,
// 						})
// 					}

// 				case .Letter:
// 					append(rens, Renderable {
// 						variant = RenderableString {
// 							str = strings.string_from_ptr(&r.letter, 1),
// 							size = r.letter_size,
// 							color = r.color,
// 							font = g_mem.dialogue_font,
// 							pos = e.pos,
// 							rot = e.rot,
// 						},
// 						layer = e.layer,
// 					})
// 			}

// 		}
// 	}

// 	profile_end()

// 	if len(g_mem.active_interactions) == 0 && g_mem.interactable_in_range != EntityHandleNone && g_mem.time > g_mem.disable_interaction_until && !g_mem.hide_hud {
// 		eh := g_mem.interactable_in_range

// 		if e := get_entity_raw(eh); e != nil {
// 			flip := Vec2{1,1}

// 			if e.facing == .West || e.flip_x {
// 				flip.x = -1
// 			}

// 			icon_pos := e.pos + e.interactable_offset * flip + e.interactable_icon_offset * flip

// 			all_actions := get_all_player_actions()

// 			if g_mem.selected_action < len(all_actions) {
// 				a := all_actions[g_mem.selected_action]
// 				tex := get_player_action_texture(a)

// 				if a.type == .Talk {
// 					icon_pos.x += 3
// 					icon_pos.y -= 1
// 					tex = g_mem.talk_icon
// 				}

// 				if tex != TextureHandleNone {
// 					render_texture(tex, icon_pos, 100, false)
// 				}
// 			}
// 		}
// 	}

// 	profile_start("sort renderables")
// 	slice.sort_by(rens[:], proc(i, j: Renderable) -> bool { return i.layer < j.layer })
// 	profile_end()

// 	profile_start("render")
// 	for r in rens {
// 		switch &v in r.variant {
// 			case RenderableTexture:
// 				rl.DrawTexturePro(v.texture, v.texture_rect, v.dest_rect, v.origin, v.rotation, v.tint ? v.tint_color : rl.WHITE)

// 			case RenderableCircle:
// 				rl.DrawCircleV(v.pos, v.radius, v.color)

// 			case RenderableRect:
// 				render_rectangle(v.rect, v.color)

// 			case RenderableLine:
// 				rl.DrawLineV(v.start, v.end, v.color)

// 			case RenderableRectLines:
// 				rl.DrawRectangleLinesEx(v.rect, 1, v.color)

// 			case RenderableLineBezierCubic:
// 				rl.DrawSplineBezierCubic(&v.start, 4, 0.2, v.color)

// 			case RenderableString:
// 				cs := temp_cstring(v.str)
// 				ts := rl.MeasureTextEx(g_mem.dialogue_font, cs, v.size, 0)
// 				rl.DrawTextPro(v.font, cs, v.pos + ts*0.5, ts * 0.5, v.rot, v.size, 0, v.color)
// 		}
// 	}

// 	profile_end()

// 	for &t in g_mem.text_to_render {
// 		n := len(t.text)
// 		p := t.pos

// 		rp: [1]rune
// 		for r, i in t.text {
// 			if r == '\n' {
// 				p.y += MetricDialogueFontHeight
// 				p.x = t.pos.x
// 				continue
// 			}

// 			if t.time_on_line >= 0 && t.time_on_line < f32(i) * DialogueRuneAppearTime {
// 				break
// 			}

// 			rp[0] = r
// 			ar := rl.MeasureTextEx(g_mem.dialogue_font, temp_cstring(utf8.runes_to_string(rp[:], context.temp_allocator)), MetricDialogueFontHeight, 0)
// 			rl.DrawTextCodepoint(g_mem.dialogue_font, r, p, MetricDialogueFontHeight, t.color)
// 			p.x += ar.x
// 		}
// 	}

// 	if g_mem.debug_draw {
// 		ent_iter := ha_make_iter(g_mem.world.entities)
// 		for e, eh in ha_iter_ptr(&ent_iter) {
// 			#partial switch &v in e.variant {
// 				case PlayerCat:
// 					p := entity_inst(e, &v)
// 					c := get_player_collider(p.pos, &p.state)
// 					render_rectangle(c, {255, 0, 0, 75})
// 					rl.DrawCircleV(get_player_grab_pos(p), 1, rl.PURPLE)

// 					fc := get_player_feet_collider(p)
// 					render_rectangle(fc, { 0, 255, 0, 75 })

// 					frc := get_player_front_collider(p)
// 					render_rectangle(frc, { 0, 0, 255, 75 })

// 					hc := get_player_head_collider(p)
// 					render_rectangle(hc, { 255, 255, 0, 75 })


// 				case Rocket:
// 					c := get_rocket_collider(e.pos)
// 					render_rectangle(c, {255, 0, 0, 75})

// 				case Trigger:
// 					r := Rect {
// 						x = e.x,
// 						y = e.y,
// 						width = v.rect.width,
// 						height = v.rect.height,
// 					}
// 					render_rectangle(r, color_a(rl.YELLOW.rgb, 50))

// 				case Usable:
// 					rl.DrawCircleV(e.pos, 1, rl.YELLOW)

// 				case Spline:
// 					// TODO: this does not work bc the spline uses rens
// 					draw_spline(rens, e.pos, v)

// 				case StaticCollider:
// 					r := Rect {
// 						x = e.x,
// 						y = e.y,
// 						width = v.collider.width,
// 						height = v.collider.height,
// 					}
// 					render_rectangle(r, color_a(rl.RED.rgb, 50))

// 				case SplineEvaluator:
// 					rl.DrawCircleV(e.pos, 1, rl.RED)
// 			}
// 		}

// 		for gp in g_mem.world.grab_points {
// 			rl.DrawCircleV(gp.pos, 1, rl.GREEN)

// 			hsgp := hang_state_grab_pos(gp.pos, gp.compatible_facing)
// 			coll := get_hang_state_collider(hsgp)
// 			render_rectangle(coll, color_a(rl.GREEN.rgb, 100))
// 			rl.DrawCircleV(hsgp, 1, rl.YELLOW)
// 		}

// 		for c in world.colliders {
// 			render_rectangle(c.rect, {255, 0, 0, 75})
// 		}
// 	}

// 	profile_start("end mode 2d")
// 	rl.EndMode2D()
// 	profile_end()

// 	#partial switch gs in g_mem.game_state {
// 		case GameStateSpaceGame:
// 			size: f32 = gs.bottom_text_size * default_game_camera_zoom()
// 			str := strings.clone_from_bytes(gs.needed, context.temp_allocator)
// 			text := temp_cstring(str)
// 			ts := rl.MeasureTextEx(g_mem.dialogue_font, text, size, 0)
// 			sw := screen_width()
// 			sh := screen_height()
// 			p := sw/2 - ts.x/2
// 			xx: f32 = 0
// 			for _, idx in gs.needed {
// 				has := idx < len(gs.current) && gs.current[idx] == gs.needed[idx]
// 				cc := temp_cstring(str[idx:idx+1])
// 				cc_draw := has ? cc : temp_cstring("_")
// 				rl.DrawTextEx(g_mem.dialogue_font, cc_draw, {p + xx, sh - ts.y - 5} + gs.bottom_text_offset, size, 0, ColorCat)
// 				xx += max(rl.MeasureTextEx(g_mem.dialogue_font, cc, size, 0).x, rl.MeasureTextEx(g_mem.dialogue_font, cc_draw, size, 0).x)
// 			}
// 	}
// }

// remap :: proc "contextless" (old_value, old_min, old_max, new_min, new_max: $T) -> (x: T) where intrinsics.type_is_numeric(T), !intrinsics.type_is_array(T) {
// 	old_range := old_max - old_min
// 	new_range := new_max - new_min
// 	if old_range == 0 {
// 		return new_range / 2
// 	}
// 	return clamp(((old_value - old_min) / old_range) * new_range + new_min, new_min, new_max)
// }

@(private = "file")
g_mem: ^GameMemory
// input: Input

font: rl.Font

// // *GAME API*

// load_textures :: proc() {
// 	g_mem.tileset = get_texture_handle(.Tileset)
// 	g_mem.editor_memory.checker_texture = get_texture_handle(.Checker)
// 	g_mem.talk_icon = get_texture_handle(.InteractIconTalkBig)
// 	g_mem.talk_bg_arrow = get_texture_handle(.TalkBgArrow)
// }

// load_shaders :: proc() {
// 	rl.UnloadShader(g_mem.pixel_filter_shader)
// 	g_mem.pixel_filter_shader = load_shader(.PixelFilter)
// }

// Settings :: struct {
// 	keyboard_bindings: [Binding]rl.KeyboardKey,
// 	gamepad_bindings: [Binding]rl.GamepadButton,
// 	gamepad_type: GamepadType,
// 	try_autodetect_gamepad: bool,
// 	music_volume: int,
// 	effects_volume: int,
// }

// settings: ^Settings

// ar_16_9 :: 9.0/16.0
// ar_16_10 :: 10.0/16.0

// AspectRatio :: enum {
// 	AR16_9,
// 	AR16_10,
// }

// wanted_ar_id :: proc() -> AspectRatio {
// 	cur_ar := current_ar()

// 	diff_16_9 := math.abs(cur_ar - ar_16_9)
// 	diff_16_10 := math.abs(cur_ar - ar_16_10)

// 	return diff_16_9 < diff_16_10 ? .AR16_9 : .AR16_10
// }

// wanted_ar :: proc() -> f32 {
// 	switch wanted_ar_id() {
// 		case .AR16_9: return ar_16_9
// 		case .AR16_10: return ar_16_10
// 	}

// 	return ar_16_9
// }

// // NOTE: this is the AR of the window, not of the render texture the game is drawn to
// current_ar :: proc() -> f32 {
// 	if rl.IsWindowFullscreen() {
// 		return f32(rl.GetMonitorHeight(rl.GetCurrentMonitor()))/f32(rl.GetMonitorWidth(rl.GetCurrentMonitor()))
// 	} else {
// 		return f32(rl.GetRenderHeight())/f32(rl.GetRenderWidth())
// 	}
// }

// ar_width_offset :: proc() -> f32 {
// 	war := wanted_ar_id()

// 	switch war {
// 		case .AR16_9:
// 			return 0
// 		case .AR16_10:
// 			return screen_height() * (1.0/16.0) * dpi_scale()
// 	}

// 	return 0
// }

// update_main_drawing_tex :: proc() {
// 	t := &g_mem.main_drawing_tex

// 	war := wanted_ar()

// 	if current_ar() > war {
// 		w := rl.GetRenderWidth()

// 		if rl.IsWindowFullscreen() {
// 			w = rl.GetMonitorWidth(rl.GetCurrentMonitor())
// 		}

// 		h := i32(math.ceil(f32(w)*war))

// 		if t.texture.width != w || t.texture.height != h {
// 			rl.UnloadRenderTexture(t^)
// 			t^ = rl.LoadRenderTexture(w, h)
// 			rl.SetTextureWrap(t.texture, .CLAMP)
// 		}
// 	} else {
// 		h := rl.GetRenderHeight()

// 		if rl.IsWindowFullscreen() {
// 			h = rl.GetMonitorHeight(rl.GetCurrentMonitor())
// 		}

// 		w := i32(math.ceil(f32(h)*(1.0/war)))

// 		if t.texture.width != w || t.texture.height != h {
// 			rl.UnloadRenderTexture(t^)
// 			t^ = rl.LoadRenderTexture(w, h)
// 			rl.SetTextureWrap(t.texture, .CLAMP)
// 		}
// 	}

// }

// sound_max_volume :: 10
// default_music_volume :: 7
// default_effects_volume :: 10

@(export)
game_init :: proc(level_name_int: int) {
	log.info("Game init")

	g_mem = new(GameMemory)

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

	// g_mem.settings = {
	// 	keyboard_bindings = default_keyboard_bindings,
	// 	gamepad_bindings = default_gamepad_bindings,
	// 	music_volume = default_music_volume,
	// 	effects_volume = default_effects_volume,
	// }

	g_mem.run = true
	// update_globals(g_mem)

	// music_init(&g_mem.music)

	// load_settings()
	// load_save()

	// asset_storage_init(&g_mem.asset_storage)

	// reload_editor_entity_textures(&g_mem.editor_memory)
	g_mem.font = load_font(.Font, int(MetricFontHeight * dpi_scale() * 4))
	g_mem.font_bold = load_font(.FontBold, int(192 * dpi_scale()))
	font = g_mem.font
	// g_mem.editor_memory.font = g_mem.font
	g_mem.dialogue_font = load_font(.DialogueFont, 64)

	// load_textures()
	// refresh_padded_tileset()

	// update_main_drawing_tex()
	// g_mem.camera_state.zoom = default_game_camera_zoom()

	if true {
		// if level_name_int != -1 {
		// level_name := LevelName(level_name_int)
		// load_level(level_name)
		// g_mem.root_state = RootStatePlaying{}
	} else {
		// enter_main_menu()
	}

	// load_shaders()
}

// enter_main_menu :: proc() {
// 	load_level(.MainMenu)
// 	g_mem.root_state = RootStateMainMenu{}
// 	g_mem.hide_hud = true
// 	play_music(&g_mem.music, .Menu)
// }

// HRSettings :: struct {
// 	keyboard_bindings: map[string]string,
// 	gamepad_bindings: map[string]string,
// 	gamepad_type: GamepadType,
// 	music_volume: Maybe(int),
// 	effects_volume: Maybe(int),
// }

// SavedGame :: struct {
// 	checkpoint: Checkpoint,
// 	portraits: bit_set[Portrait],
// }

// portrait_descriptions := [Portrait]string {
// 	.Lakrits =
// `Name: Lakrits

// Likes: Food, peace and quiet

// Dislikes: Loud sounds (children)

// A big, gentle and friendly man in
// a tuxedo. Does very firm and
// friendly headbutts. He's the
// brother of Lillemor.`,

// 	.Klucke =
// `Name: Klucke (Yuki)

// Likes: Being carried

// Dislikes: Getting brushed

// A tiny floofy floof. Since
// she hates getting brushed she
// sometimes has to be shaved.
// Which she hates even more.`,
// 	.Lillemor =
// `Name: Lillemor

// Likes: Intense petting in the sun

// Dislikes: Choosing to go in or out

// A master of making friendly
// purring meow sounds. Thoroughly
// inspects whatever the humans
// are up to. Sister of Lakrits.`,
// 	.Pontus =
// `Name: Pontus

// Likes: Eating fish and sleeping

// Dislikes: Most other animals

// Very round and very grumpy. He
// was found in a shed as a kitten.
// Likes to wake up his humans by
// biting their toes.
// `,
// }

// Portrait :: enum {
// 	Klucke,
// 	Lakrits,
// 	Lillemor,
// 	Pontus,
// }

// get_portraits :: proc() -> bit_set[Portrait] {
// 	p: bit_set[Portrait]

// 	for i in g_mem.inventory.items {
// 		switch i.item {
// 			case .None, .OnionSeed, .WaterBucket, .Egg, .Key, .Butter, .Flour, .BaseballBat, .Unused:

// 			case .KluckePortrait: p += { .Klucke }
// 			case .LakritsPortrait: p += { .Lakrits }
// 			case .LillemorPortrait: p += { .Lillemor }
// 			case .PontusPortrait: p += { .Pontus }
// 		}
// 	}

// 	return p
// }

// save_game_to_disk :: proc() {
// 	g_mem.save.portraits = {}

// 	for i in g_mem.inventory.items {
// 		switch i.item {
// 			case .None, .OnionSeed, .WaterBucket, .Egg, .Key, .Butter, .Flour, .BaseballBat, .Unused:

// 			case .KluckePortrait: g_mem.save.portraits += { .Klucke }
// 			case .LakritsPortrait: g_mem.save.portraits += { .Lakrits }
// 			case .LillemorPortrait: g_mem.save.portraits += { .Lillemor }
// 			case .PontusPortrait: g_mem.save.portraits += { .Pontus }
// 		}
// 	}

// 	fn := savegame_filename()

// 	if save_json, err := json.marshal(g_mem.save, DataMarshalOptions, context.temp_allocator); err == nil {
// 		os.make_directory(filepath.dir(fn, context.temp_allocator))

// 		if os.write_entire_file(fn, save_json) {
// 			g_mem.last_saved_at = time.now()
// 		} else {
// 			log.errorf("Failed to write to {0}", fn)
// 		}
// 	} else {
// 		log.errorf("Failed to convert save to text: {0}", err)
// 	}
// }

// load_save :: proc() {
// 	if save_data, ok := os.read_entire_file(savegame_filename(), context.temp_allocator); ok {
// 		if json.unmarshal(save_data, &g_mem.save, .Bitsquid, context.temp_allocator) != nil {
// 			log.error("Failed loading save")
// 		}
// 	}
// }


// save_settings :: proc() {
// 	// turn bindings into "Jump" = "Space" etc so they are easy to understand in settings.sjson later
// 	hr_settings := HRSettings {
// 		keyboard_bindings = make(map[string]string, allocator = context.temp_allocator),
// 		gamepad_bindings = make(map[string]string, allocator = context.temp_allocator),
// 		gamepad_type = settings.gamepad_type,
// 		music_volume = settings.music_volume,
// 		effects_volume = settings.effects_volume,
// 	}

// 	for rl_key, game_key in settings.keyboard_bindings {
// 		game_key_str, game_key_str_ok := fmt.enum_value_to_string(game_key)
// 		rl_key_str, rl_key_str_ok := fmt.enum_value_to_string(rl_key)
// 		if game_key_str_ok && rl_key_str_ok {
// 			hr_settings.keyboard_bindings[game_key_str] = rl_key_str
// 		}
// 	}

// 	for rl_key, game_key in settings.gamepad_bindings {
// 		game_key_str, game_key_str_ok := fmt.enum_value_to_string(game_key)
// 		rl_key_str, rl_key_str_ok := fmt.enum_value_to_string(rl_key)
// 		if game_key_str_ok && rl_key_str_ok {
// 			hr_settings.gamepad_bindings[game_key_str] = rl_key_str
// 		}
// 	}

// 	fn := settings_filename()

// 	if settings_json, err := json.marshal(hr_settings, DataMarshalOptions, context.temp_allocator); err == nil {
// 		os.make_directory(filepath.dir(fn, context.temp_allocator))

// 		if !os.write_entire_file(fn, settings_json) {
// 			log.errorf("Failed to write to {0}", fn)
// 		}
// 	} else {
// 		log.errorf("Failed to convert settings to text: {0}", err)
// 	}
// }

// load_settings :: proc() {
// 	if settings_data, ok := os.read_entire_file(settings_filename(), context.temp_allocator); ok {
// 		hr_settings: HRSettings

// 		if json.unmarshal(settings_data, &hr_settings, .Bitsquid, context.temp_allocator) == nil {
// 			for k,v in hr_settings.keyboard_bindings {
// 				binding, binding_ok := fmt.string_to_enum_value(Binding, k)
// 				value, value_ok := fmt.string_to_enum_value(rl.KeyboardKey, v)
// 				if binding_ok && value_ok {
// 					settings.keyboard_bindings[binding] = value
// 				}
// 			}

// 			for k,v in hr_settings.gamepad_bindings {
// 				binding, binding_ok := fmt.string_to_enum_value(Binding, k)
// 				value, value_ok := fmt.string_to_enum_value(rl.GamepadButton, v)
// 				if binding_ok && value_ok {
// 					settings.gamepad_bindings[binding] = value
// 				}
// 			}

// 			settings.gamepad_type = hr_settings.gamepad_type
// 			settings.music_volume = hr_settings.music_volume.? or_else default_music_volume
// 			settings.effects_volume = hr_settings.effects_volume.? or_else default_effects_volume
// 		}
// 	} else {
// 		// auto detect gamepad type (do it later when gamepad is available)
// 		settings.try_autodetect_gamepad = true
// 	}
// }

@(export)
game_shutdown :: proc() {
	using g_mem

	if level_data, err := json.marshal(level, allocator = context.temp_allocator); err == nil {
		os.write_entire_file(LEVELS_PATH + "level.json", level_data)
	}
	delete(level.platforms)

	// clear_interactions()
	// delete(g_mem.active_interactions)
	// music_shutdown(&g_mem.music)
	// sound_shutdown()
	// save_settings()

	// if g_mem.editing {
	// edit_mode_shutdown()
	// }

	// delete_game_state(g_mem.game_state)
	// delete_world(g_mem.world)

	// delete(g_mem.inventory.items)
	// asset_storage_shutdown()
	// delete(g_mem.editor_memory.entity_textures)
	// delete(g_mem.text_to_render)
	// delete(g_mem.next_events)
	// delete(g_mem.delayed_events)

	rl.UnloadFont(g_mem.dialogue_font)
	rl.UnloadFont(g_mem.font)
	rl.UnloadFont(g_mem.font_bold)

	// delete_serialized_state(g_mem.serialized_state)

	// delete(g_mem.editor_memory.selection)
	// delete(g_mem.to_render)
	// delete(g_mem.editor_memory.edit_mode_place_tiles.selected_tiles)

	// rl.UnloadTexture(g_mem.tileset_padded)
	// rl.UnloadShader(g_mem.pixel_filter_shader)

	// when CatProfile {
	// 	if g_mem.profiling {
	// 		b := g_mem.spall_buffer.data
	// 		spall.buffer_destroy(&g_mem.spall_ctx, &g_mem.spall_buffer)
	// 		delete(b)
	// 		spall.context_destroy(&g_mem.spall_ctx)
	// 	}
	// }

	free(g_mem)
	g_mem = nil
}

// when CatProfile {
// @(deferred_none=profile_scope_end)
// 	profile_scope :: proc(name: string = "", loc := #caller_location) {
// 		if !g_mem.profiling {
// 			return
// 		}

// 		spall._buffer_begin(&g_mem.spall_ctx, &g_mem.spall_buffer, name, "", loc)
// 	}

// 	profile_scope_end :: proc() {
// 		if !g_mem.profiling {
// 			return
// 		}

// 		spall._buffer_end(&g_mem.spall_ctx, &g_mem.spall_buffer)
// 	}

// 	profile_start :: proc(name: string, loc := #caller_location) {
// 		if !g_mem.profiling {
// 			return
// 		}

// 		spall._buffer_begin(&g_mem.spall_ctx, &g_mem.spall_buffer, name, "", loc)
// 	}

// 	profile_end :: proc() {
// 		if !g_mem.profiling {
// 			return
// 		}

// 		spall._buffer_end(&g_mem.spall_ctx, &g_mem.spall_buffer)
// 	}
// } else {
// 	profile_scope :: proc(name: string = "") {
// 	}

// 	profile_scope_end :: proc() {
// 	}

// 	profile_start :: proc(name: string) {
// 	}

// 	profile_end :: proc() {
// 	}
// }

// refresh_padded_tileset :: proc() {
// 	if g_mem.tileset_padded.id != 0 {
// 		rl.UnloadTexture(g_mem.tileset_padded)
// 		g_mem.tileset_padded = {}
// 	}

// 	ts_source := load_image(.Tileset)
// 	defer rl.UnloadImage(ts_source)
// 	tileset_height := ts_source.height / TileHeight

// 	ts_padded := rl.Image {
// 		width = ts_source.width + 4*2,
// 		height = ts_source.height + tileset_height*2,
// 		mipmaps = 1,
// 		format = ts_source.format,
// 	}

// 	pixels := make([]rl.Color, ts_padded.width*ts_padded.height, context.temp_allocator)
// 	ts_padded.data = rawptr(&pixels[0])

// 	for tile_idx in 0..<tileset_height*4 {
// 		tile_x := f32(tile_idx % 4)
// 		tile_y := f32(tile_idx / 4)

// 		px := tile_x * TileHeight
// 		py := tile_y * TileHeight
// 		ts: f32 = TileHeight

// 		{
// 			source := Rect {
// 				px,
// 				py,
// 				ts,
// 				ts,
// 			}

// 			dest := Rect {
// 				px + 2*tile_x + 1,
// 				py + 2*tile_y + 1,
// 				ts,
// 				ts,
// 			}

// 			rl.ImageDraw(&ts_padded, ts_source, source, dest, rl.WHITE)
// 		}

// 		// Fill in borders of padded tileset

// 		// Top
// 		{
// 			source := Rect {
// 				px,
// 				py,
// 				ts,
// 				1,
// 			}

// 			dest := Rect {
// 				px + 2*tile_x + 1,
// 				py + 2*tile_y,
// 				ts,
// 				1,
// 			}

// 			rl.ImageDraw(&ts_padded, ts_source, source, dest, rl.WHITE)
// 		}

// 		// Bottom
// 		{
// 			source := Rect {
// 				px,
// 				py + ts - 1,
// 				ts,
// 				1,
// 			}

// 			dest := Rect {
// 				px + 2*tile_x + 1,
// 				py + 2*tile_y + ts + 1,
// 				ts,
// 				1,
// 			}

// 			rl.ImageDraw(&ts_padded, ts_source, source, dest, rl.WHITE)
// 		}

// 		// Left
// 		{
// 			source := Rect {
// 				px,
// 				py,
// 				1,
// 				ts,
// 			}

// 			dest := Rect {
// 				px + 2*tile_x,
// 				py + 2*tile_y + 1,
// 				1,
// 				ts,
// 			}

// 			rl.ImageDraw(&ts_padded, ts_source, source, dest, rl.WHITE)
// 		}

// 		// Right
// 		{
// 			source := Rect {
// 				px + ts - 1,
// 				py,
// 				1,
// 				ts,
// 			}

// 			dest := Rect {
// 				px + 2*tile_x + ts + 1,
// 				py + 2*tile_y + 1,
// 				1,
// 				ts,
// 			}

// 			rl.ImageDraw(&ts_padded, ts_source, source, dest, rl.WHITE)
// 		}
// 	}

// 	g_mem.tileset_padded = rl.LoadTextureFromImage(ts_padded)
// 	rl.SetTextureWrap(g_mem.tileset_padded, .CLAMP)
// 	rl.SetTextureFilter(g_mem.tileset_padded, .BILINEAR)
// }

// PlayerActionType :: enum {
// 	Inspect,
// 	UseItem,
// 	Talk,
// 	Pickup,
// }

// PlayerAction :: struct {
// 	type: PlayerActionType,
// 	item: PickupType,
// 	added_at: f64,
// 	item_original_screen_pos: Maybe(Vec2),
// }

// get_player_action_texture :: proc(a: PlayerAction) -> (tex: TextureHandle) {
// 	switch a.type {
// 		case .UseItem:
// 			switch a.item {
// 				case .None:
// 				case .OnionSeed: tex = get_texture_handle(.OnionSeed)
// 				case .WaterBucket: tex = get_texture_handle(.Bucket)
// 				case .Egg: tex = get_texture_handle(.Egg)
// 				case .Key: tex = get_texture_handle(.Key)
// 				case .Butter: tex = get_texture_handle(.Butter)
// 				case .Flour: tex = get_texture_handle(.Flour)
// 				case .BaseballBat: tex = get_texture_handle(.Mallet)
// 				case .Unused:
// 				case .KluckePortrait: tex = get_texture_handle(.KluckePortrait)
// 				case .LakritsPortrait: tex = get_texture_handle(.LakritsPortrait)
// 				case .LillemorPortrait: tex = get_texture_handle(.LillemorPortrait)
// 				case .PontusPortrait: tex = get_texture_handle(.PontusPortrait)
// 			}

// 		case .Talk:
// 			tex = get_texture_handle(.InteractIconTalk)

// 		case .Pickup:
// 			tex = get_texture_handle(.PickupItemIcon)

// 		case .Inspect:
// 			tex = get_texture_handle(.QuestionMark)
// 	}

// 	return
// }

// get_all_player_actions :: proc() -> [dynamic]PlayerAction {
// 	actions := make([dynamic]PlayerAction, context.temp_allocator)

// 	append(&actions, PlayerAction {
// 		type = .Inspect,
// 	})

// 	append(&actions, PlayerAction {
// 		type = .Talk,
// 	})

// 	append(&actions, PlayerAction {
// 		type = .Pickup,
// 	})

// 	/*
// 	append(&actions, PlayerAction {
// 		type = .UseItem,
// 		item = .Flour,
// 	})


// 	append(&actions, PlayerAction {
// 		type = .UseItem,
// 		item = .Butter,
// 	})
// 	append(&actions, PlayerAction {
// 		type = .UseItem,
// 		item = .Flour,
// 	})

// 	append(&actions, PlayerAction {
// 		type = .UseItem,
// 		item = .Egg,
// 	})*/

// 	for i in g_mem.inventory.items {
// 		append(&actions, PlayerAction {
// 			type = .UseItem,
// 			item = i.item,
// 			added_at = i.added_at,
// 			item_original_screen_pos = i.original_screen_pos,
// 		})
// 	}

// 	return actions
// }

// when CatProfile  {
// 	ft_avg: [60]f32
// 	ft_avg_i: int
// 	last_spike: f32
// }

// @(export)
game_update :: proc() -> bool {
	using g_mem
	rl.BeginDrawing()
	rl.ClearBackground({110, 184, 168, 255})

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

	update_animation(&current_anim)

	screen_height := f32(rl.GetScreenHeight())

	camera := rl.Camera2D {
		zoom   = screen_height / PixelWindowHeight,
		offset = {f32(rl.GetScreenWidth() / 2), screen_height / 2},
		target = player_pos,
	}

	rl.BeginMode2D(camera)
	draw_animation(current_anim, player_pos, player_flip)
	for platform in level.platforms {
		rl.DrawTextureV(platform_texture, platform, rl.WHITE)
	}
	//rl.DrawRectangleRec(player_feet_collider, {0, 255, 0, 100})

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
	rl.EndDrawing()
	// 	when CatProfile {
	// 		if rl.IsKeyPressed(.F9) {
	// 			if !g_mem.profiling {
	// 				g_mem.spall_ctx = spall.context_create("profile.spall")
	// 				buffer_backing := make([]u8, spall.BUFFER_DEFAULT_SIZE)
	// 				g_mem.spall_buffer = spall.buffer_create(buffer_backing)
	// 				g_mem.profiling = true
	// 			} else {
	// 				b := g_mem.spall_buffer.data
	// 				spall.buffer_destroy(&g_mem.spall_ctx, &g_mem.spall_buffer)
	// 				delete(b)
	// 				spall.context_destroy(&g_mem.spall_ctx)
	// 				g_mem.profiling = false
	// 			}
	// 		}
	// }

	// 	if g_mem.camera_state.shake_until != 0 {
	// 		if g_mem.time > g_mem.camera_state.shake_until {
	// 			g_mem.camera_state.shake_until = 0
	// 			g_mem.camera_state.shake_amp = 0
	// 			g_mem.camera_state.shake_freq = 0
	// 		}
	// 	}

	// 	profile_scope()

	// 	when CAT_DEV {
	// 		if !g_mem.editing && rl.IsKeyDown(.LEFT_SHIFT) {
	// 			if rl.IsKeyPressed(.ONE) {
	// 				load_checkpoint(.Planet, get_portraits())
	// 			}

	// 			if rl.IsKeyPressed(.TWO) {
	// 				load_checkpoint(.PlanetGotEgg, get_portraits())
	// 			}

	// 			if rl.IsKeyPressed(.THREE) {
	// 				load_checkpoint(.OtherPlace, get_portraits())
	// 			}

	// 			if rl.IsKeyPressed(.FOUR) {
	// 				load_checkpoint(.Space, get_portraits())
	// 			}

	// 			if rl.IsKeyPressed(.FIVE) {
	// 				load_checkpoint(.PlanetBack, get_portraits())
	// 			}

	// 			if rl.IsKeyPressed(.SIX) {
	// 				load_checkpoint(.SpaceHouse, get_portraits())
	// 			}

	// 			if rl.IsKeyPressed(.SEVEN) {
	// 				load_checkpoint(.PancakeBatterLand, get_portraits())
	// 			}
	// 		}
	// 	}

	// 	if g_mem.load_next_level {
	// 		load_level(g_mem.next_level_name)
	// 		g_mem.load_next_level = false
	// 		save_game_to_disk()
	// 	}

	// 	if g_mem.next_controlled_entity != EntityNone {
	// 		g_mem.controlled_entity = g_mem.next_controlled_entity
	// 		g_mem.next_controlled_entity = EntityNone
	// 	}

	// 	when CAT_DEV {
	// 		if rl.IsKeyPressed(.F4) {
	// 			load_textures()
	// 			reload_all()
	// 			reload_editor_entity_textures(&g_mem.editor_memory)
	// 			refresh_padded_tileset()
	// 			load_shaders()
	// 		}
	// 	}

	// 	update_main_drawing_tex()

	// 	if g_mem.editing {
	// 		rl.BeginDrawing()
	// 		edit_mode_update()
	// 		rl.EndDrawing()
	// 	} else {
	// 		profile_start("update into main texture")
	// 		rl.BeginTextureMode(g_mem.main_drawing_tex)
	// 		rl.rlLoadIdentity()
	// 		dpi_scale := dpi_scale()

	// 		scl := [16]f32 {
	// 			dpi_scale, 0, 0, 0,
	// 			0, dpi_scale, 0, 0,
	// 			0, 0, 1, 0,
	// 			0, 0, 0, 1,
	// 		}

	// 		rl.rlMultMatrixf(&scl[0])

	// 		play_mode_update()

	// 		rl.EndTextureMode()
	// 		profile_end()
	// 		profile_start("blit onto screen")

	// 		rl.BeginDrawing()
	// 		rl.ClearBackground(rl.BLACK)
	// 		source := Rect {
	// 			0, 0,
	// 			f32(g_mem.main_drawing_tex.texture.width),
	// 			-f32(g_mem.main_drawing_tex.texture.height),
	// 		}

	// 		sw := rl.IsWindowFullscreen() ? f32(rl.GetMonitorWidth(rl.GetCurrentMonitor())) : f32(rl.GetScreenWidth())
	// 		sh := rl.IsWindowFullscreen() ? f32(rl.GetMonitorHeight(rl.GetCurrentMonitor())) : f32(rl.GetScreenHeight())

	// 		war := wanted_ar()

	// 		if current_ar() > war {
	// 			h := sw*war
	// 			dest := Rect {
	// 				0, sh/2 - h/2,
	// 				sw,
	// 				h,
	// 			}

	// 			rl.DrawTexturePro(g_mem.main_drawing_tex.texture, source, dest, {0, 0}, 0, rl.WHITE)
	// 		} else {
	// 			w := sh*(1/war)
	// 			dest := Rect {
	// 				sw/2 - w/2, 0,
	// 				w,
	// 				sh,
	// 			}

	// 			rl.DrawTexturePro(g_mem.main_drawing_tex.texture, source, dest, {0, 0}, 0, rl.WHITE)
	// 		}

	// 		profile_start("end draw")
	// 		rl.EndDrawing()
	// 		profile_end()
	// 		profile_end()
	// 	}

	// 	clear(&g_mem.to_render)
	// 	clear(&g_mem.text_to_render)

	// 	when CAT_DEV {
	// 		if rl.IsKeyPressed(.F2) {
	// 			delete(g_mem.to_render)
	// 			g_mem.to_render = {}
	// 			delete(g_mem.text_to_render)
	// 			g_mem.text_to_render = {}
	// 			delete(g_mem.delayed_events)
	// 			g_mem.delayed_events = {}
	// 			delete(g_mem.next_events)
	// 			g_mem.next_events = {}
	// 			if g_mem.editing {
	// 				g_mem.editing = false

	// 				cat_copy, has_cat_copy := get_entity_copy(g_mem.cat, PlayerCat)
	// 				rocket_copy, has_rocket_copy := get_entity_copy(g_mem.rocket, Rocket)

	// 				delete_serialized_state(g_mem.serialized_state)
	// 				g_mem.serialized_state = serialize_world(g_mem.editor_memory.world)
	// 				clear_interactions()
	// 				delete_world(g_mem.world)
	// 				g_mem.world = create_world(g_mem.serialized_state)
	// 				enable_world(&g_mem.world)

	// 				post_level_load(true)

	// 				if has_cat_copy {
	// 					if new_cat, has_new_cat := get_entity(g_mem.cat, PlayerCat); has_new_cat {
	// 						new_cat.pos = cat_copy.pos
	// 						new_cat.state = cat_copy.state
	// 						new_cat.anim = cat_copy.anim
	// 						new_cat.facing = cat_copy.facing
	// 						g_mem.camera_state.pos = cat_copy.pos
	// 					}
	// 				}

	// 				if has_rocket_copy {
	// 					if new_rocket, has_new_rocket := get_entity(g_mem.rocket, Rocket); has_new_rocket {
	// 						new_rocket.pos = rocket_copy.pos
	// 					}
	// 				}

	// 				edit_mode_shutdown()
	// 			} else {
	// 				g_mem.editing = true

	// 				g_mem.editor_memory.clear_color = g_mem.clear_color
	// 				g_mem.editor_memory.tileset = g_mem.tileset
	// 				g_mem.editor_memory.tileset_padded = g_mem.tileset_padded
	// 				g_mem.editor_memory.pixel_filter_shader = g_mem.pixel_filter_shader

	// 				edit_mode_init(g_mem.serialized_state, g_mem.level_name)
	// 			}
	// 		}

	// 		if rl.IsKeyPressed(.F3) {
	// 			g_mem.debug_draw = !g_mem.debug_draw
	// 		}
	// 	}

	// 	if rl.IsKeyPressed(.ENTER) && rl.IsKeyDown(.LEFT_ALT) {
	// 		toggle_fullscreen()

	// 		free_all(context.temp_allocator)
	// 	}

	// 	fmt.println("Iterating")

	// return rl.WindowShouldClose() == false && g_mem.run
	return !rl.WindowShouldClose()
}

@(export)
game_shutdown_window :: proc() {
	rl.CloseAudioDevice()
	rl.CloseWindow()
}

// @(export)
// game_memory_size :: proc() -> int {
// 	return size_of(GameMemory)
// }

when CAT_DEV {
	WindowFlags :: rl.ConfigFlags{.WINDOW_HIGHDPI, .WINDOW_RESIZABLE, .VSYNC_HINT}
} else {
	WindowFlags :: rl.ConfigFlags{.VSYNC_HINT}
}

// toggle_fullscreen :: proc() {
// 	when CAT_DEV {
// 		rl.ToggleBorderlessWindowed()
// 	} else {
// 		if rl.IsWindowFullscreen() {
// 			rl.SetWindowState(WindowFlags + { .WINDOW_RESIZABLE} )
// 			rl.SetWindowSize(1280, 720)
// 			rl.ShowCursor()
// 		} else {
// 			w := rl.GetMonitorWidth(rl.GetCurrentMonitor())
// 			h := rl.GetMonitorHeight(rl.GetCurrentMonitor())
// 			rl.ClearWindowState({ .WINDOW_RESIZABLE })
// 			rl.ToggleFullscreen()
// 			rl.SetWindowSize(w, h)
// 			rl.HideCursor()
// 		}
// 	}
// }

@(export)
game_init_window :: proc() {
	rl.SetTraceLogLevel(.WARNING)
	rl.SetConfigFlags(WindowFlags)
	rl.InitWindow(1280, 720, "CAT & ONION")
	rl.SetWindowPosition(200, 200)
	rl.SetWindowState({.WINDOW_RESIZABLE})
	// rl.SetExitKey(nil)
	rl.InitAudioDevice()
	// icon := load_image(.ProgramIcon)
	// rl.SetWindowIcon(icon)
	// rl.UnloadImage(icon)
	rl.SetTargetFPS(500)

	// TODO: Generate premultiplied alpha texture for shapes texture
	// shapes_tex := rl.GetShapesTexture()
	// rl.SetTextureFilter(shapes_tex, .BILINEAR)

	// when !CAT_DEV {
	// 	toggle_fullscreen()
	// }
}

// update_globals :: proc(mem: ^GameMemory) {
// 	g_mem = mem
// 	settings = &g_mem.settings
// 	font = g_mem.font
// 	world = &g_mem.world
// 	g_as = &g_mem.asset_storage
// 	editor_refresh_globals(&mem.editor_memory)
// 	sound_init(&mem.sound_state)
// }

// @(export)
// game_hot_reloaded :: proc(mem: ^GameMemory) {
// 	update_globals(mem)
// 	asset_storage_reload()

// }

// @(export)
// game_memory :: proc() -> rawptr {
// 	return g_mem
// }

// @(export)
// game_level_name :: proc() -> int {
// 	return int(g_mem.level_name)
// }
