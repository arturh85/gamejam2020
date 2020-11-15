extends Node2D

const COLORS = preload("res://items/colors.gd") # static
var item

signal on_removed(what)


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var r = str(rng.randi_range(1, 3))
	$AudioStreamPlayer.stream = load("res://data/sounds/player/pickup" + r + ".wav")
	
	
	
func set_item_properties(i):
	
	var hn = null
	if i.has("handNode"):
		hn = i.handNode
	item = InventoryItem.new(i.id, i.name, i.label, i.description, i.image, i.icon, i.value, i.slotType, hn, i.level, i.rarity, i.stats)

	position.x = i.x
	position.y = i.y
	
	$Light2D.color = COLORS.itemColor(int(item.rarity))
	
	match item.slotType:
		Global.SlotType.SLOT_FEET:
			$Sprite.offset.y = -4
			$Sprite.texture = load("res://data/images/items/" + item.icon)
			$DoubleSprite.offset.y = 4
			$DoubleSprite.texture = load("res://data/images/items/" + item.icon)
		Global.SlotType.SLOT_PANTS:
			$Sprite.offset.y = -3
			$Sprite.texture = load("res://data/images/items/" + item.icon)
			$DoubleSprite.offset.y = 3
			$DoubleSprite.texture = load("res://data/images/items/" + item.icon)
		_:
			$Sprite.texture = load("res://data/images/items/" + item.icon)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Item_body_entered(body):
	if body.is_in_group("players"):
		body.pickup_item(item)
		body.rpc_id(1, 'pickup_item', item.id)
		$CollectPlayer.play("Collect")
		yield(get_tree().create_timer(1), "timeout")
		hide()
		emit_signal("on_removed", self)
		queue_free()
		
