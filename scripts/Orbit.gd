extends Node2D

onready var path = $EllipticalPath

export var eccentricity: float
export var reversed: bool = false

func _ready():
	var mag = position.length()
	
#	var a = ((mag*mag) + (b*b)) / (2 * mag)
#	var c = sqrt((a*a) - (b*b))

	var a = mag / (eccentricity + 1)
	var c = eccentricity * a
	var b = sqrt((a*a) - (c*c))
	if reversed:
		b = -b

	var curve = Curve2D.new()
	curve.add_point(Vector2(0, 0), Vector2(0, -b/2), Vector2(0, -b/2))
	curve.add_point(Vector2(-a, -b), Vector2(a/2, 0), Vector2(-a/2, 0))
	curve.add_point(Vector2(-2*a, 0), Vector2(0, -b/2), Vector2(0, b/2))
	curve.add_point(Vector2(-a, b), Vector2(-a/2, 0), Vector2(a/2, 0))
	curve.add_point(Vector2(0, 0), Vector2(0, b/2), Vector2(0, -b/2))
	var angle = -position.angle_to(Vector2(1,0))
	rotate(angle)
	path.curve = curve
	
	
