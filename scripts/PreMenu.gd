extends Node2D

func _input(_ev):
	if Input.is_action_just_pressed("talk"):
		HUD.fade_to_black()
		yield(get_tree().create_timer(1), "timeout")
		HUD.show_money()
		StateManager.load_next_level()
