extends KinematicBody2D

const harpoon_scene = preload("res://scenes/Harpoon.tscn")
onready var sprite = $AnimatedSprite
onready var camera_zoomer = $CameraZoomer

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
#onready var latched_to: Node2D = get_node("../Sun/Node2D2/EllipticalPath/Orbiter/Node2D/EllipticalPath/Orbiter")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shoot_harpoon():
	harpoon = harpoon_scene.instance()
	add_child(harpoon)
	harpoon.connect("latched", self, 'harpoon_latched')

func remove_harpoon():
	harpoon.queue_free()
	harpoon = null

func _input(_ev):
	if Input.is_action_pressed("fire_harpoon") and state == State.IDLE:
		state = State.SHOOTING
		sprite.animation = 'reel'
		shoot_harpoon()
	if Input.is_action_just_pressed("retract_harpoon") and state == State.SHOOTING:
		state = State.IDLE
		sprite.animation = 'idle'
		remove_harpoon()
	if state == State.IDLE:
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
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
	if state == State.IDLE:
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
				remove_harpoon()

func harpoon_latched(body):
	call_deferred('deferred_harpoon_latched', body)
# A deferred function call is necessary to do reparenting
func deferred_harpoon_latched(body):
	var cached_global_position = global_position
	get_parent().remove_child(self)
	body.add_child(self)
	global_position = cached_global_position
	state = State.REELING
	sprite.animation = "freefall"


func _on_ZoomDetector_body_entered(body):
	if body.is_in_group('zoomers'):
		camera_zoomer.play("camera_zoom")

func _on_ZoomDetector_body_exited(body):
	if body.is_in_group('zoomers'):
		camera_zoomer.play_backwards("camera_zoom")
