extends Area2D

export var speed = 2000
export var damage = 80

var by_who = 0

func _physics_process(delta):
	var velocity = Vector2 (0, -speed).rotated (global_rotation)
	global_position +=  velocity * delta

func _on_SimpleBullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.take_damage(damage, by_who)
	else:
		if body.is_in_group("players"):
			body.take_damage(20, by_who)
	queue_free()
