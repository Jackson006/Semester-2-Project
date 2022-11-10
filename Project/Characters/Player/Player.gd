extends Character

enum {UP, DOWN}

const speed = 300
const DUST_SCENE: PackedScene = preload("res://Characters/Player/Dust.tscn")

var current_weapon: Node2D

onready var dust_position: Position2D = get_node("DustPosition")
onready var parent: Node = get_parent()
onready var weapons: Node2D = get_node("Weapons")

#puppet var puppet_username = "" setget puppet_username_set
puppet var puppet_position = Vector2(0, 0) setget puppet_position_set
puppet var puppet_velocity = Vector2()
puppet var puppet_rotation = 0
#onready var tween = $Tween   
#var username setget username_set
var username_text_instance = null
var username_text = load("res://Networking/username_text.tscn")

func _ready() -> void:
	_restore_previous_state()
	current_weapon = weapons.get_child(0)

	get_tree().connect("network_peer_connected", self, "_network_peer_connected")

	#username_text_instance = Global.instance_node_at_location(username_text, Persistent_nodes, global_position)
	#username_text_instance.player_following = self
	

	if username_text_instance != null:
		username_text_instance.name = "username" + name
	
# Restores the player's state from a previous scene
func _restore_previous_state() -> void:
	self.hp = SavedData.hp

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
	current_weapon.move(mouse_direction)
	# checks if the attack input has been pressed and the sword animation is playing and if so plays the animation
	if is_network_master():
		var x_input = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")) 
		var y_input = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		
		velocity = Vector2(x_input, y_input).normalized()
		move_and_slide(velocity * speed)
		look_at(get_global_mouse_position())
	# else:
		#rotation_degrees = lerp(rotaion_degrees, puppet_rotation, delta * 8)  #not working idk why find out later 
		
		# if not tween.is_active():
			# move_and_slide(puppet_velocity * speed)
	if username_text_instance != null:
		username_text_instance.name = "username" + name
		
func get_input() -> void: # This function is called to get the player's inputmn 
	mov_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_down"): # if the ui down action is triggered, increase the mov_direction with a vector of the same direction
		mov_direction +=Vector2.DOWN
	if Input.is_action_pressed("ui_left"): # if the ui left action is triggered, increase the mov_direction with a vector of the same direction
		mov_direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"): # if the ui right action is triggered, increase the mov_direction with a vector of the same direction
		mov_direction += Vector2.RIGHT
	if Input.is_action_pressed("ui_up"): # if the ui up action is triggered, increase the mov_direction with a vector of the same direction
		mov_direction += Vector2.UP
	if not current_weapon.is_busy():
		if Input.is_action_just_released("ui_previous_weapon"):
			_switch_weapon(UP)
		elif Input.is_action_just_released("ui_next_weapon"):
			_switch_weapon(DOWN)
	current_weapon.get_input()

func _switch_weapon(direction: int) -> void:
	var index: int = current_weapon.get_index()
	if direction == UP:
		index -= 1
		if index <0:
			index = weapons.get_child_count() - 1
		else: 
			index += 1
			if index > weapons.get_child_count() - 1:
				index = 0
	current_weapon.hide()
	current_weapon = weapons.get_child(index)
	current_weapon.show()

func puppet_position_set(new_value) -> void:
	puppet_position = new_value

func _on_Network_tick_rate_timeout():
	if is_network_master():
		rset_unreliable("puppet_position", global_position) #sends out heaps of pacets but does not check if the client has resaved it
		rset_unreliable("puppet_velocity", velocity)
		rset_unreliable("puppet_rotation", rotation)

# func _process_dead() -> void:
	# if state == states.idle:
		# get_tree().change_scene("res://Main_Menu.tscn")

func _spawn_dust() -> void:
	# stores new instance of the dust sprite
	var dust: Sprite = DUST_SCENE.instance()
	# changes the position of the dust to the global position of the player
	dust.position = dust_position.global_position
	parent.add_child_below_node(parent.get_child(get_index() - 1), dust)

func _game_over() -> void:
	SceneTransistor.start_transition_to("res://Game_Over.tscn")


