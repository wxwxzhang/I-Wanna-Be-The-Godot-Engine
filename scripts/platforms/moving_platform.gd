extends StaticBody2D

export(Vector2) var velocity

func _physics_process(delta):
	position += velocity

func _on_Area2D_body_entered(body):
	if body.is_in_group("block"):
		velocity *= -1

