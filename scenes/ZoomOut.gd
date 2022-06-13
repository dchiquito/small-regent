extends Area2D

func _on_ZoomOut_body_entered(body):
	if body.name == 'Player':
		body.zoom_out()


func _on_ZoomOut_body_exited(body):
	if body.name == 'Player':
		body.unzoom_out()
