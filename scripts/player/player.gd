extends KinematicBody2D

var frozen = false

var jump = 8.5
var jump2 = 7
var gravity = 0.4

var djump = 1
var max_speed = 3
var max_vspeed = 9

var hspeed = 0
var vspeed = 0

export(PackedScene) var bullet

func _ready():
	if global.player_reset_position:
		position = global.save_player
		global.player_reset_position = false
	if global.auto_save:
		global.save_game(true)
		global.auto_save = false
func _physics_process(delta):
	var L = Input.is_action_pressed('ui_left')
	var R = Input.is_action_pressed('ui_right')

	var h = 0
	
	if !frozen:
		if R:
			h = 1
		elif L:
			h = -1
	if h != 0:
		hspeed = max_speed * h
		_set_anim("running")
		$Sprite.scale.x = h
	else:
		hspeed = 0
		_set_anim("idle")
	
	if vspeed < -0.05:
		_set_anim("jump")
	elif vspeed > 0.05:
		_set_anim("fall")
	
	if abs(vspeed) > max_vspeed:
		vspeed = sign(vspeed) * max_vspeed
	
	if !frozen:
		if Input.is_action_just_pressed("ui_shoot"):
			_shoot()
		if Input.is_action_just_pressed('ui_shift'):
			_jump()
		if Input.is_action_just_released('ui_shift'):
			_vjump()
			
	vspeed += gravity 
	move_and_slide(Vector2(hspeed, vspeed) * 50, Vector2(0, -1))
	
	if is_on_ceiling():
		vspeed = 0
	if is_on_floor():
		vspeed = 0
		djump = 1
	##### Check player killer #####
	for i in get_slide_count():
		if get_slide_collision(i).get_collider().is_in_group("killer"):
			# Kill the player
			global.kill_player()
func _jump():
	if is_on_floor():
		vspeed = -jump
		djump = 1
		$Sounds/Jump.play()
	elif djump == 1:
		vspeed = -jump2
		djump = 0
		$Sounds/DJump.play()
func _vjump():
	if vspeed < 0:
		vspeed *= 0.45
func _set_anim(anim):
	if $Anim.current_animation != anim:
		$Anim.play(anim)
func _shoot():
	if get_tree().get_nodes_in_group("bullet").size() < 4:
		var inst = bullet.instance()
		inst.position = position
		inst.dir = $Sprite.scale.x
		get_parent().add_child(inst)
		$Sounds/Shoot.play()
