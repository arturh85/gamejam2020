static func itemColor(rarity):
	match rarity:
		Global.ItemRarity.NORMAL:
			return "ffffff"
		Global.ItemRarity.COMMON:
			return "00ff00"
		Global.ItemRarity.RARE:
			return "0000ff"
		Global.ItemRarity.EPIC:
			return "a200ff"
		Global.ItemRarity.LEGENDARY:
			return "ff7e00"
