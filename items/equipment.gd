extends Node2D

const COLORS = preload("res://items/colors.gd") # static
export var itemName = ""
var item: InventoryItem
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	item = ItemFactory.generate(itemName)
	
	$Light2D.color = COLORS.itemColor(item.rarity)
	
	match item.slotType:
		Global.SlotType.SLOT_FEET:
			$Sprite.offset.y = -4
			$Sprite.texture = load("res://data/images/items/" + item.itemImage)
			$DoubleSprite.offset.y = 4
			$DoubleSprite.texture = load("res://data/images/items/" + item.itemImage)
		Global.SlotType.SLOT_PANTS:
			$Sprite.offset.y = -3
			$Sprite.texture = load("res://data/images/items/" + item.itemImage)
			$DoubleSprite.offset.y = 3
			$DoubleSprite.texture = load("res://data/images/items/" + item.itemImage)
		_:
			$Sprite.texture = load("res://data/images/items/" + item.itemImage)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Item_body_entered(body):
	if body.is_in_group("players"):
		body.pickup_item(item)
		body.rpc('pickup_item', item)
		$CollectPlayer.play("Collect")
		yield(get_tree().create_timer(1), "timeout")
		hide()
		queue_free()
