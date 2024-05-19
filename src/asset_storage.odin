package game

import rl "vendor:raylib"
// import "core:strings"
import "core:os"
// import "core:fmt"
import "core:slice"

// _ :: fmt

// TextureAsset :: struct {
// 	handle: TextureHandle,
// 	id: UID,
// 	tex: rl.Texture,
// 	path: cstring,
// 	path_hash: Hash,
// }

// TextureHandle :: Handle
// TextureHandleNone :: TextureHandle(HandleNone)

// AssetStorage :: struct {
// 	textures: HandleArray(TextureAsset, TextureHandle),
// 	texture_lookup: map[Hash]TextureHandle,

// 	sounds: []rl.Sound,
// }

// g_as: ^AssetStorage

// asset_storage_init :: proc(asset_storage: ^AssetStorage) {
// 	g_as = asset_storage
// 	g_as^ = {}

// 	when EmbedAssets {
// 		for t, k in all_textures {
// 			if k == .None {
// 				continue
// 			}

// 			load_texture_from_memory(t.data, t.path, t.path_hash)
// 		}
// 	} else {
// 		for t, k in all_textures {
// 			if k == .None {
// 				continue
// 			}
// 			load_texture(t.path, t.path_hash)
// 		}
// 	}

// 	g_as.sounds = make([]rl.Sound, len(SoundName))
// 	for s in SoundName {
// 		if s == .None {
// 			continue
// 		}

// 		g_as.sounds[s] = load_sound(s)
// 	}
// }

// load_texture_from_memory :: proc(data: []u8, path: string, path_hash: Hash) {
// 	img := rl.LoadImageFromMemory(".png", &data[0], i32(len(data)))
// 	tex := rl.LoadTextureFromImage(img)
// 	rl.UnloadImage(img)
// 	rl.SetTextureFilter(tex, .BILINEAR)
// 	rl.SetTextureWrap(tex, .CLAMP)

// 	ta := TextureAsset { tex = tex, path = strings.clone_to_cstring(path), path_hash = path_hash }
// 	g_as.texture_lookup[path_hash] = ha_add(&g_as.textures, ta)
// }

// asset_storage_shutdown :: proc() {
// 	tex_iter := ha_make_iter(g_as.textures)
// 	for tex in ha_iter(&tex_iter) {
// 		rl.UnloadTexture(tex.tex)
// 		delete(tex.path)
// 	}

// 	ha_delete(g_as.textures)
// 	delete(g_as.texture_lookup)

// 	for s in g_as.sounds {
// 		rl.UnloadSound(s)
// 	}

// 	delete(g_as.sounds)
// 	g_as^ = {}
// }

// asset_storage_reload :: proc() {
// 	for s in g_as.sounds {
// 		rl.UnloadSound(s)
// 	}

// 	delete(g_as.sounds)
// 	g_as.sounds = make([]rl.Sound, len(SoundName))
// 	for s in SoundName {
// 		g_as.sounds[s] = load_sound(s)
// 	}
// }

// reload_texture :: proc(h: TextureHandle) -> bool {
// 	tex, ok := ha_get(g_as.textures, h)

// 	if !ok {
// 		return false
// 	}

// 	rl.UnloadTexture(tex.tex)
// 	tex.tex = rl.LoadTexture(tex.path)
// 	rl.SetTextureFilter(tex.tex, .BILINEAR)
// 	rl.SetTextureWrap(tex.tex, .CLAMP)
// 	return true
// }

// unload_texture :: proc(h: TextureHandle) {
// 	tex, ok := ha_get(g_as.textures, h)

// 	if !ok {
// 		return
// 	}

// 	if tex.path_hash != 0 {
// 		delete_key(&g_as.texture_lookup, tex.path_hash)
// 	}

// 	ha_remove(&g_as.textures, h)
// }

// load_texture :: proc(path: string, path_hash: Hash = 0) -> TextureHandle {
// 	path_hash := path_hash

// 	if path_hash == 0 {
// 		path_hash = hash(path)
// 	}

// 	if tex_handle, ok := g_as.texture_lookup[path_hash]; ok {
// 		if reload_texture(tex_handle) {
// 			return tex_handle
// 		}
// 	}

// 	tex := rl.LoadTexture(temp_cstring(path))
// 	rl.SetTextureFilter(tex, .BILINEAR)
// 	rl.SetTextureWrap(tex, .CLAMP)

// 	ta := TextureAsset { tex = tex, path = strings.clone_to_cstring(path), path_hash = path_hash }
// 	tah := ha_add(&g_as.textures, ta)
// 	g_as.texture_lookup[path_hash] = tah
// 	return tah
// }

// reload_all :: proc() {
// 	tex_iter := ha_make_iter(g_as.textures)
// 	for tex in ha_iter_ptr(&tex_iter) {
// 		rl.UnloadTexture(tex.tex)
// 		tex.tex = rl.LoadTexture(tex.path)
// 		rl.SetTextureFilter(tex.tex, .BILINEAR)
// 		rl.SetTextureWrap(tex.tex, .CLAMP)
// 	}

// 	for s in g_as.sounds {
// 		rl.UnloadSound(s)
// 	}

// 	for s in SoundName {
// 		g_as.sounds[s] = load_sound(s)
// 	}
// }

// get_texture :: proc(handle: TextureHandle) -> (tex: rl.Texture, ok: bool) #optional_ok  {
// 	ta := ha_get(g_as.textures, handle) or_return
// 	tex = ta.tex
// 	ok = true
// 	return
// }

