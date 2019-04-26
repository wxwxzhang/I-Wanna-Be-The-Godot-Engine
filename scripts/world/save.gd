extends Area2D

var can_save = true
onready var anim_spr = $AnimatedSprite

export(int, "Medium", "Hard", "Very Hard") var difficulty

func _ready():
	if global.difficulty > difficulty:
		queue_free()
func _physics_process(delta):
	for i in get_overlapping_bodies():
		if (i.is_in_group("player") && Input.is_action_just_pressed("ui_shoot")) || \
				i.is_in_group("bullet"):
			_save()
func _save():
	if can_save:
		can_save = false
		anim_spr.frame = 1
		$Timer.start()
		$Timer2.start()
		global.save_game(true)

func _on_Timer_timeout():
	anim_spr.frame = 0

func _on_Timer2_timeout():
	can_save = true
