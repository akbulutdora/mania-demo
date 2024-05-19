package game

// import rl "vendor:raylib"
// import "core:fmt"
// import "core:thread"
// import "core:time"

// _ :: fmt

// SoundAlias :: struct {
// 	name: SoundName,
// 	alias: rl.Sound,
// }

// SoundState :: struct {
// 	sound_aliases: [dynamic]SoundAlias,
// }

// sound_state: ^SoundState

// effects_vol :: proc() -> f32 {
// 	return f32(settings.effects_volume)/sound_max_volume
// }

// play_sound_alias :: proc(n: SoundName) -> rl.Sound {
// 	s := get_sound(n)

// 	if rl.IsSoundPlaying(s) {
// 		a := rl.LoadSoundAlias(s)
// 		rl.SetSoundVolume(a, sound_volume(n) * effects_vol())
// 		rl.SetSoundPitch(s, sound_pitch(n))
// 		rl.PlaySound(a)
// 		sa := SoundAlias {
// 			name = n,
// 			alias = a,
// 		}
// 		append(&sound_state.sound_aliases, sa)
// 		return a
// 	} else {
// 		rl.SetSoundVolume(s, sound_volume(n) * effects_vol())
// 		rl.SetSoundPitch(s, sound_pitch(n))
// 		rl.PlaySound(s)
// 		return s
// 	}
// }

// sound_update :: proc() {
// 	for i: int; i<len(sound_state.sound_aliases); {
// 		a := sound_state.sound_aliases[i]

// 		if !rl.IsSoundPlaying(a.alias) {
// 			rl.UnloadSoundAlias(a.alias)
// 			sound_state.sound_aliases[i] = pop(&sound_state.sound_aliases)
// 			continue
// 		}

// 		i += 1
// 	}
// }

// sound_init :: proc(s: ^SoundState) {
// 	sound_state = s
// }

// sound_shutdown :: proc() {
// 	for a in sound_state.sound_aliases {
// 		rl.UnloadSoundAlias(a.alias)
// 	}

// 	delete(sound_state.sound_aliases)
// 	sound_state = {}
// }

// play_sound :: proc(n: SoundName) {
// 	s := get_sound(n)
// 	rl.SetSoundVolume(s, sound_volume(n) * effects_vol())
// 	rl.SetSoundPitch(s, sound_pitch(n))
// 	rl.PlaySound(s)
// }

// play_if_not_playing :: proc(n: SoundName) {
// 	if is_sound_playing(n) {
// 		return
// 	}

// 	play_sound(n)
// }

// is_sound_playing :: proc(n: SoundName) -> bool{
// 	if rl.IsSoundPlaying(get_sound(n)) {
// 		return true
// 	}

// 	for sa in sound_state.sound_aliases {
// 		if sa.name == n && rl.IsSoundPlaying(sa.alias) {
// 			return true
// 		}
// 	}

// 	return false
// }

// get_sound_delay :: proc(s: SoundName) -> f32{
// 	#partial switch s {
// 		case .CatClimb0: return 0.1
// 		case .CatClimb1: return 0.1
// 		case .CatClimb2: return 0
// 	}

// 	return 0
// }

// play_sound_range :: proc(low: SoundName, high: SoundName) -> rl.Sound {
// 	name := SoundName(rl.GetRandomValue(i32(low), i32(high)))
// 	delay := get_sound_delay(name)

// 	if delay == 0 {
// 		return play_sound_alias(name)
// 	} else {
// 		send_delayed_event(EventPlaySound { sound = name}, delay)
// 	}

// 	return {}
// }

// sound_pitch :: proc(n: SoundName) -> (p: f32) {
// 	p = 1

// 	#partial switch n {
// 		case .TreeCollapse: p = 0.7
// 		case .Pickup0 ..= .Pickup1: p = 0.7
// 		case .CatLanding0: p = 1.2
// 		case .CatLanding1 ..= .CatLanding2: p = 0.7
// 		case .CatSmack0: p = random_in_range(0.9, 1.2)
// 		case .Step0 ..= .Step4: p = random_in_range(0.7, 1.2)
// 		case .CatButterdash0: p = 1
// 		case .CatWaterbucket: p = 0.8
// 		case .PancakeLanding: p = 0.8
// 	}

