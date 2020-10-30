extends TileMap

const IO = preload("res://maps/RandomMapIO.gd")
const ADD = preload("res://maps/RandomMapCreators.gd")
const rf = preload("res://maps/RandomMapFunctions.gd")
var RF
const mg = preload("res://maps/RandomMapTiles.gd")
var MG

var rnd = RandomNumberGenerator.new()

var endpoint = Vector2.ZERO
var map = Array()
var tmpMap = Array()
var prefabs = {}

enum TILE {
	PREFAB = -2
	NO = -1,
	WALL = 0,
	GROUND = 1
}

var settings

var circular
var size
var cell
var safeRadius
var RWIterations
var RWLoops
var mapBoundary

func _ready():
	
	settings = IO.readLevel("level1")
	
	size = int(settings["map"]["Size"])
	RWIterations = int(settings["map"]["RWIterations"])
	RWLoops = int(settings["map"]["RWLoops"])
	safeRadius = int(settings["map"]["SafeSpawnRadius"])
	mapBoundary = int(settings["map"]["MapBoundary"])
	circular = int(settings["map"]["Circular"]) == 1
	cell = self.cell_size.x
	
	RF = rf.new(size, self.cell_size.x, tmpMap)
	MG = mg.new(size, self.cell_size.x, circular, map, tmpMap, TILE.GROUND, TILE.WALL, TILE.NO)
	
	rnd.randomize()
	
	createMap()
	
	createPrefabs()
	
	createSpawns()
	
	createItems()
	
	createMobs()
			

func createMap():
	endpoint = MG.generateMap(RWLoops, RWIterations, mapBoundary)
	
	for x in range(size):
		for y in range(size):			
			if map[x][y] != TILE.NO:
				self.set_cell(- size / 2 + x, - size / 2  + y, map[x][y]);
			
	self.update_bitmask_region()
	
	
func createSpawns():
	var endpointPos = Vector2((endpoint.x - size / 2) * cell, (endpoint.y - size / 2) * cell)
	
	for i in range(4):
		var epos = RF.getValidRandomPosInDistance(TILE.GROUND, endpointPos, 5 * cell)
		ADD.spawn(get_node("../SpawnPoints"), String(i), epos)
		

func createPrefabs():
	
	for prefab in settings["prefabs"]:
		addObject(prefab)
		for i in range(settings["prefabs"][prefab]):
			var pos = RF.getValidRandomPosInBlocksArray(TILE.GROUND, prefabs[prefab])
			ADD.object(get_node("../Interior"), size, cell, tmpMap, prefabs[prefab], pos, TILE.GROUND, TILE.PREFAB)

	
func addObject(name):	
	prefabs[name] = IO.readPrefab(name)



func createItems():
	
	for weapon in settings["items"]["weapons"]:
		for i in range(int(settings["items"]["weapons"][weapon])):
			ADD.weapon(get_node("../Items/Weapons"), weapon, RF.getValidRandomPos(TILE.GROUND))

	for ammo in settings["items"]["ammo"]:
		for i in range(int(settings["items"]["ammo"][ammo])):
			ADD.ammo(get_node("../Items/Ammo"), ammo, RF.getValidRandomPos(TILE.GROUND))

	for powerup in settings["items"]["powerups"]:
		for i in range(int(settings["items"]["powerups"][powerup])):
			ADD.powerup(get_node("../Items/Powerups"), powerup, RF.getValidRandomPos(TILE.GROUND))

	
func createMobs():
	
	var endpointPos = Vector2((endpoint.x - size / 2) *  cell, (endpoint.y - size / 2) *  cell)
	
	for mob in settings["mobs"]:
		for i in range(int(settings["mobs"][mob])):
			ADD.mob(get_node("../Mobs"), mob, RF.getValidRandomPosOutDistance(TILE.GROUND, endpointPos, safeRadius * cell))
			