// get_texture_by_name :: proc(name: TextureName) -> (rl.Texture, bool) #optional_ok {
// 	return get_texture(get_texture_handle(name))
// }

// texture_handle_from_hash :: proc(name: Hash) -> TextureHandle {
// 	if texture_handle, ok := g_as.texture_lookup[name]; ok {
// 		return texture_handle
// 	}

// 	return {}
// }

// get_texture_handle :: proc(name: TextureName) -> TextureHandle {
// 	return texture_handle_from_hash(all_textures[name].path_hash)
// }

// texture_hash_from_handle :: proc(handle: TextureHandle) -> Hash {
// 	if ta, ok := ha_get(g_as.textures, handle); ok {
// 		return ta.path_hash
// 	}

// 	return 0
// }

// get_sound :: proc(name: SoundName) -> rl.Sound {
// 	return g_as.sounds[name]
// }

// level_filename_from_level_name :: proc(l: LevelName) -> string {
// 	return all_levels[l].path
// }

// load_level_data :: proc(l: LevelName) -> ([]u8, bool) {
// 	when EmbedAssets {
// 		return all_levels[l].data, true
// 	} else {
// 		return os.read_entire_file(all_levels[l].path, context.temp_allocator)
// 	}
// }

// load_entity_types_data :: proc() -> ([]u8, bool) {
// 	when EmbedAssets {
// 		return entity_types_asset.data, true
// 	} else {
// 		return os.read_entire_file(entity_types_asset.path, context.temp_allocator)
// 	}
// }

// load_dialogues_data :: proc() -> ([]u8, bool) {
// 	when EmbedAssets {
// 		return dialogues_asset.data, true
// 	} else {
// 		return os.read_entire_file(dialogues_asset.path, context.temp_allocator)
// 	}
// }

// load_image :: proc(name: TextureName) -> rl.Image {
// 	t := all_textures[name]

// 	when EmbedAssets {
// 		return rl.LoadImageFromMemory(".png", &t.data[0], i32(len(t.data)))
// 	} else {
// 		return rl.LoadImage(temp_cstring(t.path))
// 	}
// }

load_ttf_from_memory :: proc(file_data: []byte, font_size: int) -> rl.Font {
	font := rl.Font {
		baseSize = i32(font_size),
		glyphCount = 95,
	}

	font.glyphs = rl.LoadFontData(&file_data[0], i32(len(file_data)), font.baseSize, {}, font.glyphCount, .DEFAULT)

	if font.glyphs != nil {
		font.glyphPadding = 4

		atlas := rl.GenImageFontAtlas(font.glyphs, &font.recs, font.glyphCount, font.baseSize, font.glyphPadding, 0)
		atlas_u8 := slice.from_ptr((^u8)(atlas.data), int(atlas.width*atlas.height*2))

		for i in 0..<atlas.width*atlas.height {
			a := atlas_u8[i*2 + 1]
			v := atlas_u8[i*2]
			atlas_u8[i*2] = u8(f32(v)*(f32(a)/255))
		}

		font.texture = rl.LoadTextureFromImage(atlas)
		rl.SetTextureFilter(font.texture, .BILINEAR)

		// Update glyphs[i].image to use alpha, required to be used on ImageDrawText()
		for i in 0..<font.glyphCount {
			rl.UnloadImage(font.glyphs[i].image)
			font.glyphs[i].image = rl.ImageFromImage(atlas, font.recs[i])
		}
		//TRACELOG(LOG_INFO, "FONT: Data loaded successfully (%i pixel size | %i glyphs)", font.baseSize, font.glyphCount);

		rl.UnloadImage(atlas)
	} else {
		font = rl.GetFontDefault()
	}

	return font
}

load_font :: proc(name: FontName, font_size: int) -> rl.Font {
	fa := all_fonts[name]
	f: rl.Font

	when EmbedAssets {
		f = load_ttf_from_memory(fa.data, font_size)
	} else {
		if font_data, ok := os.read_entire_file(fa.path, context.temp_allocator); ok {
			f = load_ttf_from_memory(font_data, font_size)
		} else {
			f = rl.GetFontDefault()
		}
	}

	return f
}

// load_shader :: proc(name: ShaderName) -> rl.Shader {
// 	s := all_shaders[name]

// 	when EmbedAssets {
// 		d := strings.string_from_ptr(&s.data[0], len(s.data))
// 		return rl.LoadShaderFromMemory(nil, temp_cstring(d))
// 	} else {
// 		return rl.LoadShader(nil, temp_cstring(s.path))
// 	}
// }

// load_sound :: proc(name: SoundName) -> rl.Sound {
// 	s := all_sounds[name]

// 	when EmbedAssets {
// 		w := rl.LoadWaveFromMemory(".wav", &s.data[0], i32(len(s.data)))
// 		snd := rl.LoadSoundFromWave(w)
// 		rl.UnloadWave(w)
// 		return snd
// 	} else {
// 		return rl.LoadSound(temp_cstring(s.path))
// 	}
// }

// load_music :: proc(name: MusicName) -> rl.Music {
// 	s := all_music[name]

// 	when EmbedAssets {
// 		return rl.LoadMusicStreamFromMemory(".ogg", &s.data[0], i32(len(s.data)))
// 	} else {
// 		return rl.LoadMusicStream(temp_cstring(s.path))
// 	}
// }
