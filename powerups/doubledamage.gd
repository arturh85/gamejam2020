extends Node2D


var modified_player

func _ready():
	$AnimationPlayer.play("Rotate")

func _on_FireRatePowerUp_body_entered(body):
	if body.is_in_group("players") and $RespawnTimer.is_stopped():
		$RespawnTimer.start()
		hide()

		body.setdamagemultiplier(2)
		yield(get_tree().create_timer($EffectTimer.wait_time), "timeout")
		body.setdamagemultiplier(1)

func _on_RespawnTimer_timeout():
	$RespawnTimer.stop()
	show()
