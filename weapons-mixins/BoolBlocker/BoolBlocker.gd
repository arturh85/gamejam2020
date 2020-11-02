extends Node

class_name GDWeaponsBoolBlocker

onready var weapon2 = get_node(GDWeaponsWeapon.WEAPON_PATH_FROM_COMPONENT)
export var input_action_trigger = "" setget _set_input_trigger
export var auto_reset = false

func flip():
	pass #implement in children

func _set_input_trigger(val):
	input_action_trigger = val
	set_process(input_action_trigger != "") #optimization! may need to remove if adding stuff in process beyond input checking

func _process(delta):
	var player = weapon2.get_parent().get_parent().get_parent()
	if player.is_network_master() and player.can_shoot() and Input.is_action_just_pressed(input_action_trigger):
		flip()
