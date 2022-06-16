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

func select_current_orb(earth, water, light):
	match current_level:
		1:
			return earth
		2:
			return water
		3:
			return light

func rose_talk_message():
	match current_level:
		1:
			return ["hello Small Regent", "we live on a very dusty asteroid,{p=0.2} don't we?", "if only i had some earth,{p=0.5} i would be happy"]
		2:
			return ["hello again Small Regent", "this asteroid is too dry for me", "if only i had some water,{p=0.5} i would be happy"]
		3:
			return ["hello Small Regent", "it is to dark to see where i am going", "if only i had some light,{p=0.5} i would be happy"]

func rose_leave_message():
	match current_level:
		1:
			return ["this earth feels perfect on my roots", "thank you Small Regent\n{p=1.0} :)"]
		2:
			return ["this water is delicious", "thank you Small Regent\n{p=1.0}:)"]
		3:
			return ["this light shines on everything", "thank you Small Regent\n{p=1.0}:)"]

func merchant_talk_message():
	match current_level:
		1:
			return ["Greetings and Salutations, Small Regent!"]
		2:
			return ["bbb"]
		3:
			return ["ccc"]

