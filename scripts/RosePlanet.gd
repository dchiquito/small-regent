extends RigidBody2D

onready var earth_orb = $AnimatedSprite/OrbitCenter/Orbit/EarthOrb
onready var water_orb = $AnimatedSprite/OrbitCenter/Orbit/WaterOrb
onready var light_orb = $AnimatedSprite/OrbitCenter/Orbit/LightOrb
onready var dialogue_manager = $DialogueManager
onready var dialog_spot = $DialogSpot
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
	if StateManager.current_level >= 2:
		earth_orb.visible = true
	if StateManager.current_level >= 3:
		water_orb.visible = true
	HUD.fade_in()

func _input(_ev):
	if near_player and player != null and Input.is_action_just_pressed("talk") and (not StateManager.dialog_freeze) and (not StateManager.cutscene_playing):
		if not player.has_orb:
			state = State.TALKING
			talk(StateManager.rose_talk_message())
		else:
			player.dispense_orb()
			StateManager.select_current_orb(earth_orb, water_orb, light_orb).visible = true
			state = State.PRELEAVE_TALKING
			talk(StateManager.rose_leave_message())

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
	dialogue_manager.show_messages(messages, dialog_spot.global_position)

func _on_DialogueManager_finished():
	sprite.animation = "idle"
	if state == State.TALKING:
		state = State.IDLE
	elif state == State.PRELEAVE_TALKING:
		StateManager.cutscene_playing = true
		state = State.LEAVING
		yield(get_tree().create_timer(2), "timeout")
		HUD.fade_to_black()
		yield(get_tree().create_timer(1), "timeout")
		StateManager.load_next_level()