// 	return
// }

// sound_volume :: proc(n: SoundName) -> (v: f32) {
// 	v = 1

// 	#partial switch n {
// 		case .Pickup0 ..= .Pickup1: v = 0.4
// 		case .CatLanding0 : v = 0.4
// 		case .CatLanding1 ..= .CatLanding2: v = 0.6

// 		case .DiagIntroCloud0, .DiagIntroCloud1, .DiagIntroCloud2, .DiagIntroCloud3, .DiagIntroCloud4, .DiagIntroCloud5: v = 0.9
// 		case .RocketEngine0: v = 0.7
// 		case .RocketEngineStatic: v = 0.7
// 		case .CatButterdash0: v = 0.8
// 		case .TreeCollapse: v = 0.5
// 		case .PancakeLanding: v = 0.7
// 		case .CatWaterbucket: v = 0.6
// 	}

// 	return
// }

// MusicState :: struct {
// 	new_name: MusicName,
// 	cur_name: MusicName,
// 	cur: rl.Music,
// 	run_thread: bool,
// 	thread: ^thread.Thread,
// 	cur_volume: int,

// 	fade_music: bool,
// 	fade_volume: f32,
// }

// music_volume :: proc(s: ^MusicState) -> f32 {
// 	return f32(s.cur_volume)/sound_max_volume
// }

// music_thread :: proc(t: ^thread.Thread) {
// 	s := (^MusicState)(t.data)
// 	for s.run_thread {
// 		if s.fade_music {
// 			s.fade_volume -= 0.003

// 			if s.fade_volume <= 0 {
// 				s.fade_volume = 0
// 				s.fade_music = false
// 				s.new_name = .None
// 			} else if rl.IsMusicStreamPlaying(s.cur) {
// 				rl.SetMusicVolume(s.cur, music_volume(s)*s.fade_volume)
// 			}
// 		} else if settings.music_volume != s.cur_volume {
// 			s.cur_volume = settings.music_volume

// 			if rl.IsMusicStreamPlaying(s.cur) {
// 				rl.SetMusicVolume(s.cur, music_volume(s))
// 			}
// 		}

// 		new_name := s.new_name
// 		if new_name != s.cur_name {
// 			rl.StopMusicStream(s.cur)
// 			rl.UnloadMusicStream(s.cur)
// 			s.cur = {}

// 			if new_name != .None {
// 				s.cur = load_music(new_name)

// 				switch new_name {
// 					case .None:
// 					case .Catnap:
// 						s.cur.looping = true
// 					case .Menu:
// 						s.cur.looping = false
// 					case .Credits:
// 						s.cur.looping = false
// 				}

// 				rl.PlayMusicStream(s.cur)
// 				rl.SetMusicVolume(s.cur, music_volume(s))
// 			}

// 			s.cur_name = new_name
// 		}

// 		rl.UpdateMusicStream(s.cur)
// 		time.sleep(10*time.Millisecond)
// 	}

// 	rl.StopMusicStream(s.cur)
// 	rl.UnloadMusicStream(s.cur)
// }

// music_init :: proc(s: ^MusicState) {
// 	s.run_thread = true
// 	if s.thread = thread.create(music_thread); s.thread != nil {
// 		s.thread.init_context = context
// 		s.thread.data = rawptr(s)
// 		thread.start(s.thread)
// 	}
// }

// music_shutdown :: proc(s: ^MusicState) {
// 	s.run_thread = false
// 	thread.join(s.thread)
// 	thread.destroy(s.thread)
// }

// music_fade :: proc(s: ^MusicState) {
// 	s.fade_volume = 1
// 	s.fade_music = true
// }

// play_music :: proc(s: ^MusicState, m: MusicName) {
// 	s.fade_music = false
// 	s.new_name = m
// }
