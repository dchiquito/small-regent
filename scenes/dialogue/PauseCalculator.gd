class_name PauseCalculator
extends Node

signal pause_requested(duration)


const PAUSE_PATTERN := "({p=\\d([.]\\d+)?[}])"
var p_regex := RegEx.new()
var pauses := []

func _ready():
	var _err = p_regex.compile(PAUSE_PATTERN)

func extract_pauses_from_string(src_string:String) -> String:
	pauses = []
	_find_pauses(src_string)
	return _extract_tags(src_string)
	
func _find_pauses(src_string: String) -> void:
	var found_pauses := p_regex.search_all(src_string)
	for result in found_pauses:
		var tag := result.get_string() as String
		var tag_pos := _adjust_position(
			result.get_start(), 
			src_string
		)

		var pause = DPause.new(tag_pos, tag)
		pauses.append(pause)

func _extract_tags(src_string: String) -> String:
	var custom_regex = RegEx.new()
	custom_regex.compile("({(.*?)})")
	return custom_regex.sub(src_string, "", true)

func check_at_position(pos):
	for p in pauses:
		if p.pause_pos == pos:
			emit_signal("pause_requested", p.duration)

func _adjust_position(pos: int, src_string:String) -> int:
	var tag := RegEx.new()
	var _err = tag.compile("({(.*?)})")
	
	var new_pos := pos
	var left_of_pos := src_string.left(pos)
	var all_prev_tags := tag.search_all(left_of_pos)
	
	for result in all_prev_tags:
		new_pos -= result.get_string().length()
	
	return new_pos
