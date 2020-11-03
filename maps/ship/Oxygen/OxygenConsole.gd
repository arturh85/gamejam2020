extends Node2D

onready var room = $".."

func _process(delta):
	room.oxygen += 10 * delta
