extends Area2D

func _on_Money_body_entered(body):
	if body.name == 'Player':
		HUD.increment_money()
		# TODO play sound
		queue_free()
