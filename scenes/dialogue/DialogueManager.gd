class_name DialogueManager
extends Node

const DIALOGUE_SCENE := preload("res://scenes/dialogue/Dialogue.tscn")
onready var opacity_tween := $OpacityTween as Tween

signal message_requested()
signal message_completed()
signal finished()
signal dialogue_paused()
signal dialogue_unpaused()

var _messages := []
var _active_dialogue_offset := 0
var _is_active := false
var cur_dialogue_instance: Dialogue

func _ready():
	yield(get_tree().get_root(), "ready")

func show_messages(msg_list: Array, pos: Vector2) -> void:
	if _is_active:
		return
	_is_active = true
	StateManager.dialog_freeze = true
	
	_messages = msg_list
	_active_dialogue_offset = 0
	var dialogue = DIALOGUE_SCENE.instance()
	dialogue.connect("message_completed", self, "_on_message_completed")
	dialogue.connect("dialogue_paused", self, "_on_dialogue_paused")
	dialogue.connect("dialogue_unpaused", self, "_on_dialogue_unpaused")
#	get_tree().get_root().call_deferred("add_child", dialogue)
	get_tree().get_root().add_child(dialogue)
	dialogue.rect_position = pos
	cur_dialogue_instance = dialogue
	
#	Glob.emit_signal("dialogue_started")
	_show_current()

func _process(_delta):
	if Input.is_action_just_released("talk"):
		if _is_active and !_msg_requested and cur_dialogue_instance.message_is_fully_visible():
			if _active_dialogue_offset < _messages.size() - 1:
				_active_dialogue_offset += 1
#				yield(get_tree().create_timer(1), "timeout")
				_show_current()
			else:
				_hide()


var _msg_requested = false

func _show_current() -> void:

	_msg_requested = true
	if !_is_active:
			return
	emit_signal("message_requested")
	var msg := _messages[_active_dialogue_offset] as String
	cur_dialogue_instance.update_message(msg)

func _hide() -> void:
	cur_dialogue_instance.disconnect("message_completed", self, "_on_message_completed")
	cur_dialogue_instance.queue_free()
	cur_dialogue_instance = null
	_is_active = false
	StateManager.dialog_freeze = false
	emit_signal("finished")

func cancel_dialogue():
	_hide()

func _on_message_completed() -> void:
	_msg_requested = false
	emit_signal("message_completed")

func _on_dialogue_paused():
	emit_signal("dialogue_paused")

func _on_dialogue_unpaused():
	emit_signal("dialogue_unpaused")
