extends Control

onready var CharacterPanel = $CharacterPanel
onready var Inventory = $Inventory

func open(player):
	Inventory.open(player)
	CharacterPanel.open(player)
	show()

func close():
	Inventory.close()
	CharacterPanel.close()
	hide()
