extends Node2D

const IO = preload("res://maps/RandomMapIO.gd") # static
const ADD = preload("res://maps/RandomMapCreators.gd") # static
const rf = preload("res://maps/RandomMapFunctions.gd")
var RF # instance
const mg = preload("res://maps/RandomMapTiles.gd")
var MG # instance

var rnd = RandomNumberGenerator.new()

var endpoint = Vector2.ZERO
var map = Array()
var tmpMap = Array()
var prefabs = {}

enum TILE {
	MOBSPAWN = -5,
	SPAWN = -4,
	ITEM = -3,
	PREFAB = -2,
	NO = -1,
	WALL = 0,
	GROUND = 1
}

var settings

var circular
var size
var cell
var safeRadius
var spawnRadius
var spawnPoints
var RWIterations
var RWLoops
var mapBoundary

func _ready():
	
	settings = IO.readLevel("level1")
	
	size = int(settings["map"]["Size"])
	RWIterations = int(settings["map"]["RWIterations"])
	RWLoops = int(settings["map"]["RWLoops"])
	safeRadius = int(settings["map"]["SafeSpawnRadius"])
	spawnRadius = int(settings["map"]["SpawnRadius"])
	spawnPoints = int(settings["map"]["SpawnPoints"])
	mapBoundary = int(settings["map"]["MapBoundary"])
	circular = int(settings["map"]["Circular"]) == 1
	cell = $TileMap.cell_size.x
	
	RF = rf.new(size, cell, tmpMap)
	MG = mg.new(size, cell, circular, map, tmpMap, TILE.GROUND, TILE.WALL, TILE.NO)
	
	rnd.randomize()
	
	createMap()
	
	createSpawns()
	
	createPrefabs()
		
	createItems()
	
	createMobs()
			

func createMap():
	
	endpoint = MG.generateMap(RWLoops, RWIterations, mapBoundary)
	
	for x in range(size):
		for y in range(size):			
			if map[x][y] != TILE.NO:
				$TileMap.set_cell(- size / 2 + x, - size / 2  + y, map[x][y]);
			
	$TileMap.update_bitmask_region()
	
	
func createSpawns():
	
	for i in range(spawnPoints):
		ADD.spawn($SpawnPoints, String(i), RF.b2p(RF.getValidRandomPosInDistance(TILE.GROUND, endpoint, spawnRadius, TILE.SPAWN)))
		
		
func createPrefabs():
	
	for prefab in settings["prefabs"]:
		prefabs[prefab] = IO.readPrefab(prefab)
		for i in range(settings["prefabs"][prefab]):
			ADD.object($Interior, size, cell, tmpMap, prefabs[prefab], RF.getValidRandomPosInArray(TILE.GROUND, prefabs[prefab], TILE.PREFAB))


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
			ADD.mob($Mobs, mob, RF.b2p(RF.getValidRandomPosOutDistance(TILE.GROUND, endpoint, safeRadius, TILE.MOBSPAWN)))
			
