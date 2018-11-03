extends Node

var save_scene = ""
onready var last_scene = ""


const DATA_PATH = "user://Data//";
const SAVE_FILE_NAME = "user://Data//save";

enum { DIF_MEDIUM, DIF_HARD, DIF_VERYHARD, DIF_IMPOSSIBLE }

func _ready():
	pass
func _process(delta):
	##### Game check #####
	if Input.is_action_just_pressed("ui_restart"):
		get_tree().change_scene(save_scene)
	
	##### Function keys #####
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

