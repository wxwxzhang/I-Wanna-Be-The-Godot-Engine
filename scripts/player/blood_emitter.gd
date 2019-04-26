extends Particles2D
func _ready():
	emitting = true

func _on_Timer_timeout():
	emitting = false
