extends Area2D

enum DIF { MEDIUM, HARD, VERYHARD, IMPOSSIBLE, LOADGAME }

export(DIF) var dif = 0
export(String) var dif_name
export(Script) var player

func _ready():
	$Label.text = dif_name

func _on_WarpStart_body_entered(body):
	if body is player:
		if dif == 4:
			var f = File.new()
			if f.file_exists(global.SAVE_FILE_NAME + str(global.savenum)):
				global.load_game(true)
			else:
				get_tree().reload_current_scene()
		else:
			global.game_started = true
			global.auto_save = true
			global.difficulty = dif
			
			get_tree().change_scene_to(global.start_scene)
