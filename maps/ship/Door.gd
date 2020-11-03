extends Node2D

enum State {
	closed,
	opening,
	closing,
	open
}

var state = State.closed setget set_state

onready var sprite = $Sprite
onready var shape = $Body/Shape

export var locked = false setget set_locked
export var opened = false setget set_opened

var players_in_area = 0

signal on_state_changed

func _process(_delta):
	if players_in_area > 0 and state == State.closed and not locked:
		start_open()
	elif players_in_area <= 0 and state == State.open and not opened:
		start_close()
		
func _on_animation_finished():
	if is_processing():
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

remotesync func normal_click():
	set_opened(not opened)

func start_open():
	set_state(State.opening)
	shape.disabled = true
	emit_signal("on_state_changed", self)
		
func start_close():
	set_state(State.closing)
	shape.disabled = false
	emit_signal("on_state_changed", self)
		
func finish_open():
	set_state(State.open)
	shape.disabled = true
	emit_signal("on_state_changed", self)
		
func finish_close():
	set_state(State.closed)
	shape.disabled = false
	emit_signal("on_state_changed", self)

func set_state(new_state):
	state = new_state
	match state:
		State.open:
			sprite.animation = "open"
		State.opening:
			sprite.play("opening")
		State.closed:
			sprite.animation = "closed"
		State.closing:
			sprite.play("opening", true)
			
			
	
