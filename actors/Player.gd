extends "res://actors/ActorBase.gd"
class_name Player

puppet var puppet_motion = Vector2()
 
var minimap_icon = "other_player"
var stunned = false

var prev_shooting = false
var shoot_index = 0
var flashlight = true
var firerate_multiplier = 1
var speed_multiplier = 1
var respawn_time = null
var viewRotation = 0

var door_controls_available = false setget set_door_controls_available

enum GuiState {
	hidden,
	inventory,
	door_controls
}

var gui_state = GuiState.hidden setget set_gui_state

onready var InventoryGui = $"../../CanvasLayer/InventoryGui"
onready var DoorConsoleGui = $"../../CanvasLayer/DoorConsoleGui"
onready var MouseCursor = $"../../Cursor"
onready var MouseCrosshair = $"../../Crosshair"

func set_door_controls_available(new_value):
	door_controls_available = new_value
	if not new_value and gui_state == GuiState.door_controls:
		toggle_door_controls_gui()

func setDefaults():
	$PlayerAnimationPlayer.play("Stand")
	has_weapons = [true, false, false, false, false, false, false]
	ammo = [0, 0, 0, 0, 0, 0, 0]
	switch_weapon(0)
	stunned = false
	prev_shooting = false
	shoot_index = 0

	health_regeneration = 1
	firerate_multiplier = 1
	speed_multiplier = 1
	damage_multiplier = 1
	
	speed = 200
	max_health = 100
	health = max_health
	
	setdamagemultiplier(1)
	setspeedmultiplier(1)


func can_shoot():
	return not stunned and gui_state == GuiState.hidden and health > 0



func setdamagemultiplier(f):
	damage_multiplier = f
	if f > 1:
		$DDAnimationPlayer.play("DD")
		get_node("../../CanvasLayer/DDAnimation").play("DD")
	else:
		$DDAnimationPlayer.play("Default")
		get_node("../../CanvasLayer/DDAnimation").play("None")
	
func setspeedmultiplier(f):
	speed_multiplier = f
	if f > 1:
		$SpeedAnimationPlayer.play("Speed")
	else:
		$SpeedAnimationPlayer.play("Default")
	
func addhealth(h):
	health = min(health + h, max_health)
	get_node("../../CanvasLayer/HealthAnimations").play("Heal")
	
var locked = false
func lockPlayer():
	locked = true

func unlockPlayer():
	locked = false
	
var flashRotation = 0
var gunRotation = 0
var gunScale = 1
var gunZ = 0
func _physics_process(delta):
	if health <= 0 or locked:
		return
	
	var motion = Vector2()

	if is_network_master():
		if Input.is_action_pressed("move_left"):
			motion += Vector2(-1, 0)
		if Input.is_action_pressed("move_right"):
			motion += Vector2(1, 0)
		if Input.is_action_pressed("move_up"):
			motion += Vector2(0, -1)
		if Input.is_action_pressed("move_down"):
			motion += Vector2(0, 1)
			
			
		if Input.is_action_just_pressed("mute"):
			AudioServer.set_bus_mute(1, not AudioServer.is_bus_mute(1))
			
		if Input.is_action_just_pressed("flashlight"):
			flashlight = not flashlight
			rpc("update_flashlight", flashlight)
			
		if Input.is_action_just_pressed("inventory"):
			toggle_inventory()
		if Input.is_action_just_pressed("ui_accept") and door_controls_available:
			toggle_door_controls_gui()
			
		if Input.is_action_just_pressed("weapon1"):
			rpc("switch_weapon", 0)
		if Input.is_action_just_pressed("weapon2"):
			rpc("switch_weapon", 1)
		if Input.is_action_just_pressed("weapon3"):
			rpc("switch_weapon", 2)
		if Input.is_action_just_pressed("weapon4"):
			rpc("switch_weapon", 3)
		if Input.is_action_just_pressed("weapon5"):
			rpc("switch_weapon", 4)
		if Input.is_action_just_pressed("weapon6"):
			rpc("switch_weapon", 5)
		if Input.is_action_just_pressed("weapon7"):
			rpc("switch_weapon", 6)
		if Input.is_action_just_released("weapon_next"):
			rpc("switch_weapon_relative", 1)
		if Input.is_action_just_released("weapon_prev"):
			rpc("switch_weapon_relative", -1)
			
		if gui_state != GuiState.hidden:
			return

		motion = motion.normalized()

		var shooting = Input.is_action_pressed("shoot")

		if stunned:
			shooting = false
			motion = Vector2()

		#if shooting and not prev_shooting:
		#	#var bomb_pos = position
		#	rpc("setup_bullet", get_tree().get_network_unique_id())
			
		viewRotation = get_angle_to(get_global_mouse_position())
		#if motion != Vector2.ZERO:
		#	playerRotation = get_angle_to(self.position + motion)
			
		var ang = viewRotation / PI * 180
		if ang >= -45 and ang < 45:
			$PlayerAnimationPlayer.play("Right")
		if ang >= 45 and ang < 135:
			$PlayerAnimationPlayer.play("Down")
		if ang >= 135 or ang < -135 :
			$PlayerAnimationPlayer.play("Left")
		elif ang < -45 and ang >= -135:
			$PlayerAnimationPlayer.play("Up")
				
		

		prev_shooting = shooting

		rset("puppet_motion", motion)
		rset("puppet_rotation", viewRotation)
		rset("puppet_pos", position)
	else:
		position = puppet_pos
		motion = puppet_motion
		viewRotation = puppet_rotation
			
