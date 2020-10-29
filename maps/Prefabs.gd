extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var objects = Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func getObjects():	
	var tablechair = loadFile("table+chairs")
	objects.append(tablechair)
	return objects


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func loadFile(prefab):
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
