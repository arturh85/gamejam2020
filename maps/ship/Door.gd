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
export var opened = false setget set_opened

var players_in_area = 0

func _process(_delta):
	if players_in_area > 0 and state == State.closed and not locked:
		start_open()
	elif players_in_area <= 0 and state == State.open and not opened:
		start_close()
		
func _on_animation_finished():
	if state == State.opening:
		finish_open()
	elif state == State.closing:
		finish_close()

func set_locked(new_locked):
	locked = new_locked
	if locked and state != State.closed and State != State.closing:
		call_deferred("start_close")

func set_opened(new_opened):
	opened = new_opened
	if sprite and not locked and opened and state != State.open and state != State.opening:
		call_deferred("start_open")
	
func _on_Detect_body_entered(body):
	if body.is_in_group("players"):
		players_in_area += 1

func _on_Detect_body_exited(body):
	if body.is_in_group("players"):
		players_in_area -= 1

func start_open():
	state = State.opening
	sprite.play("opening")
	shape.disabled = true
		
func start_close():
	state = State.closing
	sprite.play("opening", true)
	shape.disabled = false
		
func finish_open():
	state = State.open
	sprite.animation = "open"
	shape.disabled = true
		
func finish_close():
	state = State.closed
	sprite.animation = "closed"
	shape.disabled = false
