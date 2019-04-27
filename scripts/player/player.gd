extends KinematicBody2D

const JUMP = 8.5
const JUMP2 = 7
const GRAVITY = 0.4
const MAX_SPEED = 3
const MAX_VSPEED = 9

var linear_vel = Vector2()
var frozen = false
var djump = 1
var on_vine_left = false
var on_vine_right = false
var on_platform = false

export(PackedScene) var bullet
export(NodePath) var anim_sprite
export(NodePath) var vine_detector
export(NodePath) var killer_detector
export(NodePath) var snd_jump
export(NodePath) var snd_double_jump
export(NodePath) var snd_shoot
export(NodePath) var snd_wall_jump

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
	## Vine detection
	var on_vine_left = false
	var on_vine_right = false
	
	if !is_on_floor():
		for vine in get_node(vine_detector).get_overlapping_areas():
			if vine.is_in_group("vine_left"):
				on_vine_left = true
			if vine.is_in_group("vine_right"):
				on_vine_right = true
	
	if h != 0:
		if !on_vine_left and !on_vine_right:
			get_node(anim_sprite).scale.x = h
		if (h == -1 and !on_vine_right) or (h == 1 and !on_vine_left):
			linear_vel.x = MAX_SPEED * h
			_set_anim("running")
	else:
		linear_vel.x = 0
		_set_anim("idle")
	if get_floor_velocity() == Vector2():
		if linear_vel.y < -0.05:
			_set_anim("jump")
		elif linear_vel.y > 0.05:
			_set_anim("fall")
	else:
		_set_anim("idle")
	
	if abs(linear_vel.y) > MAX_VSPEED:
		linear_vel.y = sign(linear_vel.y) * MAX_VSPEED
	
	if on_vine_left or on_vine_right:
		if on_vine_right:
			get_node(anim_sprite).scale.x = -1
		else:
			get_node(anim_sprite).scale.x = 1
		linear_vel.y = 2
		_set_anim("sliding")
		
		if (on_vine_left and Input.is_action_just_pressed("ui_right")) or \
				(on_vine_right and Input.is_action_just_pressed("ui_left")):
			if Input.is_action_pressed("ui_shift"):
				if on_vine_right:
					linear_vel.x = -15
				else:
					linear_vel.x = 15
				
				linear_vel.y = -9
				get_node(snd_wall_jump).play()
				_set_anim("jump")
			else:
				if on_vine_right:
					linear_vel.x = -3
				else:
					linear_vel.x = 3
	if !frozen:
		if Input.is_action_just_pressed("ui_shoot"):
			_shoot()
		if Input.is_action_just_pressed('ui_shift'):
			_jump()
		if Input.is_action_just_released('ui_shift'):
			_vjump()
			
	linear_vel.y += GRAVITY 
			
	move_and_slide(linear_vel * 50, Vector2(0, -1)) / 50
	
	if is_on_ceiling():
		linear_vel.y = 0
	if is_on_floor():
		linear_vel.y = 0
		djump = 1
		
func _jump():
	if is_on_floor():
		linear_vel.y = -JUMP
		djump = 1
		get_node(snd_jump).play()
	elif djump == 1:
		linear_vel.y = -JUMP2
		djump = 0
		get_node(snd_double_jump).play()
func _vjump():
	if linear_vel.y < 0:
		linear_vel.y *= 0.45
func _set_anim(anim):
	if get_node(anim_sprite).animation != anim:
		match anim:
			"fall", "idle", "jump", "running":
				get_node(anim_sprite).offset = Vector2(-17, -23)
			"sliding":
				get_node(anim_sprite).offset = Vector2(-8, -10)
		get_node(anim_sprite).play(anim)
func _shoot():
	if get_tree().get_nodes_in_group("bullet").size() < 4:
		var inst = bullet.instance()
		add_collision_exception_with(inst)
		inst.position = position
		inst.dir = get_node(anim_sprite).scale.x
		get_parent().add_child(inst)
		get_node(snd_shoot).play()


func _on_KillerDetector_area_entered(area):
	## Kill the player
	if area.is_in_group("killer"):
		global.kill_player()
