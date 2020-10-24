extends Node

class_name GDWeaponsBulletSpawner

onready var weapon = get_node(GDWeaponsWeapon.WEAPON_PATH_FROM_COMPONENT)

export(PackedScene) var bullet_scene_path = load("res://bullets/SimpleBullet.tscn")

export var spread = 0.3

#MUST CONNECT spawn METHOD TO START/END ATTACK IN EDITOR!

func spawn():
	rpc("spawn2")

sync func spawn2():
	#create bullet
	var b = bullet_scene_path.instance()
	b.by_who = get_tree().get_network_unique_id()
	get_tree().get_root().add_child(b)

	#initialize bullet
	if weapon is Node2D:
		b.global_rotation = weapon.global_rotation + rand_range(-spread, spread)
		
		var muzzle = weapon.get_node("Muzzle")
		if muzzle:
			print("use muzzle")
			b.global_position = weapon.global_position + muzzle.position
		else:
			print("NO use muzzle")
			b.global_position = weapon.global_position
	else:
		pass
