extends Control

onready var CharacterPanel = $CharacterPanel
onready var Inventory = $Inventory

func open(player):
	Inventory.player = player
	CharacterPanel.player = player
	show()

func close():
	hide()
