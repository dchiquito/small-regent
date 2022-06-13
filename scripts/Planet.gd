extends RigidBody2D

export var orbit: NodePath = ''
export var orbital_period: int = 10
export var starting_point: float = 0
export var walkable: bool = true

var progress = starting_point

func _ready():
	if orbit:
		var angle = get_node(orbit).position.angle_to(Vector2(1,0))
		rotate(angle)
	if walkable:
		add_to_group('walkables')

func _process(delta):
	if orbit:
		var curve = get_node(orbit).get_child(0).curve
		progress = fmod(progress + ((delta*4)/orbital_period), 4)
		position = curve.interpolatef(progress)
