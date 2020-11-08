extends NinePatchRect
class_name InventoryTooltip

onready var itemNameLabel = get_node("Item Name");
onready var itemValueLabel = get_node("Item Value");
#onready var itemImage = get_node("Item Image");

var colors = preload("res://items/colors.gd")

func _ready():
	
	itemNameLabel.rect_position = Vector2(-50, 15)
	itemNameLabel.rect_size.x = 210
	
	itemValueLabel.rect_position = Vector2(-50, 40)
	itemValueLabel.rect_size.x = 210
	
	#itemImage.position.x = 160
	
	

func display(_item : InventoryItem, mousePos : Vector2):
	visible = true;
	
	#var p = "res://data/images/items/" + _item.itemImage
	#itemImage.texture = load(p)
	
	itemNameLabel.bbcode_enabled = true
	itemNameLabel.bbcode_text = _item.itemLabel
	itemNameLabel.modulate = colors.itemColor(_item.rarity)
	
	var lines = 6
	var text = ""
	for stat in _item.stats:
		text = text + stat.capitalize() + ": " + String(_item.stats[stat]) + "\r\n"
		lines = lines + 1
	
	text = text + "\r\nItem level: " + String(_item.level) + "\r\nValue: " + String(_item.itemValue)
	
	itemValueLabel.set_text(text)
	
	rect_size = Vector2(250, lines * 17)
	rect_global_position = Vector2(mousePos.x + 20, mousePos.y + 20);
