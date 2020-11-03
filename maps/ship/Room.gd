extends Area2D

enum RoomType {
	none,
	cloaking,
	weapon_control,
	engines,
	mind_control,
	shields,
	medbay,
	drone_control,
	piloting,
	door_control,
	backup_battery,
	oxygen,
	airlock,
	crew_teleporter,
	hacking,
	sensors,
	deadly_space,
}

export (RoomType) var room_type = RoomType.none


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_body_entered(body):
	if body.is_in_group("players"):
		body.room = self

func _on_body_exited(body):
	pass
