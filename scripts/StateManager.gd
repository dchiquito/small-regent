extends Node

# This is the dumping ground for all global state, except money, which lives in the HUD

var dialog_freeze: bool = false
var cutscene_playing: bool = false
var current_level: int = 0

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

func load_post_menu():
	current_level = 0
	get_tree().change_scene("res://scenes/PostMenu.tscn")

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
			return ["hello Small Regent", "it is too dark to see where i am going", "if only i had some light,{p=0.5} i would be happy"]

func rose_leave_message():
	match current_level:
		1:
			return ["this earth feels perfect on my roots", "thank you Small Regent\n{p=1.0} :)"]
		2:
			return ["this water is delicious", "thank you Small Regent\n{p=1.0} :)"]
		3:
			return ["this light shines on everything", "{p=1.0} ...", "its time for me to go,{p=0.3} Small Regent", "I need to take care of myself now"]

func merchant_talk_message():
	match current_level:
		1:
			return [
				"Greetings and Salutations, small regent!",
				"You're looking for some...{p=1.0} \ndirt?",
				"Well do I have just the product for you!",
				"These SpeedBoots will have you zipping all over!",
				"Why, I just saw some dirt off to the left!",
				"Just imagine how fast you could find it!",
				"With these boots!",
				"Yours for the low low price of...",
				"10 spacebucks!",
				"...oh, you don't have that much?",
				"The economy is in shambles, huh?"
			]
		2:
			return [
				"small regent! Hello!",
				"You're looking for some water?",
				"Why, there's some on the other side of that planet there!",
				"Good luck getting to it, though!",
				"...without this JetPak!",
				"Yours for the low low price of...",
				"20 spacebucks!",
				"...oh, still not enough?",
				"Well I'm sure you'll figure something out."
			]
		3:
			return [
				"Well, if it isn't my favorite small regent!",
				"Looking for a light? Well look no further!",
				"I'm selling this entire glowing planet!",
				"Bathe every day in this luxurious golden glow!",
				"Trust me, real estate is the best investment!",
				"Yours for the low low price of...",
				"20 spacebucks!",
				"...hmm, guess you're still short.",
				"Not much of a regent, are you?",
			]

