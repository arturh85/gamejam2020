extends TileMap

var rnd = RandomNumberGenerator.new()
var blockSize = 2
var blocksXY = 2
var safeRadius = 20

var RWIterations = 3000
var RWLoops = 2

var endpoint = Vector2.ZERO
var map = Array()
var tmpMap = Array()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum TILE {
	NO = -1,
	WALL = 0,
	GROUND = 1
}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	rnd.randomize()
	
	createMap()
	
	createPrefabs()
			
	createSpawn()
	
	createItems()
			

func createPrefabs():
	
	var objects = get_node("../Prefabs").getObjects()
	
	for i in range (30):
		for j in range (objects.size()):
			placeObject(objects[j])
	
func placeObject(o):
	var pos = getValidRandomPosInBlocksArray(o)

	for x in range(o.size()):
		for y in range(o[0].size()):
			var xx = (- blockSize * blocksXY / 2 + x + pos.x) * self.cell_size.x + self.cell_size.x / 2
			var yy = (- blockSize * blocksXY / 2 + y + pos.y) * self.cell_size.y + self.cell_size.y / 2
			
			var sprite = Sprite.new()
			print(pos.x)
			print(pos.y)
			if o[x][y] != "-1":
				sprite.texture = load("res://data/images/bricks/interior/" + o[x][y] + ".png")
				sprite.position.x = 0#xx
				sprite.position.y =0 #yy
				get_node("../Interior").add_child(sprite)
	
func createMap():
	
	for x in range(blockSize * blocksXY):
		tmpMap.append([])
		for y in range(blockSize * blocksXY):
			tmpMap[x].append(TILE.WALL)
	
	for x in range(blockSize * blocksXY):
		map.append([])
		print(x)
		for y in range(blockSize * blocksXY):
			if (x - (blockSize * blocksXY / 2)) * (x - (blockSize * blocksXY / 2)) + (y - (blockSize * blocksXY / 2)) * (y - (blockSize * blocksXY / 2)) < blockSize * blocksXY * blockSize * blocksXY / 4:
				map[x].append(TILE.WALL)
			else:
				map[x].append(TILE.NO)
					
					
			
	generateMap()
	
	for bX in range(blocksXY):
		for bY in range(blocksXY):
			
			for cX in range(blockSize):
				for cY in range(blockSize):
					var x = bX * blockSize + cX
					var y =  bY * blockSize + cY
			
					if map[x][y] != TILE.NO:
						self.set_cell(- blockSize * blocksXY / 2 + x, - blockSize * blocksXY / 2  + y, map[x][y]);
					
			
	self.update_bitmask_region()
			
			
func createSpawn():
	
	var spawn = Position2D.new()
	spawn.name = "0"
	spawn.position.x = (- blockSize * blocksXY / 2 + endpoint.x) * self.cell_size.x + self.cell_size.x / 2
	spawn.position.y = (- blockSize * blocksXY / 2 + endpoint.y) * self.cell_size.y + self.cell_size.y / 2
		
	get_node("../SpawnPoints").add_child(spawn)

func createItems():
	
	addWeapon("Plasmagun", getValidRandomPos())
	addWeapon("MachineGun", getValidRandomPos())
	addWeapon("Railgun", getValidRandomPos())
	addWeapon("Rifle", getValidRandomPos())
	addWeapon("Crossbow", getValidRandomPos())
	
	var endpointPos = Vector2((endpoint.x - blockSize * blocksXY / 2) *  self.cell_size.x, (endpoint.y - blockSize * blocksXY / 2) *  self.cell_size.y)
	
	for blobs in range(0):
		addMob("BlobMob", getValidRandomPosOutDistance(endpointPos, safeRadius * self.cell_size.x))
		
	for cop in range(0):
		addMob("TimeCop", getValidRandomPosOutDistance(endpointPos, safeRadius * self.cell_size.x))
	
func addWeapon(name, pos):
	var item = Position2D.new()
	var scn = load("res://items/weapons/" + name + ".tscn")
	var object = scn.instance()
	object.position = pos
	get_node("../Weapons").add_child(object)
	
	
func addMob(name, pos):
	var item = Position2D.new()
	var scn = load("res://actors/" + name + ".tscn")
	var object = scn.instance()
	object.position = pos
	get_node("../Mobs").add_child(object)
	
	
func getValidRandomPosOutDistance(pos, distance):
	
	while true:
		var p = getValidRandomPos()
		if (pos.x-p.x)*(pos.x-p.x) + (pos.y-p.y)*(pos.y-p.y) < distance*distance:
			getValidRandomPos()
		else:
			return p
		
func getValidRandomPos():
	
	while true:
		var x = rnd.randi()%(blockSize*blocksXY)
		var y = rnd.randi()%(blockSize*blocksXY)
		
		if map[x][y] == TILE.GROUND:
			var xx = (- blockSize * blocksXY / 2 + x) * self.cell_size.x + self.cell_size.x / 2
			var yy = (- blockSize * blocksXY / 2 + y) * self.cell_size.y + self.cell_size.y / 2
			
			return Vector2(xx, yy)
			
func getValidRandomPosInBlocks():
	
	while true:
		var x = rnd.randi()%(blockSize*blocksXY)
		var y = rnd.randi()%(blockSize*blocksXY)
		
		if map[x][y] == TILE.GROUND:
			return Vector2(x, y)
			
func getValidRandomPosInBlocksArray(ids):
	
	while true:
		var x = rnd.randi()%(blockSize*blocksXY)
		var y = rnd.randi()%(blockSize*blocksXY)
		
		var valid = true
		for xx in range(ids.size()):
			for yy in range(ids[0].size()):
				if x + xx >= blockSize*blocksXY or y + yy >= blockSize*blocksXY or (ids[xx][yy] != "-1" and int(map[x + xx][y + yy]) != TILE.GROUND):
					valid = false
					break
					
		if valid:
			return Vector2(x, y)
		
func generateMap():
	
	for r in range(RWLoops):
		randomWalk()

	for x in range(blockSize * blocksXY):
		for y in range(blockSize * blocksXY):
			if tmpMap[x][y] == TILE.GROUND:
				map[x][y] = TILE.GROUND

	
func randomWalk():
	var itr = 0
	
	var walker = Vector2.ZERO
	walker.x = blockSize * blocksXY / 2
	walker.y = blockSize * blocksXY / 2
	
	# random walk
	while itr < RWIterations:
		
		var random_direction = GetRandomDirection()
		
		var rwx = walker.x + random_direction.x - blockSize * blocksXY / 2
		var rwy = walker.y + random_direction.y - blockSize * blocksXY / 2
		if rwx*rwx + rwy*rwy < blockSize * blocksXY * blockSize * blocksXY / 4:
				
			walker += random_direction
			tmpMap[walker.x][walker.y] = TILE.GROUND
			itr += 1
			
			endpoint.x = walker.x
			endpoint.y = walker.y
	

func GetRandomDirection():
	var directions = [[-1, 0], [1, 0], [0, 1], [0, -1]]
	var direction = directions[rnd.randi()%4]
	return Vector2(direction[0], direction[1])
