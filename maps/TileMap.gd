extends TileMap

var rnd = RandomNumberGenerator.new()
var blockSize = 4
var blocksXY = 50
var endpoint = Vector2.ZERO
var map = Array()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum TILE {
	No = -1,
	AutoTile = 0,
	Wall = 13
}

# Called when the node enters the scene tree for the first time.
func _ready():
	generateMap()
			
	createSpawn()
	
	createItems()
			

	
	
func generateMap():
	
	for x in range(blockSize * blocksXY):
		map.append([])
		print(x)
		for y in range(blockSize * blocksXY):
			if (x - (blockSize * blocksXY / 2)) * (x - (blockSize * blocksXY / 2)) + (y - (blockSize * blocksXY / 2)) * (y - (blockSize * blocksXY / 2)) < blockSize * blocksXY * blockSize * blocksXY / 4:
				map[x].append(TILE.Wall)
			else:
				map[x].append(TILE.No)
					
					
			
	create_random_path()
	
	for bX in range(blocksXY):
		for bY in range(blocksXY):
			
			for cX in range(blockSize):
				for cY in range(blockSize):
					var x = bX * blockSize + cX
					var y =  bY * blockSize + cY
			
					if map[x][y] != TILE.No:
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
	
	for blobs in range(20):
		addMob("BlobMob", getValidRandomPos())
		
	for cop in range(10):
		addMob("TimeCop", getValidRandomPos())
	
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
	
	
func getValidRandomPos():
	
	while true:
		var x = rnd.randi()%(blockSize*blocksXY)
		var y = rnd.randi()%(blockSize*blocksXY)
		
		if map[x][y] == TILE.AutoTile:
			var xx = (- blockSize * blocksXY / 2 + x) * self.cell_size.x + self.cell_size.x / 2
			var yy = (- blockSize * blocksXY / 2 + y) * self.cell_size.y + self.cell_size.y / 2
			
			return Vector2(xx, yy)
		
func create_random_path():
	rnd.randomize()
	
	var tmpMap = Array()

	for x in range(blockSize * blocksXY):
		tmpMap.append([])
		for y in range(blockSize * blocksXY):
			tmpMap[x].append(TILE.Wall)
	
	var max_iterations = 3000
	var itr = 0
	
	var walker = Vector2.ZERO
	walker.x = blockSize * blocksXY / 2
	walker.y = blockSize * blocksXY / 2
	
	# random walk
	while itr < max_iterations:
		
		var random_direction = GetRandomDirection()
		
		var rwx = walker.x + random_direction.x - blockSize * blocksXY / 2
		var rwy = walker.y + random_direction.y - blockSize * blocksXY / 2
		if rwx*rwx + rwy*rwy < blockSize * blocksXY * blockSize * blocksXY / 4:
				
				walker += random_direction
				tmpMap[walker.x][walker.y] = TILE.AutoTile
				itr += 1
	
	itr = 0
	walker = Vector2.ZERO
	walker.x = blockSize * blocksXY / 2
	walker.y = blockSize * blocksXY / 2
	
	# random walk
	while itr < max_iterations:
		
		var random_direction = GetRandomDirection()
		
		var rwx = walker.x + random_direction.x - blockSize * blocksXY / 2
		var rwy = walker.y + random_direction.y - blockSize * blocksXY / 2
		if rwx*rwx + rwy*rwy < blockSize * blocksXY * blockSize * blocksXY / 4:
				
				walker += random_direction
				tmpMap[walker.x][walker.y] = TILE.AutoTile
				itr += 1
				endpoint.x = walker.x
				endpoint.y = walker.y
	
	for x in range(blockSize * blocksXY):
		for y in range(blockSize * blocksXY):
			if tmpMap[x][y] == TILE.AutoTile:
				map[x][y] = TILE.AutoTile
				#for px in range(2):
				#	for py in range(2):
				#		var nx = x - 1 + px
				#		var ny = y - 1 + py
				#		if nx >= 0 and nx < blockSize * blocksXY and  ny >= 0 and ny < blockSize * blocksXY:
				#			map[nx][ny] = TILE.AutoTile
	
					

func GetRandomDirection():
	var directions = [[-1, 0], [1, 0], [0, 1], [0, -1]]
	var direction = directions[rnd.randi()%4]
	return Vector2(direction[0], direction[1])
