extends Node

var room_caption_def = "I Wanna Be The Godot Engine"
var start_scene = "res://levels/sample/stage01.tscn"
var save_password = "Put something here"

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

const DATA_PATH = "user://Data//";
const SAVE_FILE_NAME = "user://Data//save";

enum { DIF_MEDIUM, DIF_HARD, DIF_VERYHARD, DIF_IMPOSSIBLE }

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
			get_tree().change_scene(save_scene)
	
	##### Function keys #####
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
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
	var dict = {}
	if save_position:
		save_scene = get_tree().current_scene
		save_player = get_player().position
		dict["player"] = save_player
	dict["death"] = death
	dict["time"] = time
	dict["difficulty"] = difficulty
	dict["scene"] = get_tree().current_scene
	dict["game_clear"] = save_game_clear
	var f = File.new()
	f.open_encrypted_with_pass(SAVE_FILE_NAME + str(savenum), File.WRITE, save_password)
	f.store_var(dict)
	f.close()
	
func _on_scene_start():
	if auto_save:
		save_game(true)
		auto_save = false
