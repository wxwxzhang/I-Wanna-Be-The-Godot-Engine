extends Sprite

func _ready():
	if global.get_player() == null:
		var inst = preload("res://objects/player/player.tscn").instance()
		inst.position = Vector2(position.x + 17, position.y + 23)
		get_parent().call_deferred("add_child", inst)
	visible = false
	