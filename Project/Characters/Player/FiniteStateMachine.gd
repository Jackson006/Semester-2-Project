extends FiniteStateMachine

func _init() -> void:
	_add_state("idle")
	_add_state("move")
	_add_state("hurt")
	_add_state("dead")

func _ready() -> void:
	set_state(states.idle)
	
func _state_logic(_delta: float) -> void:
	if state == states.idle or state == states.move:# Checks if the state is idle or move
		parent.get_input()
		parent.move()
	
func _get_transition() -> int:
	match state:
		states.idle:
			if parent.velocity.length() > 10:
				return states.move
		states.move:
			if parent.velocity.length() < 10:
				return states.idle
			if not animation_player.is_playing(): # returns the idle state if the hurt animation is finished
				return states.idle
	return -1
	
func _enter_state(_previous_state: int, new_state: int) -> void: # plays animations when states are entered
	match new_state:
		states.idle:
			animation_player.play("idle")
		states.move:
			animation_player.play("move")
		states.idle:
			animation_player.play("hurt")
		states.move:
			animation_player.play("dead")
