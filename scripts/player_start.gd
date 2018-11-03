extends Sprite

func _ready():
	if !global.is_player_exists():
		var inst = preload("res://objects/player/player.tscn").instance()
		print(position)
		inst.position = Vector2(position.x + 17, position.y + 23)
		print(inst.position)
		get_parent().call_deferred("add_child", inst)
	visible = false
	