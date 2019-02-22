extends Area2D
var direction = 0
var speed = 0
#var gravity = 0
var motion = Vector2()
"""
func _ready():
	$Sprite.frame = randi() % 3
	direction = randi() % 35 * 10
	speed = rand_range(0, 6)
	gravity = 0.1 + rand_range(0, 0.2)
	motion = Vector2(cos(direction), sin(direction)) * speed
func _physics_process(delta):
	move_and_slide(motion * 50)
	motion.y += gravity
	"""
