extends Panel;

var slotList = Array()
var holdingItem = null
var itemOffset = Vector2(0, 0)
var current_player: Player = null
onready var tooltip = get_node("../Tooltip")
onready var characterPanel = get_node("../CharacterPanel")

func _ready():
	var slots = get_node("SlotsContainer/Slots");
	for _i in range(Global.INVENTORY_SLOT_COUNT):
		var slot = InventoryItemSlot.new()
		slot.connect("mouse_entered", self, "mouse_enter_slot", [slot])
		slot.connect("mouse_exited", self, "mouse_exit_slot", [slot])
		slot.connect("gui_input", self, "slot_gui_input", [slot])
		slotList.append(slot)
		slots.add_child(slot)

	for i in range(Global.CHARACTER_SLOT_COUNT):
		if i == 0:
			continue;
		var panelSlot = characterPanel.slots[i]
		if panelSlot:
			panelSlot.connect("mouse_entered", self, "mouse_enter_slot", [panelSlot])
			panelSlot.connect("mouse_exited", self, "mouse_exit_slot", [panelSlot])
			panelSlot.connect("gui_input", self, "slot_gui_input", [panelSlot])
			

func open(player):
	current_player = player
	for i in range(Global.INVENTORY_SLOT_COUNT):
		if player.inventory_slots[i]:
			slotList[i].putItem(player.inventory_slots[i])
		else:
			slotList[i].removeItem()
		slotList[i].connect("on_update_slot", self, "on_update_slot", [i])
		
func close():
	current_player = null
	for i in range(Global.INVENTORY_SLOT_COUNT):
		slotList[i].disconnect("on_update_slot", self, "on_update_slot")	
	
func on_update_slot(item, idx):
	if current_player:
		current_player.inventory_slots[idx] = item
			
func mouse_enter_slot(_slot : InventoryItemSlot):
	if _slot.item:
		tooltip.display(_slot.item, get_global_mouse_position())

func mouse_exit_slot(_slot : InventoryItemSlot):
	if tooltip.visible:
		tooltip.hide()

func slot_gui_input(event : InputEvent, slot : InventoryItemSlot):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if holdingItem:
				if slot.slotType != Global.SlotType.SLOT_DEFAULT:
					if Global.canEquip(holdingItem, slot.slotType):
						if !slot.item:
							slot.equipItem(holdingItem, false)
							holdingItem = null
						else:
							var tempItem = slot.item
							slot.pickItem()
							tempItem.rect_global_position = event.global_position - itemOffset
							slot.equipItem(holdingItem, false)
							holdingItem = tempItem
				elif slot.item:
					var tempItem = slot.item;
					slot.pickItem();
					tempItem.rect_global_position = event.global_position - itemOffset
					slot.putItem(holdingItem)
					holdingItem = tempItem
				else:
					slot.putItem(holdingItem)
					holdingItem = null
			elif slot.item:
				holdingItem = slot.item
				itemOffset = event.global_position - holdingItem.rect_global_position
				slot.pickItem();
				holdingItem.rect_global_position = event.global_position - itemOffset
		elif event.button_index == BUTTON_RIGHT && !event.pressed:
			if slot.slotType != Global.SlotType.SLOT_DEFAULT:
				if slot.item:
					var freeSlot = getFreeSlot()
					if freeSlot:
						var item = slot.item
						slot.removeItem()
						freeSlot.setItem(item)
			else:
				if slot.item:
					var itemSlotType = slot.item.slotType
					var panelSlot = characterPanel.getSlotByType(slot.item.slotType)
					if itemSlotType == Global.SlotType.SLOT_QUICK1:
						if panelSlot[0].item && panelSlot[1].item:
							var panelItem = panelSlot[0].item
							panelSlot[0].removeItem()
							var slotItem = slot.item
							slot.removeItem()
							slot.setItem(panelItem)
							panelSlot[0].setItem(slotItem)
							pass
						elif !panelSlot[0].item && panelSlot[1].item || !panelSlot[0].item && !panelSlot[1].item:
							var tempItem = slot.item
							slot.removeItem()
							panelSlot[0].equipItem(tempItem)
						elif panelSlot[0].item && !panelSlot[1].item:
							var tempItem = slot.item
							slot.removeItem()
							panelSlot[1].equipItem(tempItem)
							pass
					else:
						if panelSlot.item:
							var panelItem = panelSlot.item
							panelSlot.removeItem()
							var slotItem = slot.item
							slot.removeItem()
							slot.setItem(panelItem)
							panelSlot.setItem(slotItem)
						else:
							var tempItem = slot.item
							slot.removeItem()
							panelSlot.equipItem(tempItem)

func _input(event : InputEvent):
	if holdingItem && holdingItem.picked && event is InputEventMouse:
		holdingItem.rect_global_position = event.global_position - itemOffset

func getFreeSlot():
	for slot in slotList:
		if !slot.item:
			return slot


func _on_SortRarityButton_pressed():
	var items = Array();
	for slot in slotList:
		if slot.item:
			items.append(slot.item);
			slot.removeItem();
	items.sort_custom(self, "sortItemsByRarity");
	for i in range(items.size()):
		var item = items[i]
		var slot = slotList[i]
		slot.setItem(item)

func sortItemsByRarity(itemA : InventoryItem, itemB : InventoryItem):
	return itemA.rarity > itemB.rarity

func _on_AddItemButton_pressed():
	var slot = getFreeSlot()
	if slot:
		var item = ItemFactory.generate_random()
		slot.setItem(item)
