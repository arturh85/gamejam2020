extends KinematicBody2D
class_name HealthBase

export puppet var health = 100
export var max_health = 100
export var health_regeneration = 0

signal on_damage
signal on_heal
signal on_health_changed
signal on_death
signal on_respawn
signal on_removed

onready var HealthDisplay = $HealthDisplay

func _ready():
	connect("on_health_changed", self, "on_health_changed")
	pass

func _process(delta):
	if health <= 0:
		return
	if health_regeneration > 0:
		health = min(health + health_regeneration * delta, max_health)
		emit_signal("on_heal")
		emit_signal("on_health_changed")
		
master func take_damage(amount, by_who):
	if health <= 0:
		return
	health = max(0, health - amount)
	rset("health", health)
	rpc("on_took_damage")
	if health <= 0:
		print("sending die()")
		rpc("die", by_who)
		
remotesync func die(by_who):
	print("emitting on_death()")
	emit_signal("on_death", by_who)
	if $CollisionShape2D:
		$CollisionShape2D.set_deferred("disabled", true)
		
remotesync func on_took_damage():
	emit_signal("on_damage")
	emit_signal("on_health_changed")


func on_health_changed():
	if HealthDisplay:
		HealthDisplay.update_healthbar(health, max_health)
