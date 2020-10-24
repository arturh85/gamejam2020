extends HBoxContainer

var player_labels = {}
var player_colors = [ Color(0, 0.72, 0.56), Color(0.72, 0, 0.41) , Color(0.13, 0.69, 0.29), Color(0.85, 0.58, 0.07) ]

func _process(_delta):
	var rocks_left = $"../../Rocks".get_child_count()
	if rocks_left == 0:
		var winner_name = ""
		var winner_score = 0
		for p in player_labels:
			if player_labels[p].score > winner_score:
				winner_score = player_labels[p].score
				winner_name = player_labels[p].name

		$"../Winner".set_text("THE WINNER IS:\n" + winner_name)
		$"../Winner".show()


sync func increase_score(for_who):
	assert(for_who in player_labels)
	var pl = player_labels[for_who]
	pl.score += 1
	pl.label.set_text(pl.name + ": " + str(pl.score) + "\n")


func add_player(id, new_player_name):
	var l = Label.new()
	l.set_text(new_player_name + ": 0" + "\n")
	l.set_h_size_flags(SIZE_EXPAND_FILL)
	var font = DynamicFont.new()
	font.set_size(18)
	font.set_font_data(preload("res://montserrat.otf"))
	l.add_color_override("font_color", player_colors[(id - 1) % player_colors.size()])
	l.add_font_override("font", font)
	add_child(l)

	player_labels[id] = { name = new_player_name, label = l, score = 0 }


func _ready():
	$"../Winner".hide()
	set_process(true)


func _on_exit_game_pressed():
	gamestate.end_game()
