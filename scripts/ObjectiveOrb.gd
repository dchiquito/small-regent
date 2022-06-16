extends Area2D

onready var sound = $AudioStreamPlayer2D

func _on_ObjectiveOrb_body_entered(body):
	if body.name == 'Player':
		body.collect_orb()
		sound.play()
		visible = false
		yield(get_tree().create_timer(1.1), "timeout")
		queue_free()
