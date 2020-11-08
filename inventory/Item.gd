extends TextureRect
class_name InventoryItem

var itemIcon
var itemImage
var itemName
var itemLabel
var itemValue
var itemSlot
var handNode
var slotType
var level
var stats
var picked = false
var rarity = 0
var texture2rect

var randomness = 0.1

var rng = RandomNumberGenerator.new()

func _init(_itemName, _itemLabel, _itemTexture, _itemImage, _itemSlot, _itemValue, _slotType, _handNode, _luck, _stats, _level):
	rng.randomize();
	self.itemName = _itemName
	self.itemLabel = _itemLabel
	self.itemValue = _itemValue
	self.itemSlot = _itemSlot
	self.handNode = _handNode
	self.itemImage = _itemImage
	self.slotType = _slotType
	self.level = _level
	self.stats = deep_copy(_stats)
	
	var r = rng.randi_range(0, 1000/_luck - 1)
	if r == 0:
		self.rarity = Global.ItemRarity.LEGENDARY # 1% bei luck = 10 | 100% bei luck = 1000 | 0.1% bei luck = 1
	elif r > 0 and r <= 3:
		self.rarity = Global.ItemRarity.EPIC # 3% epic
	elif r > 3 and r <= 13:
		self.rarity = Global.ItemRarity.RARE # 10% rare
	elif r > 13 and r <= 38:
		self.rarity = Global.ItemRarity.COMMON # 25% common
	else:
		self.rarity = Global.ItemRarity.NORMAL # 61% normal
	
	var damageFactor = 1
	var speedFactor = 1
	var spreadFactor = 1
	var waitFactor = 1
	
	var armorFactor = 1
	
	var valueFactor = 1
	
	match rarity:
		Global.ItemRarity.COMMON:
			damageFactor = 1.2
			speedFactor = 1.1
			spreadFactor = 0.9
			waitFactor = 0.95
			
			armorFactor = 1.2
			
			valueFactor = 1.9
			
		Global.ItemRarity.RARE:
			damageFactor = 1.5
			speedFactor = 1.2
			spreadFactor = 0.8
			waitFactor = 0.9
			
			armorFactor = 1.4
			
			valueFactor = 2.4
			
		Global.ItemRarity.EPIC:
			damageFactor = 1.8
			speedFactor = 1.3
			spreadFactor = 0.7
			waitFactor = 0.8
			
			armorFactor = 1.7
			
			valueFactor = 6
			
		Global.ItemRarity.LEGENDARY:
			damageFactor = 2.2
			speedFactor = 1.5
			spreadFactor = 0.5
			waitFactor = 0.7
			
			armorFactor = 2
			
			valueFactor = 12

	damageFactor = damageFactor * (1 + rng.randf_range(-randomness, randomness))
	speedFactor = damageFactor * (1 + rng.randf_range(-randomness, randomness))
	spreadFactor = spreadFactor * (1 + rng.randf_range(-randomness, randomness))
	waitFactor = waitFactor * (1 + rng.randf_range(-randomness, randomness))
	armorFactor = armorFactor * (1 + rng.randf_range(-randomness, randomness))
	valueFactor = valueFactor * (1 + rng.randf_range(-randomness, randomness))
	
	if stats.has("damage"):
		stats["damage"] = round_to_dec(float(stats["damage"]) * damageFactor * (1 + level / 10), 0)
	if stats.has("speed"):
		stats["speed"] = round_to_dec(float(stats["speed"]) * speedFactor, 0)
	if stats.has("spread"):
		stats["spread"] = round_to_dec(float(stats["spread"]) * spreadFactor, 3)
	if stats.has("waittime"):
		stats["waittime"] = round_to_dec(float(stats["waittime"]) * waitFactor, 3)
	if stats.has("armor"):
		stats["armor"] = round_to_dec(float(stats["armor"]) * armorFactor * (1 + level / 10), 1)
	
	itemValue = round_to_dec(itemValue * valueFactor, 0)
		
	texture = _itemTexture
	self.set_size(texture.get_size())
	
	match slotType:
		Global.SlotType.SLOT_FEET, Global.SlotType.SLOT_PANTS:
			texture2rect = TextureRect.new()
			texture2rect.texture = _itemTexture
			add_child(texture2rect)
	
	mouse_filter = Control.MOUSE_FILTER_PASS
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func pickItem():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	picked = true

func putItem():
	var maxSize = 30
	var fieldSize = 34
	if texture.get_size().x > maxSize or texture.get_size().y > maxSize:
		rect_scale.x = maxSize / max(texture.get_size().x, texture.get_size().y)
		rect_scale.y = maxSize / max(texture.get_size().x, texture.get_size().y)
	
	rect_position.x = (fieldSize - texture.get_size().x * rect_scale.x) / 2
	rect_position.y = (fieldSize - texture.get_size().y * rect_scale.y) / 2
	if texture2rect:
		
		#texture2rect.rect_position = rect_position
	
		match slotType:
			Global.SlotType.SLOT_FEET:
				rect_position.y = rect_position.y + 4
				texture2rect.rect_position.y = - 8
			Global.SlotType.SLOT_PANTS:
				rect_position.y = rect_position.y + 3
				texture2rect.rect_position.y = - 6
			
	
	mouse_filter = Control.MOUSE_FILTER_PASS
	picked = false
	
	
	
	

static func deep_copy(v):
	var t = typeof(v)

	if t == TYPE_DICTIONARY:
		var d = {}
		for k in v:
			d[k] = deep_copy(v[k])
		return d

	elif t == TYPE_ARRAY:
		var d = []
		d.resize(len(v))
		for i in range(len(v)):
			d[i] = deep_copy(v[i])
		return d

	elif t == TYPE_OBJECT:
		if v.has_method("duplicate"):
			return v.duplicate()
		else:
			print("Found an object, but I don't know how to copy it!")
			return v

	else:
		# Other types should be fine,
		# they are value types (except poolarrays maybe)
		return v
		
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
