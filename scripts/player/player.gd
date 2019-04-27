extends KinematicBody2D

const JUMP = 8.5
const JUMP2 = 7
const GRAVITY = 0.4
const MAX_SPEED = 3
const MAX_VSPEED = 9

var frozen = false
var linear_vel = Vector2()
var djump = 1
var on_vine_left = false
var on_vine_right = false

export(PackedScene) var bullet

onready var anim_spr = $AnimatedSprite
onready var vine_detector = $VineDetector
onready var killer_detector = $KillerDetector

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
		for vine in vine_detector.get_overlapping_areas():
			if vine.is_in_group("vine_left"):
				on_vine_left = true
			if vine.is_in_group("vine_right"):
				on_vine_right = true
	
	if h != 0:
		if !on_vine_left and !on_vine_right:
			anim_spr.scale.x = h
		if (h == -1 and !on_vine_right) or (h == 1 and !on_vine_left):
			linear_vel.x = MAX_SPEED * h
			_set_anim("running")
	else:
		linear_vel.x = 0
		_set_anim("idle")
	
	if linear_vel.y < -0.05:
		_set_anim("jump")
	elif linear_vel.y > 0.05:
		_set_anim("fall")
	
	if abs(linear_vel.y) > MAX_VSPEED:
		linear_vel.y = sign(linear_vel.y) * MAX_VSPEED
	
	if on_vine_left or on_vine_right:
		if on_vine_right:
			anim_spr.scale.x = -1
		else:
			anim_spr.scale.x = 1
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
				$WallJump.play()
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
	move_and_slide(linear_vel * 50, Vector2(0, -1))
	
	if is_on_ceiling():
		linear_vel.y = 0
	if is_on_floor():
		linear_vel.y = 0
		djump = 1
		
func _jump():
	if is_on_floor():
		linear_vel.y = -JUMP
		djump = 1
		$Jump.play()
	elif djump == 1:
		linear_vel.y = -JUMP2
		djump = 0
		$DJump.play()
func _vjump():
	if linear_vel.y < 0:
		linear_vel.y *= 0.45
func _set_anim(anim):
	if anim_spr.animation != anim:
		match anim:
			"fall", "idle", "jump", "running":
				anim_spr.offset = Vector2(-17, -23)
			"sliding":
				anim_spr.offset = Vector2(-8, -10)
		anim_spr.play(anim)
func _shoot():
	if get_tree().get_nodes_in_group("bullet").size() < 4:
		var inst = bullet.instance()
		add_collision_exception_with(inst)
		inst.position = position
		inst.dir = anim_spr.scale.x
		get_parent().add_child(inst)
		$Shoot.play()


func _on_KillerDetector_area_entered(area):
	## Kill the player
	if area.is_in_group("killer"):
		global.kill_player()
