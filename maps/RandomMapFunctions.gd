var mapSize
var cellSize
var rnd = RandomNumberGenerator.new()
var tmpMap

func _init(size, cell, map):
	mapSize = size
	cellSize = cell
	rnd.randomize()
	tmpMap = map

func getValidRandomPosOutDistance(id, pos, distance, setID = -1):
	
	while true:
		var p = getValidRandomPos(id)
		if (pos.x-p.x)*(pos.x-p.x) + (pos.y-p.y)*(pos.y-p.y) < distance*distance:
			getValidRandomPos(id)
		else:
			if setID != -1:
				tmpMap[p.x][p.y] = setID
			return p


func getValidRandomPosOutDistance3x3(id, pos, distance, setID = -1):
	
	var ids = Array()
	for x in range(3):
		ids.append([])
		for y in range(3):
			if x == 1 and y == 1:
				ids[x].append(setID)
			else:
				ids[x].append("-1")
			
	while true:
		var p = getValidRandomPosInArray(id, ids, setID)
		if (pos.x-p.x)*(pos.x-p.x) + (pos.y-p.y)*(pos.y-p.y) < distance*distance:
			getValidRandomPosInArray(id, ids, setID)
		else:
			if setID != -1:
				tmpMap[p.x][p.y] = setID
			return p
		
	
func getValidRandomPosInDistance(id, pos, distance, setID = -1):
	
	while true:
		var p = getValidRandomPos(id)
		if (pos.x-p.x)*(pos.x-p.x) + (pos.y-p.y)*(pos.y-p.y) > distance*distance:
			getValidRandomPos(id)
		else:
			if setID != -1:
				tmpMap[p.x][p.y] = setID
			return p
		
func getValidRandomPos(id, setID = -1):
	
	while true:
		var x = rnd.randi()%(mapSize)
		var y = rnd.randi()%(mapSize)
		
		if tmpMap[x][y] == id:
			if setID != -1:
				tmpMap[x][y] = setID
			return Vector2(x, y)
			

func getValidRandomPosInArray(id, ids, setID = -1):
	
	while true:
		var x = rnd.randi()%(mapSize)
		var y = rnd.randi()%(mapSize)
		
		var valid = true
		for xx in range(ids[0].size()):
			for yy in range(ids.size()):
				if x + xx >= mapSize or y + yy >= mapSize:
					valid = false
					break
				elif int(tmpMap[x + xx][y + yy]) != id:
					valid = false
					break
					
		if valid:
			if setID != -1:
				for xx in range(ids[0].size()):
					for yy in range(ids.size()):
						if int(ids[yy][xx]) != -1:
							tmpMap[x + xx][y + yy] = setID
						
			return Vector2(x, y)
		

func b2p(v):

	var xx = (- mapSize / 2 + v.x) * cellSize + cellSize / 2
	var yy = (- mapSize / 2 + v.y) * cellSize + cellSize / 2
	
	return Vector2(xx, yy)
			
