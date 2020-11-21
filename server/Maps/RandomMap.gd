extends Node2D

const IO = preload("res://Maps/RandomMapIO.gd") # static
const rf = preload("res://Maps/RandomMapFunctions.gd")
var RF # instance
const mg = preload("res://Maps/RandomMapGenerator.gd")
var MG # instance
var portal_scene = load("res://portal.tscn")
var item_scene = load("res://Item.tscn")
var mob_scene = load("res://Mob.tscn")

var rnd = RandomNumberGenerator.new()

var startpoint = Vector2.ZERO
var map = Array()
var tmpMap = Array()
var settings
var size
var cell = 64
var rndseed

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

var mapDict = {}
	
func init(levelName, rseed):
		
	settings = IO.readLevel(levelName)
	size = int(settings["map"]["Size"])
	
	rndseed = rseed
	rnd.seed = rseed
	
	RF = rf.new(rnd, size, cell, tmpMap)
	MG = mg.new(rnd, size, cell, int(settings["map"]["Circular"]), map, tmpMap, TILE.GROUND, TILE.WALL, TILE.NO)
	
	startpoint = MG.generateMap(int(settings["map"]["Floors"]["Loops"]), int(settings["map"]["Floors"]["Iterations"]), int(settings["map"]["Floors"]["Directed"]), int(settings["map"]["Rooms"]["Loops"]), int(settings["map"]["Rooms"]["Iterations"]), int(settings["map"]["Rooms"]["Directed"]), int(settings["map"]["MapBoundary"]))
	
	
	var p = portal_scene.instance()
	p.randomLevelTemplate = ""
	p.createInstance = true
	p.back = true
	p.color = "ff0000"
	p.position = RF.b2p(startpoint)
	$Portals.add_child(p)
	
	tmpMap[startpoint.x][startpoint.y] = TILE.PORTAL
	for x in range (-1, 2):
		for y in range (-1, 2):
			map[startpoint.x + x][startpoint.y + y] = TILE.GROUND
	
	var pid = 0
	if settings.has("portals"):
		for portal in settings["portals"]:
			var pos = RF.getValidRandomPosOutDistance(TILE.GROUND, startpoint, size / 3, TILE.PORTAL)			
			p = portal_scene.instance()
			p.randomLevelTemplate = portal
			p.createInstance = true
			p.back = false
			p.color = settings["portals"][portal]
			p.position = RF.b2p(pos)
			$Portals.add_child(p)
			for x in range (-1, 2):
				for y in range (-1, 2):
					map[pos.x + x][pos.y + y] = TILE.GROUND
			pid = pid +1
	
	
	for i in range(int(settings["map"]["SpawnPoints"])):
		var node = Node2D.new()
		node.name = str(i)
		node.position = RF.b2p(RF.getValidRandomPosInDistance(TILE.GROUND, startpoint, int(settings["map"]["SpawnRadius"]), TILE.SPAWN))
		$SpawnPoints.add_child(node)
	
	
	#mapObject["prefabs"] = {}
	#if settings.has("prefabs"):		
	#	for prefab in settings["prefabs"]:
	#		var fab = IO.readPrefab(prefab)
	#		for i in range(settings["prefabs"][prefab]):
	#			var pos = RF.getValidRandomPosInArray(TILE.GROUND, fab, TILE.PREFAB)
	#			mapObject["prefabs"][i] = {}
	#			mapObject["prefabs"][i]["x"] = RF.b2p(pos.x)
	#			mapObject["prefabs"][i]["y"] = RF.b2p(pos.y)
	#			mapObject["prefabs"][i]["size"] = size
	#			mapObject["prefabs"][i]["cell"] = size
	#			mapObject["prefabs"][i]["object"] = fab
				
	
	if settings.has("items"):
		if settings["items"].has("equipment"):
			for item in settings["items"]["equipment"]:
				var items = float(settings["items"]["equipment"][item]["quantity"])
				for i in range(int(floor(items))):
					var itm = item_scene.instance()
					itm.itemName = item
					itm.luck = settings["items"]["equipment"][item]["luck"]
					itm.level = settings["items"]["equipment"][item]["level"]
					itm.position = RF.b2p(RF.getValidRandomPos(TILE.GROUND, TILE.ITEM))
					$Items.add_child(itm)
					
				if items-int(items) > 0:
					var num = int(1/(items-int(items)))
					var r = rnd.randi()%num
					if r == 0:
						var itm = item_scene.instance()
						itm.itemName = item
						itm.luck = settings["items"]["equipment"][item]["luck"]
						itm.level = settings["items"]["equipment"][item]["level"]
						itm.position = RF.b2p(RF.getValidRandomPos(TILE.GROUND, TILE.ITEM))
						$Items.add_child(itm)
						
	#if settings.has("mobs"):
	#	for mob in settings["mobs"]:
	#		for i in range(int(settings["mobs"][mob])):
	#			var pos = RF.b2p(RF.getValidRandomPosOutDistance(TILE.GROUND, startpoint, int(settings["map"]["SafeSpawnRadius"]), TILE.MOBSPAWN))
	#			mapObject["mobs"][i]["name"] = mob
				
	mapDict["map"] = map
	mapDict["cell"] = cell
	mapDict["color"] = settings["map"]["Color"]
	mapDict["tileset"] = settings["map"]["Tileset"]
