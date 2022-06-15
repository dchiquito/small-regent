extends RigidBody2D

onready var earth_orb = $OrbitCenter/Orbit/EarthOrb
onready var dialogue_manager = $DialogueManager
onready var sprite = $AnimatedSprite

enum State {
	IDLE,
	TALKING,
	PRELEAVE_TALKING,
	LEAVING,	
}
var state = State.IDLE

var player = null
var near_player = false

func _ready():
	add_to_group('walkables')

func _input(_ev):
	if near_player and player != null and Input.is_action_just_pressed("talk") and not StateManager.dialog_freeze:
		if not player.has_orb:
			state = State.TALKING
			talk(['fetch me dirt'])
		else:
			player.dispense_orb()
			earth_orb.visible = true
			state = State.PRELEAVE_TALKING
			talk(['mmm, earthy', 'Thank you, small regent\n  :)'])

func _physics_process(delta):
	if state == State.LEAVING:
		position += Vector2(100, 0) * delta

func _on_PlayerDetector_body_entered(body):
	if body.name == 'Player':
		player = body
		near_player = true
		body.zoom_in()

func _on_PlayerDetector_body_exited(body):
	if body.name == 'Player':
		near_player = false
		body.unzoom_in()

func talk(messages):
	sprite.animation = "talking"
	dialogue_manager.show_messages(messages, Vector2(-50,-100))

func _on_DialogueManager_finished():
	sprite.animation = "idle"
	if state == State.TALKING:
		state = State.IDLE
	elif state == State.PRELEAVE_TALKING:
		state = State.LEAVING
		yield(get_tree().create_timer(3), "timeout")
		get_tree().change_scene("res://scenes/Level2.tscn")

