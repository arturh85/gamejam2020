extends Control

onready var grid = $Panel/Grid

var level_tilemap

func open():
	if not level_tilemap:
		var tilemap = get_node("../../Level/TileMap")
		level_tilemap = tilemap.duplicate()
		var grid_size = grid.get_rect().size
		level_tilemap.position = Vector2(grid_size.x / 2 - 50, grid_size.y / 2)
		level_tilemap.scale = Vector2(0.3, 0.3)
		grid.add_child(level_tilemap)
	show()

func close():
	hide()
	if level_tilemap:
		level_tilemap.queue_free()
		level_tilemap = null
