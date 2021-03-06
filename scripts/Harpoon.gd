extends RigidBody2D

signal latched
signal missed

onready var cord = $Cord

const VELOCITY = 600
const MAX_DISTANCE = 300

enum State {
	FLYING,
	LATCHED,
}
var state = State.FLYING

var player = null

func _ready():
	rotation = Vector2(1,0).angle_to(get_global_mouse_position() - global_position)
	# correct for the rotation of the player
	rotation -= get_parent().rotation

func _physics_process(delta):
	if state == State.FLYING:
		position += (Vector2(VELOCITY,0).rotated(rotation) * delta)
		if player == null:
			player = get_parent()
		cord.points[0] = -position.rotated(-rotation)
		if position.length() > MAX_DISTANCE:
			emit_signal('missed')
	if state == State.LATCHED:
		cord.points[0] = (get_node('../Player').position - position).rotated(-rotation)
	# Dumb patch for cord flickering during reparenting. Make sure everything is visible after cord is corrected.
	visible = true

func _on_Area2D_body_entered(body):
	if state == State.FLYING and body.is_in_group('walkables'):
		call_deferred('latch_on', body)

func latch_on(body):
	# Dumb patch for cord flickering. It is revisibled after every _physics_process.
	visible = false
	state = State.LATCHED
	var cached_global_position = global_position
	get_parent().remove_child(self)
#	body.call_deferred("add_child", self)
	body.add_child(self)
	global_position = cached_global_position
	layers = 0
	emit_signal('latched', body)
	
