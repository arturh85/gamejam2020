extends Node2D

const COLORS = preload("res://items/colors.gd") # static
export var itemName = ""
var item
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	item = readItemFile(itemName)
	var col = load("res://.tscn")
	$Light2D.color = COLORS.itemColor(item["Rarity"])

	if item["Type"] == "Shoes":
		$Sprite.offset.y = -4
		$Sprite.texture = load("res://data/images/items/" + item["Image"])
		$DoubleSprite.offset.y = 4
		$DoubleSprite.texture = load("res://data/images/items/" + item["Image"])
	elif item["Type"] == "Pants":
		$Sprite.offset.y = -7
		$Sprite.texture = load("res://data/images/items/" + item["Image"])
		$DoubleSprite.offset.y = 7
		$DoubleSprite.texture = load("res://data/images/items/" + item["Image"])
	else:
		$Sprite.texture = load("res://data/images/items/" + item["Image"])
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Item_body_entered(body):
	
	if body.is_in_group("players"):
		
		body.add_item(item)
		body.rpc('add_item', item)
		
			
		$CollectPlayer.play("Collect")
		yield(get_tree().create_timer(1), "timeout")
		hide()
		queue_free()

func readItemFile(itemName):
	var file = File.new()
	if file.open("res://data/items/" + itemName + ".json.tres", file.READ) != OK:
		return
	var text = file.get_as_text()
	var json = JSON.parse(text)
	file.close()
	return json.result
