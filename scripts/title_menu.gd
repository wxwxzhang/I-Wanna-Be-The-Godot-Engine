extends Node2D

export(String, FILE) var go_to_scene = "res://levels/init/menu.tscn"

func _process(delta):
	if Input.is_action_just_pressed("ui_shift"):
		get_tree().change_scene(go_to_scene)