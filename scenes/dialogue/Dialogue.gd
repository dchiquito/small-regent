class_name Dialogue
extends Control

onready var content := $Content as RichTextLabel
onready var type_timer := $TypeTimer as Timer
onready var pause_timer := $PauseTimer as Timer
onready var voice_player := $DialogueVoicePlayer as AudioStreamPlayer
onready var _calc := $PauseCalculator as PauseCalculator

var _playing_voice := false
signal message_completed()
signal dialogue_paused()
signal dialogue_unpaused()

#func _ready():
#	assert(_calc)

#func _ready():
#	yield(get_tree().create_timer(1.0), "timeout")
#	update_message("hello there.{p=0.5} I am Carla {p=0.5}...")

func update_message(msg: String) -> void:
	content.bbcode_text = _calc.extract_pauses_from_string(msg)
	visible = true
#	$ItemScreens/MuffinScreen.visible = false
#	$ItemScreens/EnergyDrinkScreen.visible = false
	content.visible_characters = 0
	type_timer.start()
	_playing_voice = true
	voice_player.play(0)

func give_choice():
	visible = false
#	$ItemScreens/Choice.visible = true
##	Glob.receive_muffin()
##	emit_signal("message_completed")

func message_is_fully_visible() -> bool:
	return content.visible_characters >= content.bbcode_text.length()

func _on_TypeTimer_timeout() -> void:
	_calc.check_at_position(content.visible_characters)
	if content.visible_characters < content.text.length():
		content.visible_characters += 1
	else:
		type_timer.stop()
		emit_signal("message_completed")
		_playing_voice = false


func _on_DialogueVoicePlayer_finished():
	if _playing_voice:
		voice_player.play(0)
#	pass

func _on_PauseCalculator_pause_requested(duration):
	_playing_voice = false
	type_timer.stop()
	pause_timer.wait_time = duration
	pause_timer.start()
	emit_signal("dialogue_paused")

func _on_PauseTimer_timeout():
	_playing_voice = true
	voice_player.play(0)
	type_timer.start()
	pause_timer.stop()
	emit_signal("dialogue_unpaused")


func _on_Choice_choice_made(choice_is_muffin):
	if choice_is_muffin:
		$ItemScreens/MuffinScreen.visible = true
	else:
		$ItemScreens/EnergyDrinkScreen.visible = true
	content.visible_characters = content.bbcode_text.length()
	emit_signal("message_completed")
