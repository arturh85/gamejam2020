extends Node2D

enum TILE {
	PORTAL = -7,
	SPECIAL = -6,
	MOBSPAWN = -5,
	SPAWN = -4,
	ITEM = -3,
	PREFAB = -2,
	NO = -1,
	GROUND = 0,
	WALL = 1
}

func _ready():
	
	pass

var map
var mapDict
	
func init(mapName, tMap):
	
	self.name = mapName
	mapDict = tMap
	map = mapDict.map
	
	createTileMap()
		
	createZeroZero()
	
	
func createTileMap():
	
	var size = map.size()
	var tileMap = TileMap.new()
	tileMap.name = "TileMap"
	tileMap.cell_size.x = mapDict["cell"]
	tileMap.cell_size.y = mapDict["cell"]
	tileMap.modulate = "333333"
	tileMap.light_mask = 2
	tileMap.occluder_light_mask = 2
	tileMap.z_index = -1
	tileMap.tile_set = load("res://data/" + mapDict["tileset"]) 
	
	for x in range(size):
		for y in range(size):
			if map[x][y] != TILE.NO:
				tileMap.set_cell(- size / 2 + x, - size / 2  + y, map[x][y])
			if map[x][y] == TILE.WALL:
				tileMap.set_cell(- size / 2 + x, - size / 2  + y, TILE.WALL)
			
		
	tileMap.update_bitmask_region()
	
	$Navigation2D.add_child(tileMap)
	$Light2D.energy = float(mapDict["light"])
	$Light2D.color = mapDict["color"]

func createZeroZero():
	
	var sprite = Sprite.new()
	sprite.texture = load("res://data/images/bricks/zerozero.png")
	sprite.modulate = "333333"
	sprite.light_mask = 2
	sprite.position = Vector2.ZERO
	self.add_child(sprite)
	
	var light = Light2D.new()
	light.texture = load("res://data/images/lights/spot.png")
	light.light_mask = 2
	light.shadow_item_cull_mask = 2
	light.range_item_cull_mask = 2
	light.shadow_enabled = true
	light.color = "00ff00"
	light.energy = 2
	light.texture_scale = 2.5
	light.position = Vector2.ZERO
	self.add_child(light)
		
