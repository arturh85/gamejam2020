extends Node

class_name GDWeaponsAutoAttack

export var input_action_trigger = "" setget _set_input_trigger
onready var weapon = get_node(GDWeaponsWeapon.WEAPON_PATH_FROM_COMPONENT)
onready var magazine = weapon.get_node("Magazine") if weapon.has_node("Magazine") else null

var manual_control = false

func _set_input_trigger(val):
	input_action_trigger = val
	set_process(input_action_trigger != "") #optimization! may need to remove if adding stuff in process beyond input checking

func _ready():
	if manual_control:
		set_process(false)
	elif input_action_trigger == "":
		call_deferred("start_auto_attack")
		connect("tree_exited",self,"end_auto_attack")
	pass
	
func _process(_delta):
	var player = weapon.get_parent().get_parent().get_parent()
	if player.is_network_master() and input_action_trigger != "":
		if Input.is_action_just_pressed(input_action_trigger):
			call_deferred("start_auto_attack")
		elif Input.is_action_just_released(input_action_trigger):
			call_deferred("end_auto_attack")


func start_auto_attack():
	_connect_weapon(true)
	_connect_mag(true)

	weapon.start_attack()

func end_auto_attack():
	_connect_weapon(false)
	_connect_mag(false)

func _connect_mag(to_connect):
	if magazine != null:
		var action = magazine.get_node("ReloadAction")
		var cntd = action.is_connected("ended",weapon,"start_attack")
		if to_connect and not cntd:
			action.connect("ended",weapon,"start_attack")
		elif not to_connect and cntd:
			action.disconnect("ended",weapon,"start_attack")

func _connect_weapon(to_connect):
	var weapon_connected = weapon.is_connected("can_start_action_again",weapon,"start_attack")
	if to_connect and not weapon_connected:
		weapon.connect("can_start_action_again",weapon,"start_attack")
	elif not to_connect and weapon_connected:
		weapon.disconnect("can_start_action_again",weapon,"start_attack")
