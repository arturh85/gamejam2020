extends Node2D

enum State {
	closed,
	opening,
	closing,
	open
}

var state = State.closed

onready var sprite = $Sprite
onready var shape = $Body/Shape

var players_in_area = 0

func _process(_delta):
	if players_in_area > 0 and state == State.closed:
		Logger.info("found player in area, opening: " + str(players_in_area))
		state = State.opening
		sprite.play("opening")
		shape.disabled = true
	elif players_in_area <= 0 and state == State.open:
		Logger.info("no found player in area, closing: " + str(players_in_area))
		state = State.closing
		sprite.play("opening", true)
		shape.disabled = true
	
func _on_animation_finished():
	if state == State.opening:
		state = State.open
		sprite.animation = "open"
		shape.disabled = true
		Logger.info("opening finished")
	elif state == State.closing:
		state = State.closed
		sprite.animation = "closed"
		shape.disabled = false
		Logger.info("closing finished")
	

func _on_Detect_body_entered(body):
	if body.is_in_group("players"):
		players_in_area += 1


func _on_Detect_body_exited(body):
	if body.is_in_group("players"):
		players_in_area -= 1
