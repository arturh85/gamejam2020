extends Control

const DEFAULT_PORT = 10567

onready var cursor = $Cursor

func _ready():
	# Called every time the node is added to the scene.
	gamestate.connect("connection_failed", self, "_on_connection_failed")
	gamestate.connect("connection_succeeded", self, "_on_connection_success")
	gamestate.connect("player_list_changed", self, "refresh_lobby")
	gamestate.connect("game_ended", self, "_on_game_ended")
	gamestate.connect("game_error", self, "_on_game_error")
	# Set the player name according to the system username. Fallback to the path.
	if OS.has_environment("USERNAME"):
		$Connect/Name.text = OS.get_environment("USERNAME")
	else:
		var desktop_path = OS.get_system_dir(0).replace("\\", "/").split("/")
		$Connect/Name.text = desktop_path[desktop_path.size() - 2]
	if $Connect/Name.text == ".":
		$Connect/Name.text = "Player"
	
	$AnimationPlayer.play("Background")

	var roles = $CreatePlayer/RaceSelect
	roles.add_item("Cyborg")
	roles.add_item("Human")
	roles.add_item("Alien")
	
	var classes = $CreatePlayer/ClassSelect
	classes.add_item("Soldier")
	classes.add_item("Engineer")
	classes.add_item("Scientist")
	
	$CreatePlayer/Player/Hair.modulate = $CreatePlayer/HairColorButton.color
	$CreatePlayer/Player/Body.modulate = $CreatePlayer/SkinColorButton.color


func new_profile():
	$Connect.hide()
	$CreatePlayer.show()

func already_logged_in():
	$ErrorDialog.dialog_text = "Player " + $Connect/Name.text + " already logged in."
	$ErrorDialog.popup_centered_minsize()

func _on_join_pressed():
	if $Connect/Name.text == "":
		$Connect/ErrorLabel.text = "Invalid name!"
		return

	var ip = $Connect/IPAddress.text
	if not ip.is_valid_ip_address():
		$Connect/ErrorLabel.text = "Invalid IP address!"
		return

	$Connect/ErrorLabel.text = ""

		
	gamestate.player_name = $Connect/Name.text
	var client = NetworkedMultiplayerENet.new()
	client.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(client)

	


func _on_connection_success():
	pass

func _on_connection_failed():
	$Connect/ErrorLabel.set_text("Connection failed.")
	cursor.update_cursor()


func _on_game_ended():
	cursor.update_cursor()
	show()
	$Connect.show()
	$Players.hide()


func _on_game_error(errtxt):
	$ErrorDialog.dialog_text = errtxt
	$ErrorDialog.popup_centered_minsize()


func refresh_lobby():
	return



func _process(_delta):
	if not is_visible_in_tree():
		return
	if Input.is_action_just_pressed("mute"):
		AudioServer.set_bus_mute(1, not AudioServer.is_bus_mute(1))
		
		



func _on_HairColorButton_color_changed(color):
	$CreatePlayer/Player/Hair.modulate = color


func _on_SkinColorButton_color_changed(color):
	$CreatePlayer/Player/Body.modulate = color


func _on_Start_pressed():
	gamestate.create_character($CreatePlayer/Player/Body.modulate, $CreatePlayer/Player/Hair.modulate)
	
	
