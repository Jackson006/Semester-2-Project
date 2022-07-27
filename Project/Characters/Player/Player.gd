extends Character

# warning-ignore:unused_argument
func _process(delta: float) -> void: #stores the direction of the mouse relative to the player
# warning-ignore:unused_variable
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized() # If the mouse is in the right of the player and the sprite is fliped, restore the original orientation and if the mouse is in the left of the player and is not flipped, flip it.
	
	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
		
		
func get_input() -> void: # if the ui_down action is triggered, increase the mov_direction with a vector of the same direction, Vector2.DOWN
		mov_direction = Vector2.ZERO
		if Input.is_action_pressed("ui_down"):
			mov_direction +=Vector2.DOWN
		if Input.is_action_pressed("ui_left"):
			mov_direction += Vector2.LEFT
		if Input.is_action_pressed("ui_right"):
			mov_direction += Vector2.RIGHT
		if Input.is_action_pressed("ui_up"):
			mov_direction += Vector2.UP
