extends Node
class_name Global

enum SlotType {
	SLOT_DEFAULT = 0,
	SLOT_HELMET,
	SLOT_ARMOR,
	SLOT_FEET,
	SLOT_NECK,
	SLOT_RING,
	SLOT_RING2,
	SLOT_LHAND,
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
	MAGIC,
	RARE,
	LEGENDARY
}

const RarityColor = {
	ItemRarity.NORMAL: {
		"background": "#808080",
		"border": "#cccccc"
	},
	ItemRarity.MAGIC: {
		"background": "#1b51d1",
		"border": "#2000ff"
	},
	ItemRarity.RARE: {
		"background": "#ffdf1d",
		"border": "#CCB217"
	},
	ItemRarity.LEGENDARY: {
		"background": "#ec5300",
		"border": "#BC4200"
	}
}
