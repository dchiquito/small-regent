extends Area2D

func _on_ObjectiveOrb_body_entered(body):
	if body.name == 'Player':
		body.collect_orb()
		# TODO play sound
		queue_free()
