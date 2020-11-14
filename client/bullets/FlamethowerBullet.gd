extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	$"../AnimatedSprite".frame = rng.randi_range(0, 1)
	yield(get_tree().create_timer(0.5), "timeout")
	$"../../".remove_child(self)
	queue_free()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
