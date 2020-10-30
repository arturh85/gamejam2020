extends TileMap

var rnd = RandomNumberGenerator.new()

var endpoint = Vector2.ZERO
var map = Array()
var tmpMap = Array()
var prefabs = {}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum TILE {
	PREFAB = -2
	NO = -1,
	WALL = 0,
	GROUND = 1
}

var settings

var circular
var blockSize
var blocksXY
var safeRadius
var RWIterations
var RWLoops
var mapBoundary
# Called when the node enters the scene tree for the first time.
func _ready():
	
	settings = readLevel("level1")
	
	rnd.randomize()
	
	createMap()
	
	createPrefabs()
			
	createSpawn()
	
	createItems()
	
	createMobs()
			

func createPrefabs():
	
	for prefab in settings["prefabs"]:
		addObject(prefab)
		for i in range(settings["prefabs"][prefab]):
			placeObject(prefabs[prefab])

	#var objects = get_node("../Prefabs").getObjects()
	
	#for i in range (30):
	#	for j in range (objects.size()):
	#		placeObject(objects[j])
	
func addObject(name):	
	prefabs[name] = readPrefab(name)


func placeObject(o):
	var pos = getValidRandomPosInBlocksArray(o)

	for y in range(o.size()):
		for x in range(o[0].size()):
			var xx = (- blockSize * blocksXY / 2 + x + pos.x) * self.cell_size.x + self.cell_size.x / 2
			var yy = (- blockSize * blocksXY / 2 + y + pos.y) * self.cell_size.y + self.cell_size.y / 2
			
			
			if o[y][x] != "-1":
				var sprite = Sprite.new()
				var body = StaticBody2D.new() 
				sprite.texture = load("res://data/images/bricks/interior/" + o[y][x] + ".png")
				sprite.modulate = "333333"
				sprite.light_mask = 2
				body.add_child(sprite)
				body.position.x = xx 
				body.position.y = yy 
				var poly = _create_collision_polygon(sprite.texture)
				poly.position.x = - self.cell_size.x / 2
				poly.position.y = - self.cell_size.x / 2
				body.add_child(poly)
				tmpMap[pos.x + x][pos.y + y] = TILE.PREFAB
				get_node("../Interior").add_child(body)
	
func createMap():
	
	blockSize = int(settings["map"]["BlockSize"])
	blocksXY = int(settings["map"]["NumberOfBlocks"])
	RWIterations = int(settings["map"]["RWIterations"])
	RWLoops = int(settings["map"]["RWLoops"])
	safeRadius = int(settings["map"]["SafeSpawnRadius"])
	mapBoundary = int(settings["map"]["MapBoundary"])
	circular = int(settings["map"]["Circular"]) == 1
	
	for x in range(blockSize * blocksXY):
		tmpMap.append([])
		for y in range(blockSize * blocksXY):
			tmpMap[x].append(TILE.WALL)
	
	for x in range(blockSize * blocksXY):
		map.append([])
		print(x)
		for y in range(blockSize * blocksXY):
			if circular:
				if (x - (blockSize * blocksXY / 2)) * (x - (blockSize * blocksXY / 2)) + (y - (blockSize * blocksXY / 2)) * (y - (blockSize * blocksXY / 2)) < blockSize * blocksXY * blockSize * blocksXY / 4:
					map[x].append(TILE.WALL)
				else:
					map[x].append(TILE.NO)
			else:
				if x >= 0 and x < blockSize * blocksXY and y >= 0 and y < blockSize * blocksXY:
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
	
	for i in range(4):
		var spawn = Position2D.new()
		spawn.name = String(i)
		var endpointPos = Vector2((endpoint.x - blockSize * blocksXY / 2) *  self.cell_size.x, (endpoint.y - blockSize * blocksXY / 2) *  self.cell_size.y)
		spawn.position = getValidRandomPosInDistance(endpointPos, 5 * self.cell_size.x)
		get_node("../SpawnPoints").add_child(spawn)

func createItems():
	
	for weapon in settings["items"]["weapons"]:
		for i in range(int(settings["items"]["weapons"][weapon])):
			addWeapon(weapon, getValidRandomPos())

	for ammo in settings["items"]["ammo"]:
		for i in range(int(settings["items"]["ammo"][ammo])):
			addAmmo(ammo, getValidRandomPos())

	for powerup in settings["items"]["powerups"]:
		for i in range(int(settings["items"]["powerups"][powerup])):
			addPowerup(powerup, getValidRandomPos())

	
func createMobs():
	
	var endpointPos = Vector2((endpoint.x - blockSize * blocksXY / 2) *  self.cell_size.x, (endpoint.y - blockSize * blocksXY / 2) *  self.cell_size.y)
	
	for mob in settings["mobs"]:
		for i in range(int(settings["mobs"][mob])):
			addMob(mob, getValidRandomPosOutDistance(endpointPos, safeRadius * self.cell_size.x))
			

func addWeapon(name, pos):
	var item = Position2D.new()
	var scn = load("res://items/weapons/" + name + ".tscn")
	var object = scn.instance()
	object.position = pos
	get_node("../Items/Weapons").add_child(object)
	
	
func addPowerup(name, pos):
	var item = Position2D.new()
	var scn = load("res://items/powerups/" + name + ".tscn")
	var object = scn.instance()
	object.position = pos
	get_node("../Items/Powerups").add_child(object)
	
	
