extends Area2D

export var speed = 700

func _physics_process(delta):
	var velocity = Vector2 (0, -speed).rotated (global_rotation)
	global_position +=  velocity * delta

func _on_SimpleBullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.take_damage(10)
		print("Hit mob")
	else:
		if body.is_in_group("players"):
			body.take_damage(20)
			print("Hit player")
		else:
			print("Hit Wall or Something")
	queue_free()
