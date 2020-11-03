extends Panel

var slots = Array();
var player

func _ready():
	slots.resize(512);
	slots.insert(Global.SlotType.SLOT_HELMET, get_node("Left/SlotHelmet"));
	slots.insert(Global.SlotType.SLOT_ARMOR, get_node("Left/SlotArmor"));
	slots.insert(Global.SlotType.SLOT_FEET, get_node("Left/SlotFeet"));
	slots.insert(Global.SlotType.SLOT_NECK, get_node("Left/SlotNeck"));

	slots.insert(Global.SlotType.SLOT_RING, get_node("Right/SlotRing"));
	slots.insert(Global.SlotType.SLOT_RING2, get_node("Right/SlotRing2"));
	slots.insert(Global.SlotType.SLOT_LHAND, get_node("Right/SlotLHand"));
	slots.insert(Global.SlotType.SLOT_RHAND, get_node("Right/SlotRHand"));

	slots.insert(Global.SlotType.SLOT_QUICK1, get_node("Quick/SlotQuick1"));
	slots.insert(Global.SlotType.SLOT_QUICK2, get_node("Quick/SlotQuick2"));
	slots.insert(Global.SlotType.SLOT_QUICK3, get_node("Quick/SlotQuick3"));
	slots.insert(Global.SlotType.SLOT_QUICK4, get_node("Quick/SlotQuick4"));

func getSlotByType(type):
	if type == Global.SlotType.SLOT_RING:
		return [slots[Global.SlotType.SLOT_RING], slots[Global.SlotType.SLOT_RING2]];
	if type == Global.SlotType.SLOT_LHAND:
		return [slots[Global.SlotType.SLOT_LHAND], slots[Global.SlotType.SLOT_QUICK1], slots[Global.SlotType.SLOT_QUICK2], slots[Global.SlotType.SLOT_QUICK3], slots[Global.SlotType.SLOT_QUICK4]];

	return slots[type];

func getItemByType(type):
	return slots[type].item;
