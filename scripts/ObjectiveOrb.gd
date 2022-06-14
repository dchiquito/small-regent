extends Area2D

export var orbit: NodePath = ''
export var orbital_period: int = 10

var progress: float = 0

func _ready():
	if orbit:
		var angle = get_node(orbit).position.angle_to(Vector2(1,0))
		rotate(angle)

func _process(delta):
	print(orbit,'!',orbital_period)
	if orbit:
		var curve = get_node(orbit).get_child(0).curve
		progress = fmod(progress + ((delta*4)/orbital_period), 4)
		position = curve.interpolatef(progress)
		print(position)

func _on_ObjectiveOrb_body_entered(body):
	if orbit == '' and body.name == 'Player':
		body.collect_orb()
		# TODO play sound
		queue_free()
