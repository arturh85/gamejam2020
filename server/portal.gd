extends Node2D


export var targetSceneName = ""
export var randomLevelTemplate = ""
export var createInstance = true
export var back = false
export var color = "00f3ff"
export var triggerName = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	
sync func activate_portal(playerID):
	print("portal activated")
	
	if back:
		$"/root/gamestate".init_map(playerID, $"/root/gamestate".startLevel)
	elif targetSceneName:
		$"/root/gamestate".init_map(playerID, targetSceneName)
		
		
#func _process(delta):
#	pass
