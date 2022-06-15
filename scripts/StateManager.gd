extends Node

# This is the dumping ground for all global state, except money, which lives in the HUD

var dialog_freeze: bool = false
var cutscene_playing: bool = false
var current_level: int = 1

func get_level_scene(level):
	match level:
		1:
			return "res://scenes/Level1.tscn"
		2:
			return "res://scenes/Level2.tscn"
		3:
			return "res://scenes/Level3.tscn"

func load_next_level():
	current_level += 1
	get_tree().change_scene(get_level_scene(current_level))
	cutscene_playing = false

func rose_talk_message():
	match current_level:
		1:
			return ["a"]
		2:
			return ["b"]
		3:
			return ["c"]

func rose_leave_message():
	match current_level:
		1:
			return ["aa"]
		2:
			return ["bb"]
		3:
			return ["cc"]

func merchant_talk_message():
	match current_level:
		1:
			return ["aaa"]
		2:
			return ["bbb"]
		3:
			return ["ccc"]

