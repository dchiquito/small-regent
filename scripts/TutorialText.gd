extends RichTextLabel

export var event: String
export var visible_after: String = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	if visible_after == '':
		# No triggers, this should be visible by default
		visible = true
	else:
		visible = false

func _input(_ev):
	if Input.is_action_just_pressed(event):
		# Player has succesfully followed the tutorial, no need to stick around
		visible = false
		queue_free()
	if Input.is_action_just_pressed(visible_after):
		# Necessary conditions have been met, appear
		visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
