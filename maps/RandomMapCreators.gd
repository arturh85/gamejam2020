static func spawn(node, name, position):
	var spawn = Position2D.new()
	spawn.name = name
	spawn.position = position
	node.add_child(spawn)
	
static func portal(node, position):
	var scn = load("res://items/portal.tscn")
	var object = scn.instance()
	object.position = position
	object.back = true
	node.add_child(object)
	
static func object(node, size, cell, tmpMap, o, pos):

	for y in range(o.size()):
		for x in range(o[0].size()):
			var xx = (- size / 2 + x + pos.x) * cell + cell / 2
			var yy = (- size / 2 + y + pos.y) * cell + cell / 2
			
			
			if o[y][x] != "-1":
				var sprite = Sprite.new()
				var body = StaticBody2D.new() 
				sprite.texture = load("res://data/images/bricks/interior/" + o[y][x] + ".png")
				sprite.modulate = "333333"
				sprite.light_mask = 2
				body.add_child(sprite)
				body.position.x = xx 
				body.position.y = yy 
				var poly = _create_collision_polygon(body.position, sprite.texture)
				poly.position.x = - cell / 2
				poly.position.y = - cell / 2
				body.add_child(poly)
				node.add_child(body)
	

static func _create_collision_polygon(position, texture):
	var bm = BitMap.new()
	bm.create_from_image_alpha(texture.get_data())
	var rect = Rect2(0, 0, texture.get_width(), texture.get_height())
	var my_array = bm.opaque_to_polygons(rect)
	
	var my_polygon = Polygon2D.new()
	my_polygon.set_polygons(my_array)
	my_polygon.polygon = my_array
		
	var col_polygon = CollisionPolygon2D.new()
	col_polygon.set_polygon(my_polygon.polygons[0])
	
	return col_polygon



static func weapon(node, name, pos):
	var scn = load("res://items/weapons/" + name + ".tscn")
	var object = scn.instance()
	object.position = pos
	node.add_child(object)
	
	
static func powerup(node, name, pos):
	var scn = load("res://items/powerups/" + name + ".tscn")
	var object = scn.instance()
	object.position = pos
	node.add_child(object)
	
	
static func ammo(node, name, pos):
	var scn = load("res://items/ammo/" + name + ".tscn")
	var object = scn.instance()
	object.position = pos
	node.add_child(object)
	
	
	
static func mob(node, name, pos):
	var scn = load("res://actors/" + name + ".tscn")
	var object = scn.instance()
	object.position = pos
	node.add_child(object)
	
