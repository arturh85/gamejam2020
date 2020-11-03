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

var oxygen = 100

func _ready():
	if room_type == RoomType.deadly_space:
		oxygen = -1
	else:
		oxygen = 50 + randi() % 50
	print("random " + str(self) + ": " + str(oxygen))

func _on_body_entered(body):
	if body.is_in_group("players"):
		body.room = self
		print("entered " + str(self) + ": " + str(oxygen))

func _on_body_exited(body):
	pass
