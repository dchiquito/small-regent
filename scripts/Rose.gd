extends Area2D

var player = null
var near_player = false

func _input(_ev):
	if near_player and player != null and player.has_orb and Input.is_action_just_pressed("give"):
		print('gibit')
		player.dispense_orb()

func _on_Rose_body_entered(body):
	if body.name == 'Player':
		player = body
		near_player = true
		body.zoom_in()


func _on_Rose_body_exited(body):
	if body.name == 'Player':
		near_player = false
		body.unzoom_in()
