extends Panel

var slots := Array()
var current_player: Player = null

func open(player: Player):
	current_player = player
	for i in range(Global.CHARACTER_SLOT_COUNT-1):
		if player.character_slots[i+1]:
			slots[i+1].putItem(player.character_slots[i+1])
		else:
			slots[i+1].removeItem()
		slots[i+1].connect("on_update_slot", self, "on_update_slot", [i+1])
			
func close():
	current_player = null
	for i in range(Global.CHARACTER_SLOT_COUNT-1):
		slots[i+1].disconnect("on_update_slot", self, "on_update_slot")
	
	
func on_update_slot(item, idx):
	if current_player:
		current_player.set_character_slot(idx, item)
	

func _ready():
	slots.resize(512);
	slots.insert(Global.SlotType.SLOT_HELMET, get_node("Left/SlotHelmet"));
	slots.insert(Global.SlotType.SLOT_ARMOR, get_node("Left/SlotArmor"));
	slots.insert(Global.SlotType.SLOT_FEET, get_node("Left/SlotFeet"));
	slots.insert(Global.SlotType.SLOT_NECK, get_node("Left/SlotNeck"));

	slots.insert(Global.SlotType.SLOT_PANTS, get_node("Right/SlotPants"));
	slots.insert(Global.SlotType.SLOT_GLOVES, get_node("Right/SlotGloves"));
	slots.insert(Global.SlotType.SLOT_RHAND, get_node("Right/SlotRHand"));

	slots.insert(Global.SlotType.SLOT_QUICK1, get_node("Quick/SlotQuick1"));
	slots.insert(Global.SlotType.SLOT_QUICK2, get_node("Quick/SlotQuick2"));
	slots.insert(Global.SlotType.SLOT_QUICK3, get_node("Quick/SlotQuick3"));
	slots.insert(Global.SlotType.SLOT_QUICK4, get_node("Quick/SlotQuick4"));

func getSlotByType(type):
	if type == Global.SlotType.SLOT_RING:
		return [slots[Global.SlotType.SLOT_RING], slots[Global.SlotType.SLOT_RING2]];
	if type == Global.SlotType.SLOT_QUICK1:
		return [slots[Global.SlotType.SLOT_QUICK1], slots[Global.SlotType.SLOT_QUICK2], slots[Global.SlotType.SLOT_QUICK3], slots[Global.SlotType.SLOT_QUICK4]];

	return slots[type];

func getItemByType(type):
	return slots[type].item;
