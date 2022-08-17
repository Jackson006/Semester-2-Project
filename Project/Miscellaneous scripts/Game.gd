extends Node2D


func _init() -> void: # gets and stores the size of the screen and the size of the window
	var screen_size: Vector2 = OS.get_screen_size()
	var window_size: Vector2 = OS.get_window_size()
	# changes the position of the window to half the size of the screen minus half the size of the window
	OS.set_window_position(screen_size * 0.5 - window_size * 0.5)
