extends Node2D

func _ready():
	$AnimationPlayer.play("Rotate")

func _on_body_entered(body):
	if body.is_in_group("players") and $RespawnTimer.is_stopped():
		body.has_weapon4 = true
		body.switch_weapon(4)
		$RespawnTimer.start()
		$AnimationPlayer.play("Collect")
		yield(get_tree().create_timer(0.5), "timeout")
		hide()

func _on_RespawnTimer_timeout():
	$RespawnTimer.stop()
	show()
