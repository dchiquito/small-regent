extends Area2D


func _on_Rose_body_entered(body):
	if body.name == 'Player':
		body.zoom_in()


func _on_Rose_body_exited(body):
	if body.name == 'Player':
		body.unzoom_in()