func addAmmo(name, pos):
	var item = Position2D.new()
	var scn = load("res://items/ammo/" + name + ".tscn")
	var object = scn.instance()
	object.position = pos
	get_node("../Items/Ammo").add_child(object)
	
	
	
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
		
func getValidRandomPosInDistance(pos, distance):
	
	while true:
		var p = getValidRandomPos()
		if (pos.x-p.x)*(pos.x-p.x) + (pos.y-p.y)*(pos.y-p.y) > distance*distance:
			getValidRandomPos()
		else:
			return p
		
func getValidRandomPos():
	
	while true:
		var x = rnd.randi()%(blockSize*blocksXY)
		var y = rnd.randi()%(blockSize*blocksXY)
		
		if tmpMap[x][y] == TILE.GROUND:
			var xx = (- blockSize * blocksXY / 2 + x) * self.cell_size.x + self.cell_size.x / 2
			var yy = (- blockSize * blocksXY / 2 + y) * self.cell_size.y + self.cell_size.y / 2
			
			return Vector2(xx, yy)
			
func getValidRandomPosInBlocks():
	
	while true:
		var x = rnd.randi()%(blockSize*blocksXY)
		var y = rnd.randi()%(blockSize*blocksXY)
		
		if tmpMap[x][y] == TILE.GROUND:
			return Vector2(x, y)
			
func getValidRandomPosInBlocksArray(ids):
	
	while true:
		var x = rnd.randi()%(blockSize*blocksXY)
		var y = rnd.randi()%(blockSize*blocksXY)
		
		var valid = true
		for xx in range(ids[0].size()):
			for yy in range(ids.size()):
				if x + xx >= blockSize*blocksXY or y + yy >= blockSize*blocksXY:
					valid = false
					break
				elif int(tmpMap[x + xx][y + yy]) != TILE.GROUND:
					valid = false
					break
					
		if valid:
			return Vector2(x, y)
		
func generateMap():
	
	#var start = Vector2(rnd.randi()%(blockSize*blocksXY), rnd.randi()%(blockSize*blocksXY))
	var start = Vector2(blockSize * blocksXY / 2, blockSize * blocksXY / 2)

	for r in range(RWLoops):
		randomWalk(start)

	for x in range(blockSize * blocksXY):
		for y in range(blockSize * blocksXY):
			if tmpMap[x][y] == TILE.GROUND:
				map[x][y] = TILE.GROUND

	
func randomWalk(start):
	var itr = 0
	
	var walker = start
	
	var last_direction = Vector2(0, 0)
	# random walk
	while itr < RWIterations:
		
		var random_direction = GetRandomDirection()
		if random_direction == last_direction:
			continue
			
		last_direction = random_direction
		
		var rwx = walker.x + random_direction.x - blockSize * blocksXY / 2
		var rwy = walker.y + random_direction.y - blockSize * blocksXY / 2
		
		var swx = walker.x + random_direction.x 
		var swy = walker.y + random_direction.y 
		var r = blockSize * blocksXY / 2 - mapBoundary
		
		if (circular and (rwx*rwx + rwy*rwy < r*r)) or ((not circular) and swx >= mapBoundary and swx < blockSize * blocksXY - mapBoundary and swy >= mapBoundary and swy < blockSize * blocksXY - mapBoundary):
				
			walker += random_direction
			tmpMap[walker.x][walker.y] = TILE.GROUND
			itr += 1
			
			endpoint.x = walker.x
			endpoint.y = walker.y


func GetRandomDirection():
	var directions = [[-1, 0], [1, 0], [0, 1], [0, -1]]
	var direction = directions[rnd.randi()%4]
	return Vector2(direction[0], direction[1])


func _create_collision_polygon(texture):
	var bm = BitMap.new()
	bm.create_from_image_alpha(texture.get_data())
	var rect = Rect2(position.x, position.y, texture.get_width(), texture.get_height())
	var my_array = bm.opaque_to_polygons(rect)
	
	var my_polygon = Polygon2D.new()
	my_polygon.set_polygons(my_array)
	my_polygon.polygon = my_array
		
	var col_polygon = CollisionPolygon2D.new()
	col_polygon.set_polygon(my_polygon.polygons[0])
	#get_parent().get_node("Interior").add_child(col_polygon)
	#get_parent().get_node("CollisionPolygon2D")
	return col_polygon

func readLevel(filename):
	var file = File.new()
	if file.open("res://maps/levels/" + filename + ".json", file.READ) != OK:
		return
	var text = file.get_as_text()
	var json = JSON.parse(text)
	file.close()
	return json.result


func readPrefab(prefab):
	var csv_array = []
	var csv_file = File.new()
	csv_file.open("res://data/prefabs/" + prefab + ".txt", csv_file.READ)
	while not csv_file.eof_reached():
		var csv_row = []
		var csv_line = csv_file.get_line()
		for element in csv_line.split(" "):
			csv_row.append(element);
			# If you know the data will always be floats, use the following instead of the above.
			#csv_row.append(float(element))
		csv_array.append(csv_row);
	# Then you can access the array like this:
	# (Assuming there is something at that position)
	# To get the size of the data (assuming every row has the same size), you just do this:
	var csv_size_column = csv_array.size();
	var csv_size_row = csv_array[0].size();
	
	return csv_array
