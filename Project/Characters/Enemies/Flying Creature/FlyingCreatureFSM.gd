extends FiniteStateMachine

func _init() -> void:
	_add_state("chase") # adds the chase state to the script
	_add_state("hurt") # adds the hurt state to the script
	_add_state("dead") # adds the hurt state to the script

func _ready() -> void:
	set_state(states.chase) # sets the starting state to the chase state

func _state_logic(_delta: float) -> void:
	# If the state is the chase state, call the functions chase and move of the parent, making the
	# creature chase the player
	if state == states.chase:
		parent.chase()
		parent.move()

func _get_transition() -> int:
	match state:
		states.hurt:
			if not animation_player.is_playing():
				return states.chase
	return -1

func _enter_state(_previous_state: int, _new_state: int) -> void:
	match _new_state:
		states.chase:
			animation_player.play("fly")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")
