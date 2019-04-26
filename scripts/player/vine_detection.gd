extends Area2D

func _physics_process(delta):
	for vine in get_overlapping_areas():
		if vine.is_in_group("vine_left"):
			get_parent().on_vine_left = true
			return
		if vine.is_in_group("vine_right"):
			get_parent().on_vine_right = true
			return
	get_parent().on_vine_left = false
	get_parent().on_vine_right = false