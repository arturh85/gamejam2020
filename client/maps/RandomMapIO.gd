static func readLevel(filename):
	var file = File.new()
	if file.open("res://maps/levels/" + filename + ".json.tres", file.READ) != OK:
		return
	var text = file.get_as_text()
	var json = JSON.parse(text)
	file.close()
	return json.result


static func readPrefab(prefab):
	var csv_array = []
	var csv_file = File.new()
	csv_file.open("res://data/prefabs/" + prefab + ".tres", csv_file.READ)
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
