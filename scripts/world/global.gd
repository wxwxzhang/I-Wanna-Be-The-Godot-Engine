extends Node

export(String, MULTILINE) var room_caption_def
export(PackedScene) var start_scene
export(String, MULTILINE) var save_password

var savenum = 1
var difficulty = 0
var death = 0
var time = 0

var save_scene = ""
var save_player = Vector2()

var game_clear = false
var save_game_clear = false

var game_started = false
var auto_save = false

var scene_last = null
signal scene_start

var player_reset_position = false

const DATA_PATH = "user://Data//"
const SAVE_FILE_NAME = "user://Data//save"

enum { 
	DIF_MEDIUM = 0
	DIF_HARD = 1
	DIF_VERYHARD = 2
	DIF_IMPOSSIBLE = 3
}

func _ready():
	connect("scene_start", self, "_on_scene_start") 
	pass
func _process(delta):
	##### Game check #####
	if get_tree().current_scene != scene_last:
		scene_last = get_tree().current_scene
		emit_signal("scene_start")
	if game_started:
		time += 1
		_update_title()
		if Input.is_action_just_pressed("ui_restart"):
			load_game(false)
	
	##### Function keys #####
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("ui_f2"):
		game_restart()
func _update_title():
	OS.set_window_title(room_caption_def + 
			 " -" + 
			 " Deaths: " + str(death) + 
			 " Time: " + str(time / 216000 % 60) + ":" + str(time / 3600 % 60) + ":" + str(time / 60 % 60))
func get_player():
	var node = get_tree().get_root().find_node("Player", true, false) 
	if node == null:
		return null
	if node.filename.find("player.tscn") == -1:
		return null
	return node
func save_game(save_position):
	if save_position:
		save_scene = get_tree().current_scene.filename
		save_player = get_player().position
	var dict = {}
	dict["death"] = death
	dict["time"] = time
	dict["difficulty"] = difficulty
	dict["save_scene"] = save_scene
	dict["save_player"] = save_player
	dict["save_game_clear"] = save_game_clear
	var f = File.new()
	f.open_encrypted_with_pass(SAVE_FILE_NAME + str(savenum), File.WRITE, save_password)
	f.store_var(dict)
	f.close()
func load_game(load_file):
	if load_file:
		var f = File.new()
		var err = f.open_encrypted_with_pass(SAVE_FILE_NAME + str(savenum), File.READ, save_password)
		if err != ERR_FILE_CORRUPT:
			var dict = f.get_var()
			death = dict["death"]
			time = dict["time"]
			difficulty = dict["difficulty"]
			save_scene = dict["save_scene"]
			save_player = dict["save_player"]
			save_game_clear = dict["save_game_clear"]
			f.close()
		else:
			game_restart()
			return
	game_started = true
	auto_save = false
	player_reset_position = true
	get_tree().change_scene(save_scene)
func _on_scene_start():
	pass
func game_restart():
	get_tree().change_scene(ProjectSettings.get_setting("application/run/main_scene"))
	# Initialize
	game_started = false
	OS.set_window_title(room_caption_def)
	savenum = 1
	death = 0
	time = 0
	difficulty = 0
	save_scene = ""
	save_player = Vector2()
	save_game_clear = false
