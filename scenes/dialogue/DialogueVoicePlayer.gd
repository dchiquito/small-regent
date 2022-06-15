class_name DialogueVoicePlayer
extends AudioStreamPlayer

var rng := RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func play(from_position := 0.0) -> void:
	pitch_scale = rng.randf_range(0.95, 1.08)
	.play(from_position)
