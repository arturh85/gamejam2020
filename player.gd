extends KinematicBody2D

const MOTION_SPEED = 90.0

puppet var puppet_pos = Vector2()
puppet var puppet_motion = Vector2()
puppet var puppet_rotation = 0 
 
export (PackedScene) var Bullet

export var stunned = false

# Use sync because it will be called everywhere
sync func setup_bullet(by_who):
	var b = Bullet.instance()
	b.transform = $Group/Muzzle.global_transform
	b.from_player = by_who
	# No need to set network master to bomb, will be owned by server by default
	get_node("../..").add_child(b)

var prev_shooting = false
var shoot_index = 0

var speed = 150
var health = 50
var max_health = 50

sync func shoot():
	var b = Bullet.instance()
	get_node("../..").add_child(b)
	b.transform = $Group/Muzzle.global_transform

func _physics_process(_delta):
	var motion = Vector2()
	var rotation = 0

	if is_network_master():
		if Input.is_action_pressed("move_left"):
			motion += Vector2(-1, 0)
		if Input.is_action_pressed("move_right"):
			motion += Vector2(1, 0)
		if Input.is_action_pressed("move_up"):
			motion += Vector2(0, -1)
		if Input.is_action_pressed("move_down"):
			motion += Vector2(0, 1)
			
		motion = motion.normalized()

		var shooting = Input.is_action_pressed("shoot")

		if stunned:
			shooting = false
			motion = Vector2()

		if shooting and not prev_shooting:
			#var bomb_pos = position
			rpc("setup_bullet", get_tree().get_network_unique_id())
			
		rotation = get_angle_to(get_global_mouse_position())

		prev_shooting = shooting

		rset("puppet_motion", motion)
		rset("puppet_rotation", rotation)
		rset("puppet_pos", position)
	else:
		position = puppet_pos
		motion = puppet_motion
		rotation = puppet_rotation
			
#	get_node("Pointer/Sprite").rotation = get_angle_to(get_global_mouse_position()) + PI/2

	# FIXME: Use move_and_slide
	# $Group.look_at(get_global_mouse_position())
	$Group.rotation = rotation
	
	move_and_slide(motion * MOTION_SPEED)
	if not is_network_master():
		puppet_pos = position # To avoid jitter

puppet func stun():
	stunned = true

master func exploded(_by_who):
	if stunned:
		return
	rpc("stun") # Stun puppets
	stun() # Stun master - could use sync to do both at once

func set_player_name(new_name):
	get_node("label").set_text(new_name)

func _ready():
	stunned = false
	puppet_pos = position
	print("Master: ", is_network_master())
	print("Name: ", get_name(), " instance -> network    ", get_tree().get_network_unique_id())

	if is_network_master():
		$Group/Camera2D.make_current()
	
	
sync func take_damage(amount):
	health -= amount
	$HealthDisplay.update_healthbar(health)
	if health <= 0:
		health = max_health
		$HealthDisplay.update_healthbar(health)
