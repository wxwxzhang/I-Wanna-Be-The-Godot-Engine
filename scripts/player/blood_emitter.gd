extends Particles2D
export(PackedScene) var game_over

func _ready():
	emitting = true
	# Pause music
	global.get_node("AudioStreamPlayer/AnimationPlayer").play("fade")

func _on_Timer_timeout():
	emitting = false
	# Create GAME OVER
	for camera in get_tree().get_nodes_in_group("camera"):
		var inst = game_over.instance()
		get_parent().add_child(inst)
		inst.position = camera.position + Vector2(400, 304)

func _on_Timer2_timeout():
	# Play death music
	$DeathMusic.play()
