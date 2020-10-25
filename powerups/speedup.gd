extends Node2D


var modified_player

func _on_FireRatePowerUp_body_entered(body):
	if body.is_in_group("players") and $RespawnTimer.is_stopped():
		if body.speed_multiplier <= 1:
			$RespawnTimer.start()
			body.setspeedmultiplier(1.5)
			$AnimationPlayer.play("Collect")		
			yield(get_tree().create_timer($EffectTimer.wait_time), "timeout")
			body.setspeedmultiplier(1)
			
			hide()

func _on_RespawnTimer_timeout():
	$RespawnTimer.stop()
	$AnimationPlayer.play("Spawn")
	show()