#	get_node("Pointer/Sprite").rotation = get_angle_to(get_global_mouse_position()) + PI/2

	# FIXME: Use move_and_slide
	# $Group.look_at(get_global_mouse_position())
	
	#$Group.rotation = rotation
	$Group/Camera2D/flashlight.rotation = viewRotation
	$Group/Gun.rotation = viewRotation + PI / 2
	
	move_and_slide(motion * speed * speed_multiplier)
	if not is_network_master():
		puppet_pos = position # To avoid jitter

sync func update_flashlight(visible):
	$Group/Camera2D/flashlight.visible = visible


puppet func stun():
	if locked:
		return
	stunned = true

master func exploded(_by_who):
	if locked:
		return
	if stunned:
		return
	rpc("stun") # Stun puppets
	stun() # Stun master - could use sync to do both at once

func set_player_name(new_name):
	get_node("label").set_text(new_name)

func _ready():
	setDefaults()
	stunned = false
	puppet_pos = position
	get_node("../../CanvasLayer/HealthDisplay").show_always()
	
	var colors = get_node("../../CanvasLayer/Score").player_colors;
	$label.add_color_override("font_color", colors[(int(get_name()) - 1) % colors.size()])
	
	if is_network_master():
		$Group/Camera2D.make_current()
	
var dying = false	
	
		
func on_Ammo_changed(val):
	if locked:
		return
	get_node("/root/World/CanvasLayer/AmmoHUD/AmmoCounter").text = "Ammo: " + str(val)
	ammo[current_weapon] = val


func _on_damage():
	if locked:
		return
	if health > 0:
		$HitPlayer.play("Hit")
		get_node("/root/World/CanvasLayer/HealthAnimations").play("Damage")

func _on_heal():
	if locked:
		return
	pass # Replace with function body.


func _on_health_changed():
	$HealthDisplay.update_healthbar(health, max_health)
	if is_network_master():
		get_node("/root/World/CanvasLayer/HealthDisplay").update_healthbar(health, max_health)


func _on_death(by_who):
	$AnimationPlayer.play("Die")
	$CollisionShape2D.set_deferred("disabled", true)
	if by_who > 0:
		$"/root/World/CanvasLayer/Score".rpc("increase_score", by_who, 50)
	else:
		$"/root/World/CanvasLayer/Score".rpc("increase_score", get_tree().get_network_unique_id(), -50)
	yield(get_tree().create_timer(0.5), "timeout")
	
	if is_network_master():
		$"/root/World/CanvasLayer/Transitions".play("Portal")
	yield(get_tree().create_timer(5), "timeout")
	var SpawnPoints = get_node("/root/World/Level/SpawnPoints")
	var spawn = SpawnPoints.get_child( randi() % SpawnPoints.get_child_count())
	respawn_at(spawn.position)

	if is_network_master():
		$"/root/World/CanvasLayer/Transitions".play("PortalOut")

func _on_respawn():
	show()
	$CollisionShape2D.set_deferred("disabled", false)
	$AnimationPlayer.play("Spawn")
	rpc("switch_weapon", 1)		
	setDefaults()

func setMap(newlevel):
	#var newlevel = instance_from_id(newlevel_id)
	Logger.info("player.setMap (master: " + str(is_network_master()) + ")")
	var world = get_node("/root/World")
	
	if not world.get_node("Level"):
		Logger.error("no level after insert?! (master: " + str(is_network_master()) + ")")
	
	
	var SpawnPoints = newlevel.get_node("SpawnPoints")
	var spawn = SpawnPoints.get_child(0)
	
	spawn_at(spawn.position)
	unlockPlayer()
	
	
	yield(world.get_tree().create_timer(1), "timeout")
	#newlevel.show()
	
	world.get_node("CanvasLayer/Transitions").play("PortalOut")
	
func set_gui_state(new_gui_state):
	gui_state = new_gui_state
	match new_gui_state:
		GuiState.hidden:
			InventoryGui.close()
			DoorConsoleGui.close()
			MouseCrosshair.update_cursor()
		GuiState.inventory:
			DoorConsoleGui.close()
			InventoryGui.open()
			MouseCursor.update_cursor()
		GuiState.door_controls:
			DoorConsoleGui.open()
			InventoryGui.close()
			MouseCursor.update_cursor()
	
func toggle_inventory():
	if gui_state == GuiState.inventory:
		gui_state = GuiState.hidden
	else:
		gui_state = GuiState.inventory
	set_gui_state(gui_state)

	
func toggle_door_controls_gui():
	if gui_state == GuiState.door_controls:
		gui_state = GuiState.hidden
	else:
		gui_state = GuiState.door_controls
	set_gui_state(gui_state)
