extends Area2D

export var speed = 800

var by_who = 0

func _physics_process(delta):
	var velocity = Vector2 (0, -speed).rotated (global_rotation)
	global_position +=  velocity * delta

func _on_OtherBullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.take_damage(30, by_who)
	else:
		if body.is_in_group("players"):
			body.take_damage(40, by_who)
	queue_free()
