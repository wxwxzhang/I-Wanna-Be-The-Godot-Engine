extends Area2D

enum DIF { MEDIUM, HARD, VERYHARD, IMPOSSIBLE, LOADGAME }

export(DIF) var dif = 0
export(String) var dif_name

func _ready():
	$Label.text = dif_name

func _on_WarpStart_body_entered(body):
	if body.is_in_group("player"):
		if dif == 4:
			##### Load game #####
			var f = File.new()
			if f.file_exists(global.SAVE_FILE_NAME + str(global.savenum)):
				global.load_game(true)
			else:
				# No save file exists
				get_tree().reload_current_scene()
		else:
			##### Start new game #####
			global.game_started = true
			global.auto_save = true
			global.difficulty = dif
			# Go to start scene
			get_tree().call_deferred("change_scene_to", global.start_scene)
