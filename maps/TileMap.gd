extends TileMap

var rnd = RandomNumberGenerator.new()
var blockSize = 5
var blocksXY = 5
var map = Array()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	generateMap()
			
			
			
	self.update_bitmask_region()

	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func generateMap():
	
	for x in range(blockSize * blocksXY):
		map.append([])
		for y in range(blockSize * blocksXY):
			map[x].append(13)
					
					
			
	_create_random_path()
	
	for bX in range(blocksXY):
		for bY in range(blocksXY):
			
			for cX in range(blockSize):
				for cY in range(blockSize):
					var x = bX * blocksXY + cX
					var y =  bY * blocksXY + cY
			
					self.set_cell(- blockSize * blocksXY / 2 + x, - blockSize * blocksXY / 2  + y, map[x][y]);
					
			
			
	
	var spawn = Position2D.new()
	spawn.name = "0"
	var foundSpawn = false
	while not foundSpawn:
		var x = rnd.randi()%(blockSize*blocksXY)
		var y = rnd.randi()%(blockSize*blocksXY)
		
		if map[x][y] == 0:
			spawn.position.x = (- blockSize * blocksXY / 2 + x) * self.cell_size.x + self.cell_size.x / 2
			spawn.position.y = (- blockSize * blocksXY / 2 + y) * self.cell_size.y + self.cell_size.y / 2
			foundSpawn = true
		print(x)
		print(y)
		
	get_node("../SpawnPoints").add_child(spawn)

func _create_random_path():
	rnd.randomize()
	
	var max_iterations = 1000
	var itr = 0
	
	var walker = Vector2.ZERO
	
	while itr < max_iterations:
		
		# Perform random walk
		# 1- choose random direction
		# 2- check that direction is in bounds
		# 3- move in that direction
		var random_direction = GetRandomDirection()
		
		if (walker.x + random_direction.x >= 0 and 
			walker.x + random_direction.x < blockSize * blocksXY  and
			walker.y + random_direction.y >= 0 and
			walker.y + random_direction.y < blockSize * blocksXY):
				
				walker += random_direction
				map[walker.x][walker.y] = 0
				itr += 1
	

func GetRandomDirection():
	var directions = [[-1, 0], [1, 0], [0, 1], [0, -1]]
	var direction = directions[rnd.randi()%4]
	return Vector2(direction[0], direction[1])
