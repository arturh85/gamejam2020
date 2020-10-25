extends Node2D

func _ready():
	$AnimationPlayer.play("Rotate")

func _on_body_entered(body):
	if body.is_in_group("players") and $RespawnTimer.is_stopped() and body.has_weapon2 == false:
		body.has_weapon2 = true
		body.rset('has_weapon2', true)
		body.rpc('switch_weapon', 2)
		$RespawnTimer.start()
		$AnimationPlayer.play("Collect")
		yield(get_tree().create_timer(0.5), "timeout")
		hide()

func _on_RespawnTimer_timeout():
	$RespawnTimer.stop()
	$AnimationPlayer.play("Spawn")
	yield(get_tree().create_timer(0.1), "timeout")
	$AnimationPlayer.play("Rotate")
	show()