extends Area2D

var is_player_enter = false
var can_save = true

func _process(delta):
	if is_player_enter && Input.is_action_just_pressed("ui_shoot"):
		_save()

func _on_Save_body_entered(body):
	if body.filename == "res://objects/player.tscn":
		is_player_enter = true
	if body.filename == "res://objects/bullet.tscn":
		_save()
func _on_Save_body_exited(body):
	if body.filename == "res://objects/player.tscn":
		is_player_enter = false
	
func _save():
	if can_save:
		can_save = false
		print("save!")
		$Sprite.frame = 1
		$Timer.start()
		$Timer2.start()

func _on_Timer_timeout():
	$Sprite.frame = 0


func _on_Timer2_timeout():
	can_save = true
