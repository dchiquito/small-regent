class_name DPause
extends Reference

const FLOAT_PATTERN := "\\d+\\.\\d+"
var pause_pos:int
var duration:float

func _init(pos:int, tag_string:String) -> void:

	var duration_regex := RegEx.new()
	var _err = duration_regex.compile(FLOAT_PATTERN)
	duration = float(duration_regex.search(tag_string).get_string())
	pause_pos = int(clamp(pos - 1, 0 , abs(pos)))
