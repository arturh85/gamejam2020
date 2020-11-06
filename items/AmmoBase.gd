extends Node2D

signal on_removed(what)
var minimap_icon = "alert"
export var weapon_nr = 0
export var weapon_ammo = 100

func _ready():
	$AnimationPlayer.play("Rotate")

func _on_body_entered(body):
	if body.is_in_group("players") and $RespawnTimer.is_stopped():
		body.rpc('add_ammo', weapon_nr, weapon_ammo)
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
