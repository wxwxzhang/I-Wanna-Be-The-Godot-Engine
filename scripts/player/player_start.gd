extends Sprite

export(PackedScene) var player

func _ready():
	if get_tree().get_nodes_in_group("player").size() == 0:
		var inst = player.instance()
		inst.position = position
		get_parent().call_deferred("add_child", inst)
	visible = false
	