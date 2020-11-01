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
var cell = 64

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

export (PackedScene) var random_level = load("res://maps/Random.tscn")
var randomLevel = {}

func _ready():
	
	if settings.has("portals"):
		for portal in settings["portals"]:
			Logger.info("generated random " + portal)
			randomLevel[portal] = random_level.instance()
			randomLevel[portal].init(portal, randi())
		
func getRandomLevel(name):
	return randomLevel[name]
	
func init(levelName, rseed):
	Logger.info("random.init (master: " + str(is_network_master()) + ")")
	settings = IO.readLevel(levelName)
	size = int(settings["map"]["Size"])
	
	RF = rf.new(size, cell, tmpMap)
	MG = mg.new(size, cell, int(settings["map"]["Circular"]), map, tmpMap, TILE.GROUND, TILE.WALL, TILE.NO)
	
	rnd.seed = rseed
	
	createMap()
	
	createSpawns()
	
	createZeroZero()
	
	createPrefabs()
		
	createItems()
	
	createMobs()
	
	
func createMap():
	
	startpoint = MG.generateMap(int(settings["map"]["Floors"]["Loops"]), int(settings["map"]["Floors"]["Iterations"]), int(settings["map"]["Floors"]["Directed"]), int(settings["map"]["Rooms"]["Loops"]), int(settings["map"]["Rooms"]["Iterations"]), int(settings["map"]["Rooms"]["Directed"]), int(settings["map"]["MapBoundary"]))
	
	createPortals()
	
	var tm0 = ""
	var m = 0
	var modVal = 0
	var maxVal = Array()
	var minVal = Array()
	for tm in settings["map"]["TileMaps"]:
		var v = int(settings["map"]["TileMaps"][tm])
		minVal.append(modVal)
		modVal = modVal + v
		maxVal.append(modVal)
		
		if tm0 == "":
			tm0 = tm
		var tileMap = TileMap.new()
		tileMap.name = tm
		tileMap.cell_size.x = cell
		tileMap.cell_size.y = cell
		tileMap.modulate = settings["map"]["Color"]
		tileMap.light_mask = 2
		tileMap.occluder_light_mask = 2
		tileMap.z_index = -1
		tileMap.tile_set = load("res://" + settings["map"]["Tileset"]) 
		self.add_child(tileMap)
		
		for x in range(size):
			for y in range(size):
				if m == 0 and map[x][y] != TILE.NO:
					get_node(tm0).set_cell(- size / 2 + x, - size / 2  + y, map[x][y])
				if map[x][y] == TILE.WALL:
					 get_node(tm).set_cell(- size / 2 + x, - size / 2  + y, TILE.WALL + m)
				
		m = m+1
		
	for tm in settings["map"]["TileMaps"]:
		get_node(tm).update_bitmask_region()
	
	for x in range(size):
		for y in range(size):			
			if map[x][y] == TILE.WALL:
				var r = rnd.randi()%modVal
				m = 0
				for tm in settings["map"]["TileMaps"]:
					if r < minVal[m] or r >= maxVal[m]:
						get_node(tm).set_cell(- size / 2 + x, - size / 2  + y, -1)
					m = m + 1
					
	
	
func createSpawns():
	
	for i in range(int(settings["map"]["SpawnPoints"])):
		var pos =  RF.b2p(RF.getValidRandomPosInDistance(TILE.GROUND, startpoint, int(settings["map"]["SpawnRadius"]), TILE.SPAWN))
		#var pos = RF.b2p(Vector2(size / 2 , size / 2))
		ADD.spawn($SpawnPoints, String(i), pos)
		
		
func createPortals():
	
	ADD.portal($Items, RF.b2p(startpoint))
	tmpMap[startpoint.x][startpoint.y] = TILE.PORTAL
	for x in range (-1, 2):
		for y in range (-1, 2):
			map[startpoint.x + x][startpoint.y + y] = TILE.GROUND
	
	if not settings.has("portals"):
		return
		
	for portal in settings["portals"]:
		var pos = RF.getValidRandomPosOutDistance(TILE.GROUND, startpoint, size / 3, TILE.PORTAL)
		ADD.portal($Items, RF.b2p(pos), false, portal, settings["portals"][portal])
		for x in range (-1, 2):
			for y in range (-1, 2):
				map[pos.x + x][pos.y + y] = TILE.GROUND

	
func createPrefabs():
	
	if not settings.has("prefabs"):
		return
		
	for prefab in settings["prefabs"]:
		var fab = IO.readPrefab(prefab)
		for i in range(settings["prefabs"][prefab]):
			ADD.object($Interior, size, cell, tmpMap, fab, RF.getValidRandomPosInArray(TILE.GROUND, fab, TILE.PREFAB))


func createItems():
	
	if not settings.has("items"):
		return
		
	if settings["items"].has("weapons"):
		for weapon in settings["items"]["weapons"]:
			var items = float(settings["items"]["weapons"][weapon])
			for i in range(int(floor(items))):
				ADD.weapon($Items/Weapons, weapon, RF.b2p(RF.getValidRandomPos(TILE.GROUND, TILE.ITEM)))
			
			if items-int(items) > 0:
				var num = int(1/(items-int(items)))
				var r = rnd.randi()%num
				if r == 0:
					ADD.weapon($Items/Weapons, weapon, RF.b2p(RF.getValidRandomPos(TILE.GROUND, TILE.ITEM)))
				

	if settings["items"].has("ammo"):
		for ammo in settings["items"]["ammo"]:
			for i in range(int(settings["items"]["ammo"][ammo])):
				ADD.ammo($Items/Ammo, ammo, RF.b2p(RF.getValidRandomPos(TILE.GROUND, TILE.ITEM)))

	if settings["items"].has("powerups"):
		for powerup in settings["items"]["powerups"]:
			for i in range(int(settings["items"]["powerups"][powerup])):
				ADD.powerup($Items/Powerups, powerup, RF.b2p(RF.getValidRandomPos(TILE.GROUND, TILE.ITEM)))

	
func createMobs():
	
	if not settings.has("mobs"):
		return
		
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
		
		
		
var colors = [Color(1.0, 0.0, 0.0, 1.0),
		  Color(0.0, 1.0, 0.0, 1.0),
		  Color(0.0, 0.0, 1.0, 0.0)]
