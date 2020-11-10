extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



master var puppet_pos = Vector2()
master var puppet_velocity = Vector2()
master var puppet_rotation = 0 
master var puppet_motion = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_player_name(player_name, id):
	
	$Name.text = str(id) + ": " + name + " - " + player_name
	$Name.rect_position.x = 10
	$Name.rect_position.y = (id-1) * 20 + 10

master func update_flashlight(visible):
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
