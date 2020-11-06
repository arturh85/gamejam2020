extends Node
class_name Global

enum SlotType {
	SLOT_DEFAULT = 0,
	SLOT_HELMET,
	SLOT_ARMOR,
	SLOT_FEET,
	SLOT_NECK,
	SLOT_PANTS,
	SLOT_GLOVES,
	SLOT_RHAND,
	SLOT_QUICK1,
	SLOT_QUICK2,
	SLOT_QUICK3,
	SLOT_QUICK4,
}

const CHARACTER_SLOT_COUNT = SlotType.SLOT_QUICK4 + 1
const INVENTORY_SLOT_COUNT = 45;

enum ItemRarity {
	NORMAL = 0,
	COMMON,
	RARE,
	EPIC,
	LEGENDARY
}

const RarityColor = {
	ItemRarity.NORMAL: {
		"background": "#808080",
		"border": "#cccccc"
	},
	ItemRarity.COMMON: {
		"background": "#1b51d1",
		"border": "#2000ff"
	},
	ItemRarity.RARE: {
		"background": "#ffdf1d",
		"border": "#CCB217"
	},
	ItemRarity.EPIC: {
		"background": "#a200ff",
		"border": "#CCB217"
	},
	ItemRarity.LEGENDARY: {
		"background": "#ec5300",
		"border": "#BC4200"
	}
}

static func canEquip(item, slotType):
	var quick1 = SlotType.SLOT_QUICK1
	var quick2 = SlotType.SLOT_QUICK2
	var quick3 = SlotType.SLOT_QUICK3
	var quick4 = SlotType.SLOT_QUICK4
	return item.slotType == slotType ||  \
		(item.slotType == quick1 && (slotType == quick1 || slotType == quick2 || slotType == quick3 || slotType == quick4))
