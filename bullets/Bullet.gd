extends Area2D

export var speed = 1
export var damage = 1

var by_who = 0
var shooter = null

func _physics_process(delta):
	var velocity = Vector2 (0, -speed).rotated (global_rotation)
	global_position +=  velocity * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.rpc("take_damage", damage * shooter.damage_multiplier, by_who)
		if body.has_method("hitsound"):
			body.hitsound()
	queue_free()
