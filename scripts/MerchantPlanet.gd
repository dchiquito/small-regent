extends RigidBody2D

onready var earth_orb = $OrbitCenter/Orbit/EarthOrb
onready var sprite = $Merchant
onready var dialogue_manager = $DialogueManager
onready var dialog_spot = $DialogSpot

var near_player = false
var leaving = false

func _ready():
	add_to_group('walkables')

func _input(_ev):
	if near_player and Input.is_action_just_pressed("talk") and not StateManager.dialog_freeze:
		talk(['teehee'])

func talk(messages):
	sprite.animation = "talking"
	dialogue_manager.show_messages(messages, dialog_spot.global_position)

func _on_DialogueManager_finished():
	pass # Replace with function body.

func _on_PlayerDetector_body_entered(body):
	if body.name == 'Player':
		near_player = true
		body.zoom_in()

func _on_PlayerDetector_body_exited(body):
	if body.name == 'Player':
		near_player = false
		body.unzoom_in()
