extends Node2D


var modified_player

func _on_FireRatePowerUp_body_entered(body):
	if body.is_in_group("players") and $RespawnTimer.is_stopped():
		if body.health != body.max_health:
			$RespawnTimer.start()

			#var val = 100
			#body.max_health += val
			body.health = body.max_health
			body.updateBar(body.health) 
			#yield(get_tree().create_timer($EffectTimer.wait_time), "timeout")
			#body.health -= val
			#body.max_health -= val
			#body.updateBar(body.health) 
			
			$AnimationPlayer.play("Collect")
			yield(get_tree().create_timer(1), "timeout")
			hide()

func _on_RespawnTimer_timeout():
	$RespawnTimer.stop()
	$AnimationPlayer.play("Spawn")
	show()
