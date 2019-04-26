extends Camera2D

func _process(delta):
	# Update view position
	for player in get_tree().get_nodes_in_group("player"):
		position = Vector2(
				floor(player.position.x / 800) * 800,
				floor(player.position.y / 608) * 608)