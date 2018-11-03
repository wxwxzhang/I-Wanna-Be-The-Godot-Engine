extends Node

var room_caption_def = "I Wanna Be The Godot Engine"

var savenum = 1
var difficulty = 0
var death = 0
var time = 0

var save_scene = ""
var save_player = Vector2()

var game_clear = false
var save_game_clear = false

var game_started = false

const DATA_PATH = "user://Data//";
const SAVE_FILE_NAME = "user://Data//save";

enum { DIF_MEDIUM, DIF_HARD, DIF_VERYHARD, DIF_IMPOSSIBLE }

func _ready():

	pass
func _process(delta):
	print(is_player_exists())
	##### Game check #####
	if game_started:
		time += 1
		_update_title()
		if Input.is_action_just_pressed("ui_restart"):
			get_tree().change_scene(save_scene)
	
	##### Function keys #####
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
func _update_title():
	WindowDialog.window_title = room_caption_def + \
			 " -" + \
			 " Deaths: " + str(death) + \
			 " Time: " + str(time / 216000 % 60) + ":" + str(time / 3600 % 60) + ":" + str(time / 60 % 60) 
func is_player_exists():
	var node = get_tree().get_root().find_node("Player", true, false) 
	if node == null:
		return false
	return node.filename.find("player.tscn") != -1