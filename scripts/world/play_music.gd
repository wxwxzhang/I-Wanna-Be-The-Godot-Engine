extends Sprite

export(AudioStream) var music

func _ready():
	# Hide sprite
	visible = false
	# Change music
	var audio_player = global.get_node("AudioStreamPlayer")
	if audio_player.stream != music:
		audio_player.stream = music
		audio_player.play()
		