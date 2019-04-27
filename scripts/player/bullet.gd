extends KinematicBody2D

var dir

func _physics_process(delta):
	var body = move_and_collide(Vector2(dir * 16, 0))
	if body != null:
		if body.get_collider().is_in_group("block"):
			queue_free()
func _on_Timer_timeout():
	queue_free()
	pass

