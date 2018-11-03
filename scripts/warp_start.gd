extends Area2D

enum DIF { MEDIUM, HARD, VERYHARD, IMPOSSIBLE, LOADGAME }
export(DIF) var dif = 0
export(String) var dif_name = ""

func _ready():
	$Label.text = dif_name

func _on_WarpStart_body_entered(body):
	if body is preload("res://scripts/player.gd"):
		if dif == 4:
			global.load_game(true)
		else:
			global.game_started = true
			global.auto_save = true
			global.difficulty = dif
			
			get_tree().change_scene(global.start_scene)
