extends Node2D

var bar_red = preload("res://assets/barHorizontal_red.png")
var bar_green = preload("res://assets/barHorizontal_green.png")
var bar_yellow = preload("res://assets/barHorizontal_yellow.png")

onready var healthbar = $HealthBar

func _ready():
	hide()
	pass
	
func _process(delta):
	global_rotation = 0
	
func update_healthbar(value, max_health):
	healthbar.max_value = max_health
	healthbar.texture_progress = bar_green
	if value < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_yellow
	if value < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_red
	if value < healthbar.max_value:
		show()
	else:
		hide()
	healthbar.value = value
