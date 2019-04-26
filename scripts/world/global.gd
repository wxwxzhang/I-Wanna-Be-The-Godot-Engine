extends Node
##### Export property #####
# Game's title
export(String, MULTILINE) var room_caption_def
# Save data encrypted password
export(String, MULTILINE) var save_password
# Start scene
export(PackedScene) var start_scene
# Blood emitter (node file)
export(PackedScene) var emitter
##### Global property #####
# Save number
var savenum = 1
# Difficulty
var difficulty = 0
enum { 
	DIF_MEDIUM = 0
	DIF_HARD = 1
	DIF_VERYHARD = 2
	DIF_IMPOSSIBLE = 3
}
# Death and time
var death = 0
var time = 0
# Save scene (room)
var save_scene = ""
# Save player position
var save_player = Vector2()
# Game clear
var game_clear = false
var save_game_clear = false
# Game started
var game_started = false
# Auto save
var auto_save = false
# Last scene
var scene_last = null
signal scene_start
# Whether to reset player position
var player_reset_position = false
# Data path
const DATA_PATH = "user://Data/"
const SAVE_FILE_NAME = "user://Data/save"

func _ready():
	## Connect signals
	connect("scene_start", self, "_on_scene_start") 
func _process(delta):
	##### Game check #####
	if get_tree().current_scene != scene_last:
		scene_last = get_tree().current_scene
		emit_signal("scene_start")
	if game_started:
		time += 1
		_update_title()
		if Input.is_action_just_pressed("ui_restart"):
			# Load save data
			load_game(false)
			# Unpause music
			$AudioStreamPlayer/AnimationPlayer.stop()
			$AudioStreamPlayer.stream_paused = false
			$AudioStreamPlayer.volume_db = 0
	##### Function keys #####
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("ui_f2"):
		game_restart()
func _update_title():
	## Update window caption (in game)
	var t = time
	var s = (t / 60) % 60
	var m = (t / 3600) % 60
	var h = (t / 216000) % 60
	var time_str = str(h) + ":" + \
			(str(m) if str(m).length() > 1 else "0" + str(m)) + ":" + \
			(str(s) if str(s).length() > 1 else "0" + str(s))
	OS.set_window_title(room_caption_def + 
			 " -" + 
			 " Deaths: " + str(death) + 
			 " Time: " + time_str)
func save_game(save_position):
	## Save the game
	if save_position:
		save_scene = get_tree().current_scene.filename
		for i in get_tree().get_nodes_in_group("player"):
			save_player = i.position
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
	## Load save data
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
	# Update window caption
	OS.set_window_title(room_caption_def)
func game_restart():
	get_tree().change_scene(ProjectSettings.get_setting("application/run/main_scene"))
	# Reset property values
	game_started = false
	savenum = 1
	death = 0
	time = 0
	difficulty = 0
	save_scene = ""
	save_player = Vector2()
	save_game_clear = false
func kill_player():
	## Kill the player
	# Get player node
	for player in get_tree().get_nodes_in_group("player"):
		# Create emitter
		var inst = emitter.instance()
		inst.position = player.position
		player.get_parent().add_child(inst)
		# Destroy player
		player.queue_free()
		