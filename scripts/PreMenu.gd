extends Node2D

func _input(_ev):
	if Input.is_action_just_pressed("talk"):
		HUD.fade_to_black()
		yield(get_tree().create_timer(1), "timeout")
		HUD.reset_money()
		HUD.show_money()
		# Make sure the player regains agency
		StateManager.dialog_freeze = false
		StateManager.cutscene_playing = false
		StateManager.load_next_level()
