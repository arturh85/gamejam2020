extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var rng = RandomNumberGenerator.new()
var randImage
export var quantity = 1
export var randomQuantity = true
export var maxQuantity = 20
var id

# Called when the node enters the scene tree for the first time.
func _ready():
	id = get_instance_id()
	rng.randomize()
	pass # Replace with function body.

	if randomQuantity:
		quantity = rng.randi()%maxQuantity
		
	rotation_degrees = rng.randi()%360
	randImage =  rng.randi()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
