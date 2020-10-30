extends Node2D

const IO = preload("res://maps/RandomMapIO.gd") # static
const ADD = preload("res://maps/RandomMapCreators.gd") # static
const rf = preload("res://maps/RandomMapFunctions.gd")
var RF # instance
const mg = preload("res://maps/RandomMapTiles.gd")
var MG # instance

var rnd = RandomNumberGenerator.new()

var startpoint = Vector2.ZERO
var map = Array()
var tmpMap = Array()
var settings
var size
var cell

enum TILE {
	SPECIAL = -6,
	MOBSPAWN = -5,
	SPAWN = -4,
	ITEM = -3,
	PREFAB = -2,
	NO = -1,
	WALL = 0,
	GROUND = 1
}


func _ready():
	
	settings = IO.readLevel("level1")
	size = int(settings["map"]["Size"])
	cell = $TileMap.cell_size.x
	
	RF = rf.new(size, cell, tmpMap)
	MG = mg.new(size, cell, int(settings["map"]["Circular"]), map, tmpMap, TILE.GROUND, TILE.WALL, TILE.NO)
	
	rnd.randomize()
	
	createMap()
	
	createPortal()
	
	createSpawns()
	
	createZeroZero()
	
	createPrefabs()
		
	createItems()
	
	createMobs()

func createMap():
	
	startpoint = MG.generateMap(int(settings["map"]["Floors"]["Loops"]), int(settings["map"]["Floors"]["Iterations"]), int(settings["map"]["Floors"]["Directed"]), int(settings["map"]["Rooms"]["Loops"]), int(settings["map"]["Rooms"]["Iterations"]), int(settings["map"]["Rooms"]["Directed"]), int(settings["map"]["MapBoundary"]))
	
	for x in range(size):
		for y in range(size):			
			if map[x][y] != TILE.NO:
				$TileMap.set_cell(- size / 2 + x, - size / 2  + y, map[x][y]);
			
	$TileMap.update_bitmask_region()
	
	
func createSpawns():
	
	for i in range(int(settings["map"]["SpawnPoints"])):
		var pos =  RF.b2p(RF.getValidRandomPosInDistance(TILE.GROUND, startpoint, int(settings["map"]["SpawnRadius"]), TILE.SPAWN))
		#var pos = RF.b2p(Vector2(size / 2 , size / 2))
		ADD.spawn($SpawnPoints, String(i), pos)
		
		
func createPortal():
	
	ADD.portal($Items, RF.b2p(startpoint))
	tmpMap[startpoint.x][startpoint.y] = TILE.SPECIAL

	
func createPrefabs():
	
	for prefab in settings["prefabs"]:
		var fab = IO.readPrefab(prefab)
		for i in range(settings["prefabs"][prefab]):
			ADD.object($Interior, size, cell, tmpMap, fab, RF.getValidRandomPosInArray(TILE.GROUND, fab, TILE.PREFAB))


func createItems():
	
	for weapon in settings["items"]["weapons"]:
		for i in range(int(settings["items"]["weapons"][weapon])):
			ADD.weapon($Items/Weapons, weapon, RF.b2p(RF.getValidRandomPos(TILE.GROUND, TILE.ITEM)))

	for ammo in settings["items"]["ammo"]:
		for i in range(int(settings["items"]["ammo"][ammo])):
			ADD.ammo($Items/Ammo, ammo, RF.b2p(RF.getValidRandomPos(TILE.GROUND, TILE.ITEM)))

	for powerup in settings["items"]["powerups"]:
		for i in range(int(settings["items"]["powerups"][powerup])):
			ADD.powerup($Items/Powerups, powerup, RF.b2p(RF.getValidRandomPos(TILE.GROUND, TILE.ITEM)))

	
func createMobs():
	
	for mob in settings["mobs"]:
		for i in range(int(settings["mobs"][mob])):
			ADD.mob($Mobs, mob, RF.b2p(RF.getValidRandomPosOutDistance(TILE.GROUND, startpoint, int(settings["map"]["SafeSpawnRadius"]), TILE.MOBSPAWN)))
			
func createZeroZero():
	
	var sprite = Sprite.new()
	sprite.texture = load("res://data/images/bricks/zerozero.png")
	sprite.modulate = "333333"
	sprite.light_mask = 2
	sprite.position = RF.b2p(Vector2(size / 2, size / 2))
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
	light.position = RF.b2p(Vector2(size / 2, size / 2))
	self.add_child(light)
	
	tmpMap[size / 2][size / 2] = TILE.SPECIAL
		
