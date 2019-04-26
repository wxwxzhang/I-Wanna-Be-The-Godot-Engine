extends Area2D

func _on_VineL_body_entered(body):
	if body.is_in_group("player"):
		body.on_vine_left = true
		
func _on_VineL_body_exited(body):
	if body.is_in_group("player"):
		body.on_vine_left = false
