var mapSize
var cellSize
var rnd = RandomNumberGenerator.new()
var map
var tmpMap
var circ
var gID
var wID
var nID
var gThere = false

func _init(size, cell, circular, tilemap, tMap, groundID, wallID, noID):
	mapSize = size
	cellSize = cell
	rnd.randomize()
	map = tilemap
	tmpMap = tMap
	circ = circular
	gID = groundID
	wID = wallID
	nID = noID
	
	
	for x in range(mapSize):
		tmpMap.append([])
		for y in range(mapSize):
			tmpMap[x].append(wID)
	
	for x in range(mapSize):
		map.append([])
		for y in range(mapSize):
			if circular:
				if (x - (mapSize / 2)) * (x - (mapSize / 2)) + (y - (mapSize / 2)) * (y - (mapSize / 2)) < mapSize * mapSize / 4:
					map[x].append(wID)
				else:
					map[x].append(nID)
			else:
				if x >= 0 and x < mapSize and y >= 0 and y < mapSize:
					map[x].append(wID)
				else:
					map[x].append(nID)
					
					
			
	
func generateMap(fl_loops, fl_iterations, fl_directed, r_loops, r_iterations, r_directed, mapBoundary):
	
	var start = Vector2(mapSize / 2, mapSize / 2)
	var end = start

	for r in range(fl_loops):
		if gThere:
			start = getStartPos()
		end = randomWalk(start, fl_iterations, mapBoundary, fl_directed)
		
	for r in range(r_loops):
		if gThere:
			start = getStartPos()
		end = randomWalk(start, r_iterations, mapBoundary, r_directed)
		
	for x in range(mapSize):
		for y in range(mapSize):
			if tmpMap[x][y] == gID:
				map[x][y] = gID
				
	return end

	
func randomWalk(start, iterations, mapBoundary, directed):
	var itr = 0
	var endpoint = start
	
	var walker = start
	
	var last_direction = Vector2(0, 0)
	# random walk
	while itr < iterations:
		
		var random_direction = GetRandomDirection()
		if directed > 0:
			if random_direction == -last_direction:
				continue
			elif random_direction.x != last_direction.x or random_direction.y != last_direction.y:
				if rnd.randi()%directed != 0:
					continue
			
		else:
			if random_direction == last_direction:
				if rnd.randi()%(-directed) != 0:
					continue
			
		last_direction = random_direction
		
		var rwx = walker.x + random_direction.x - mapSize / 2
		var rwy = walker.y + random_direction.y - mapSize / 2
		
		var swx = walker.x + random_direction.x 
		var swy = walker.y + random_direction.y 
		var r = mapSize / 2 - mapBoundary
		
		if (circ and (rwx*rwx + rwy*rwy < r*r)) or ((not circ) and swx >= mapBoundary and swx < mapSize - mapBoundary and swy >= mapBoundary and swy < mapSize - mapBoundary):
				
			if not gThere:
				gThere = true
				
			walker += random_direction
			tmpMap[walker.x][walker.y] = gID
			itr += 1
			
			endpoint.x = walker.x
			endpoint.y = walker.y
			
	return endpoint

func GetRandomDirection():
	var directions = [[-1, 0], [1, 0], [0, 1], [0, -1]]
	var direction = directions[rnd.randi()%4]
	return Vector2(direction[0], direction[1])

func getStartPos():
	
	while true:
		var x = rnd.randi()%(mapSize)
		var y = rnd.randi()%(mapSize)
		
		if tmpMap[x][y] == gID:
			return Vector2(x, y)
			
