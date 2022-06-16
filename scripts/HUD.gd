extends CanvasLayer

onready var label = $Money
onready var fader = $Fader

var money = 0

func increment_money():
	money += 1
	label.text = str(money)

func fade_to_black():
	fader.play('fade_to_black')

func fade_in():
	fader.play_backwards("fade_to_black")

func fin():
	fader.play("fin")
