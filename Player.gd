extends KinematicBody2D

const harpoon_scene = preload("res://Harpoon.tscn")
onready var sprite = $AnimatedSprite

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

func _input(ev):
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
	if state == State.IDLE:
		if Input.is_action_pressed("move_right"):
			move_and_collide(Vector2(100, 0).rotated(move_rotation) * delta)
		if Input.is_action_pressed("move_left"):
			move_and_collide(Vector2(-100, 0).rotated(move_rotation) * delta)
	if state == State.IDLE or state == State.REELING:
		velocity += Vector2(0,10)
		var collision = move_and_collide(velocity.rotated(move_rotation) * delta)
		if collision:
			velocity = Vector2(0,0)
			if state == State.REELING and collision.collider == get_parent():
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
