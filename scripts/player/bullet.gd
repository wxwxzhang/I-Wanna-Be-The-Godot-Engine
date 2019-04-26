extends KinematicBody2D

var dir = 1
onready var spr = $Node/AnimatedSprite

func _ready():
	move_and_slide(Vector2())
	if get_slide_count() != 0:
		queue_free()
	else:
		spr.visible = true

func _physics_process(delta):
	move_and_slide(Vector2(dir * 16, 0) * 50)
	if get_slide_count() != 0:
		queue_free()
	else:
		spr.position = position


func _on_Timer_timeout():
	queue_free()

