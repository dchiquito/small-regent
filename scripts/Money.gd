extends Area2D

onready var sprite = $AnimatedSprite
onready var explosion = $Explosion
onready var sound = $Ding

func _on_Money_body_entered(body):
	if body.name == 'Player' and sprite.visible:
		HUD.increment_money()
		sprite.visible = false
		explosion.emitting = true
		sound.play()
		yield(get_tree().create_timer(0.5), "timeout")
		queue_free()
