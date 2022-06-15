extends Node2D

export var orbit: bool = false
export var orbital_period: int = 10
export var starting_point: float = 0

var progress: float = 0

func _ready():
	if orbit:
		var angle = get_parent().position.angle_to(Vector2(1,0))
		rotate(angle)
		progress = starting_point * 4

func _process(delta):
	if orbit:
		var curve = get_parent().get_child(0).curve
		progress = fmod(progress + ((delta*4)/orbital_period), 4)
		position = curve.interpolatef(progress)
