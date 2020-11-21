extends Node2D


const random_map = preload("res://Maps/RandomMap.tscn")

export var targetSceneName = ""
export var randomLevelTemplate = ""
export var createInstance = true
export var back = false
export var color = "00f3ff"
export var triggerName = ""

var rndMap = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if randomLevelTemplate and createInstance:
		rndMap = random_map.instance()
		rndMap.init(randomLevelTemplate, randi())

	
sync func activate_portal(playerID):
	print("portal activated")
	
	if back:
		$"/root/gamestate".init_map(playerID, $"/root/gamestate".startLevel)
	elif targetSceneName:
		$"/root/gamestate".init_map(playerID, targetSceneName)
	elif randomLevelTemplate:
		$"/root/gamestate".init_random_map(playerID, rndMap)
		
		
