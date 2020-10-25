extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var modified_player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FireRatePowerUp_body_entered(body):
	if body.is_in_group("players") and $Timer.is_stopped():
		$Timer.start()
		body.firerate_multiplier = 5
		modified_player = body


func _on_Timer_timeout():
	modified_player.firerate_multiplier = 1
	pass # Replace with function body.
