extends CanvasLayer

onready var label = $Panel/Label

var money = 0

func increment_money():
	money += 1
	label.text = str(money) + "$"
