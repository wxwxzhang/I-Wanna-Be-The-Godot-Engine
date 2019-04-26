extends Area2D

func _on_VineR_body_entered(body):
	if body.is_in_group("player"):
		body.on_vine_right = true
		
func _on_VineR_body_exited(body):
	if body.is_in_group("player"):
		body.on_vine_right = false
