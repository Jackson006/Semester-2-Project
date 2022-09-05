extends Character

puppet var puppet_position = Vector2(0, 0) setget puppet_position_set
onready var sword: Node2D = get_node("Sword") # gets the sword node
onready var sword_hitbox: Area2D = get_node("Sword/Node2D/Sprite/Hitbox")
onready var sword_animation_player: AnimationPlayer = sword.get_node("SwordAnimationPlayer")

# warning-ignore:unused_argument
func _process(delta: float) -> void: #stores the direction of the mouse relative to the player
# warning-ignore:unused_variable
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized() 
	# If the mouse is in the right of the player and the sprite is fliped, restore the original >
	# orientation and if the mouse is in the left of the player and is not flipped, flip it.
	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
	sword.rotation = mouse_direction.angle() # updates the rotation of the sword using the angle of the mouse's direction
	sword_hitbox.knockback_direction = mouse_direction# sets the knockback direction to the mouse's direction
		# Keeps the sword the right way up regardless of the mouse's direction
	if sword.scale.y == 1 and mouse_direction.x < 0:
		sword.scale.y = -1
	elif sword.scale.y == -1 and mouse_direction.x > 0:
		sword.scale.y = 1
	# checks if the attack input has been pressed and the sword animation is playing and if so plays the animation
	if is_network_master():
		var x_input = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")) 
		var y_input = int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("up"))
	else:
		rotation_degrees = lerp(rotaion_degrees, puppet_rotation, delta * 8)
		
		
		
func get_input() -> void: # This function is called to get the player's input
		mov_direction = Vector2.ZERO
		if Input.is_action_pressed("ui_down"): # if the ui down action is triggered, increase the mov_direction with a vector of the same direction
			mov_direction +=Vector2.DOWN
		if Input.is_action_pressed("ui_left"): # if the ui left action is triggered, increase the mov_direction with a vector of the same direction
			mov_direction += Vector2.LEFT
		if Input.is_action_pressed("ui_right"): # if the ui right action is triggered, increase the mov_direction with a vector of the same direction
			mov_direction += Vector2.RIGHT
		if Input.is_action_pressed("ui_up"): # if the ui up action is triggered, increase the mov_direction with a vector of the same direction
			mov_direction += Vector2.UP
		
		if Input.is_action_just_pressed("ui_attack") and not sword_animation_player.is_playing():
			sword_animation_player.play("attack")

func puppet_position_set(new_value) -> void:
	puppet_position = new_value

func _on_Network_tick_rate_timeout():
	if is_network_master():
		rset_unreliable("puppet+position", global_position) #sends out heaps of pacets but does not check if the client has resaved it
