extends Area2D

var can_save = true

export(Script) var player
export(Script) var bullet

func _physics_process(delta):
	for i in get_overlapping_bodies():
		if (i is player && Input.is_action_just_pressed("ui_shoot")) || \
				i is bullet:
			_save()
func _save():
	if can_save:
		can_save = false
		$Sprite.frame = 1
		$Timer.start()
		$Timer2.start()
		global.save_game(true)

func _on_Timer_timeout():
	$Sprite.frame = 0

func _on_Timer2_timeout():
	can_save = true
