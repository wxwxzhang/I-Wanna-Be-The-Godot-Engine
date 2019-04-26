extends Sprite

export(PackedScene) var player

func _ready():
	if get_tree().get_nodes_in_group("player").size() == 0:
		var inst = player.instance()
		inst.position = Vector2(position.x + 17, position.y + 23)
		get_parent().call_deferred("add_child", inst)
	visible = false
	