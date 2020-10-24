extends Area2D

var speed = 750

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.take_damage(2)
		print("Hit mob")
	else: 
		if body.is_in_group("players"):
			body.take_damage(2)
			print("Hit player")
		else:
			print("Hit Wall or Something")
	queue_free()
