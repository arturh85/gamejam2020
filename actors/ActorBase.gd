extends KinematicBody2D

export var speed = 200
export var health = 100
export var max_health = 100
export var current_weapon = 1
export var has_weapons = [false, false, false, false, false, false, false]
export var ammo = [0, 0, 0, 0, 0, 0, 0]
export var health_regeneration = 0

puppet var puppet_pos = Vector2()
puppet var puppet_velocity = Vector2()
puppet var puppet_rotation = 0 


var velocity = Vector2()
var respawn_position = null

signal on_damage
signal on_heal
signal on_health_changed
signal on_death
signal on_respawn

func _process(delta):
	if respawn_position:
		position = respawn_position
		respawn_position = null
		$CollisionShape2D.set_deferred("disabled", false)
		emit_signal("on_respawn")
	if health <= 0:
		return
	if health_regeneration > 0:
		health = min(health + health_regeneration * delta, max_health)
		emit_signal("on_heal")	
		emit_signal("on_health_changed")	
		
master func respawn_at(position):
	respawn_position = position

sync func take_damage(amount, by_who):
	if health <= 0:
		return
	health = max(0, health - amount)
	rset("health", health)
	emit_signal("on_damage")	
	emit_signal("on_health_changed")	
	if health <= 0:
		emit_signal("on_death", by_who)	
		$CollisionShape2D.set_deferred("disabled", true)
