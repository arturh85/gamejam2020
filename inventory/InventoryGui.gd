extends Control

onready var CharacterPanel = $CharacterPanel
onready var Inventory = $Inventory

func open(player):
	Inventory.update_slots(player)
	CharacterPanel.update_slots(player)
	show()

func close():
	hide()
