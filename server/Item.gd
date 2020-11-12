extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var itemName = ""
export var luck = 1
export var level = 1
var stats

func _ready():
	var s = ItemStats.new()
	s.generate(itemName, luck, level, position)
	stats = s.itemDict
	return
	
