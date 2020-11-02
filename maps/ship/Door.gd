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

export var locked = false setget set_locked

var players_in_area = 0

func set_locked(new_locked):
	locked = new_locked
	if locked and state != State.closed and State != State.closing:
		close()

func _process(_delta):
	if players_in_area > 0 and state == State.closed and not locked:
		open()
	elif players_in_area <= 0 and state == State.open:
		close()
		
func open():
	state = State.opening
	sprite.play("opening")
	shape.disabled = true
		
func close():
	state = State.closing
	sprite.play("opening", true)
	shape.disabled = true
	
func _on_animation_finished():
	if state == State.opening:
		state = State.open
		sprite.animation = "open"
		shape.disabled = true
	elif state == State.closing:
		state = State.closed
		sprite.animation = "closed"
		shape.disabled = false
	
func _on_Detect_body_entered(body):
	if body.is_in_group("players"):
		players_in_area += 1

func _on_Detect_body_exited(body):
	if body.is_in_group("players"):
		players_in_area -= 1

