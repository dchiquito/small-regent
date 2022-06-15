extends RichTextLabel

onready var animation = $AnimationPlayer

export var event: String
export var visible_after: String = ''

enum State {
	WAITING,
	VISIBLE,
	EXPIRED,
}
var state = State.WAITING

# Called when the node enters the scene tree for the first time.
func _ready():
	percent_visible = 0
	if visible_after == '':
		# No triggers, this should be visible by default
		state = State.VISIBLE
		animation.play("fade_in")

func _input(_ev):
	if state == State.VISIBLE and Input.is_action_just_pressed(event):
		# Player has succesfully followed the tutorial, no need to stick around
		state = State.EXPIRED
		animation.play_backwards("fade_in")
	if state == State.WAITING and Input.is_action_just_pressed(visible_after):
		# Necessary conditions have been met, appear
		state = State.VISIBLE
		animation.play("fade_in")
