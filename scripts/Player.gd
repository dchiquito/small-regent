extends KinematicBody2D

const harpoon_scene = preload("res://scenes/Harpoon.tscn")
onready var sprite = $AnimatedSprite
onready var camera_zoomer = $CameraZoomer
onready var camera = $Camera2D
onready var earth_orb = $Orbit/EarthOrb

onready var sound_harpoon = $FireHarpoon
onready var sound_latch = $Latch
onready var sound_thud = $Thud

const WALKING_SPEED = 100
const REELING_SPEED = 500

enum State {
	IDLE,
	SHOOTING,
	REELING,
}
var state = State.IDLE

var velocity: Vector2 = Vector2(0,0)
var harpoon = null
var has_orb: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shoot_harpoon():
	harpoon = harpoon_scene.instance()
	add_child(harpoon)
	harpoon.connect("latched", self, 'harpoon_latched', [], CONNECT_DEFERRED)
	harpoon.connect("missed", self, "harpoon_missed", [], CONNECT_DEFERRED)
	sound_harpoon.play()

func remove_harpoon():
	if harpoon != null:
		harpoon.queue_free()
		harpoon = null

func _input(_ev):
	if Input.is_action_pressed("fire_harpoon") and state == State.IDLE and not StateManager.dialog_freeze:
		state = State.SHOOTING
		sprite.animation = 'reel'
		shoot_harpoon()
	if state == State.IDLE:
		if (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and not StateManager.dialog_freeze:
			sprite.animation = 'walk'
			sprite.flip_h = Input.is_action_pressed("move_left")
		else:
			sprite.animation = 'idle'

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation = -position.angle_to(Vector2(0,-1))
	var move_rotation = rotation
	if state == State.REELING:
		rotation += 2.2
	if state == State.IDLE and not StateManager.dialog_freeze:
		if Input.is_action_pressed("move_right"):
			# warning-ignore:return_value_discarded
			move_and_collide(Vector2(WALKING_SPEED, 0).rotated(move_rotation) * delta)
		if Input.is_action_pressed("move_left"):
			# warning-ignore:return_value_discarded
			move_and_collide(Vector2(-WALKING_SPEED, 0).rotated(move_rotation) * delta)
	if state == State.IDLE or state == State.REELING:
		# TODO why track globally
		velocity = Vector2(0,REELING_SPEED)
		# warning-ignore:return_value_discarded
		move_and_slide(velocity.rotated(move_rotation))
		if get_slide_count() > 0:
			var collision = get_last_slide_collision()
			if state == State.REELING and collision.collider == get_parent():
				velocity = Vector2(0,0)
				state = State.IDLE
				sprite.animation = "idle"
				sound_thud.play()
				remove_harpoon()

func harpoon_latched(body):
	var cached_global_position = global_position
	get_parent().remove_child(self)
	body.add_child(self)
	global_position = cached_global_position
	state = State.REELING
	sprite.animation = "freefall"
	sound_harpoon.stop()
	sound_latch.play()

func harpoon_missed():
	state = State.IDLE
	sprite.animation = "idle"
	sound_harpoon.stop()
	remove_harpoon()

func zoom_in():
	# Icky patch to fix reparenting the player leaving and reentering the zoom area
	if camera.zoom.x > 0.31:
		camera_zoomer.play("camera_zoom_in")

func unzoom_in():
	camera_zoomer.play_backwards("camera_zoom_in")

func zoom_out():
	# Icky patch to fix reparenting the player leaving and reentering the zoom area
	camera_zoomer.stop()
	if camera.zoom.x < 0.99:
		camera_zoomer.play("camera_zoom_out")

func unzoom_out():
	camera_zoomer.play_backwards("camera_zoom_out")

func collect_orb():
	has_orb = true
	earth_orb.visible = true

func dispense_orb():
	has_orb = false
	earth_orb.visible = false
