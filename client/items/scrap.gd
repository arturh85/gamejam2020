extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var quantity
var scrapId

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_scrap_properties(scrapProperties):
	
	var path = "res://data/images/scrap/"
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		
		var fileNames = Array()
		
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.substr(file_name.length() - 3, 3) == "png":
				fileNames.append(file_name)
			file_name = dir.get_next()
	
		var texture = path + fileNames[scrapProperties.randImage%fileNames.size()]
		$Sprite.texture = load(texture)
	
	position.x = scrapProperties.x
	position.y = scrapProperties.y
	quantity = scrapProperties.quantity
	scrapId = scrapProperties.id
	
	rotation_degrees = scrapProperties.rotation_degrees


func _on_Scrap_body_entered(body):
	
	if body.is_in_group("players"):
		body.pickup_scrap(quantity)
		body.rpc_id(1, 'pickup_scrap', scrapId)
		$CollectPlayer.play("Collect")
		yield(get_tree().create_timer(0.5), "timeout")
		hide()
		emit_signal("on_removed", self)
		queue_free()
