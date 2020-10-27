extends Node2D


export (Resource) var cursor_image

func _ready():
	Input.set_custom_mouse_cursor(cursor_image,
			Input.CURSOR_ARROW,
			Vector2(0, 0))
			
	Input.set_custom_mouse_cursor(cursor_image,
			Input.CURSOR_IBEAM,
			Vector2(0, 0))
