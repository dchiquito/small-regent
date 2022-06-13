extends RigidBody2D

#var EllipticalPath = Path2D.new()
#var MyPath = preload("res://EllipticalPath.tscn")

var progress = 0

func _ready():
	var angle = get_parent().get_parent().position.angle_to(Vector2(1,0))
	rotate(angle)
	add_to_group('walkables')

func _process(delta):
	var curve = get_parent().curve
	progress = fmod(progress + delta, 4)
	position = curve.interpolatef(progress)
