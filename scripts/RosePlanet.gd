extends RigidBody2D

onready var earth_orb = $OrbitCenter/Orbit/EarthOrb

var player = null
var near_player = false

func _ready():
	add_to_group('walkables')

func _input(_ev):
	if near_player and player != null and player.has_orb and Input.is_action_just_pressed("give"):
		print('gibit')
		player.dispense_orb()
		earth_orb.visible = true
		get_tree().change_scene("res://scenes/Level2.tscn")

func _on_PlayerDetector_body_entered(body):
	if body.name == 'Player':
		player = body
		near_player = true
		body.zoom_in()


func _on_PlayerDetector_body_exited(body):
	if body.name == 'Player':
		near_player = false
		body.unzoom_in()
