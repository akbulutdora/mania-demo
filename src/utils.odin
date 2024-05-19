package game

import "core:mem"
import "core:io"
import "core:unicode"
import "core:strings"

to_sentence :: proc(s: string, capitalized: bool = false, allocator := context.temp_allocator) -> (res: string, err: mem.Allocator_Error) #optional_allocator_error {
	s := s
	s = strings.trim_space(s)
	b: strings.Builder
	strings.builder_init(&b, 0, len(s), allocator) or_return
	w := strings.to_writer(&b)

	prev, curr: rune

	for next in s {
		if prev == 0 && curr != 0 {
			io.write_rune(w, unicode.to_upper(curr))
		} else if strings.is_delimiter(curr) {
			if !strings.is_delimiter(prev) {
				io.write_rune(w, ' ')
			}
		} else if unicode.is_upper(curr) {
			if unicode.is_lower(prev) || (unicode.is_upper(prev) && unicode.is_lower(next)) {
				io.write_rune(w, ' ')
			}

			io.write_rune(w, capitalized ? unicode.to_upper(curr) : unicode.to_lower(curr))
		} else if curr != 0 {
			io.write_rune(w, unicode.to_lower(curr))
		}

		prev = curr
		curr = next
	}

	if len(s) > 0 {
		if unicode.is_upper(curr) && unicode.is_lower(prev) && prev != 0 {
			io.write_rune(w, ' ')
		}
		io.write_rune(w, len(s) == 1 ? unicode.to_upper(curr) : unicode.to_lower(curr))
	}

	return strings.to_string(b), nil
}
