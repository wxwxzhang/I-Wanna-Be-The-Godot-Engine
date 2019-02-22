extends Node2D

var timer = 0
func _physics_process(delta):
	timer += 1
	for i in 40:
		var inst = preload("res://objects/player/Blood.tscn").instance()
		inst.position = position
		get_parent().add_child(inst)
	if timer == 20:
		queue_free()
		