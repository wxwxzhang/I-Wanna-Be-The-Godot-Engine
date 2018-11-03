extends Node2D

var select = 1
var exists = {}
var difficulty = {}
var death = {}
var time = {}

onready var sprite_xstart = $Sprites.position.x

const DATA_PATH = "user://Data//";
const SAVE_FILE_NAME = "user://Data//save";

func _ready():
	# Check data directory exists
	var dir = Directory.new()
	if !dir.dir_exists(DATA_PATH):
		dir.make_dir(DATA_PATH)
	
	for i in range(1, 4, 1):
		exists[i] = true
		##### Load save file #####
		var f = File.new()
		if !f.file_exists(SAVE_FILE_NAME + str(i)):
			exists[i] = false
			difficulty[i] = 0
			death[i] = 0
			time[i] = 0
		else:
			f.open_encrypted_with_pass(SAVE_FILE_NAME + str(i), File.READ, global.save_password)
			var dict = f.get_var()
			difficulty[i] = dict["difficulty"]
			death[i] = dict["death"]
			time[i] = dict["time"]
			f.close()
		##### Update labels #####
		var lbl = get_node("Labels/Difficulty/Difficulty" + str(i))
		if !exists[i]:
			lbl.text = "No Data"
		else:
			match difficulty[i]:
				global.DIF_MEDIUM:
					lbl.text = "Medium"
				global.DIF_MEDIUM:
					lbl.text = "Hard"
				global.DIF_MEDIUM:
					lbl.text = "Very Hard"
				global.DIF_MEDIUM:
					lbl.text = "Impossible"
					
		lbl = get_node("Labels/Deaths/Deaths" + str(i))
		lbl.text = "Deaths: " + str(death[i])
		
		lbl = get_node("Labels/Time/Time" + str(i))
		var t = time[i]
		var s = (t / 60) % 60
		var m = (t / 3600) % 60
		var h = (t / 216000) % 60
		lbl.text = "Time: " + \
				str(h) + ":" + \
				(str(m) if str(m).length() > 1 else "0" + str(m)) + ":" + \
				(str(s) if str(s).length() > 1 else "0" + str(s))

func _process(delta):
	# Inputs
	if Input.is_action_just_pressed('ui_left'):
		select = select - 1 if select > 1 else 3
	if Input.is_action_just_pressed('ui_right'):
		select = select + 1 if select < 3 else 1
	$Sprites.position.x = sprite_xstart + (select - 1) * 239
	if Input.is_action_just_pressed("ui_shift"):
		global.savenum = select
		get_tree().change_scene("res://levels/init/difficulty_select.tscn")
