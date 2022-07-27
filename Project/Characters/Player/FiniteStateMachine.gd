extends FiniteStateMachine

func _init() -> void:
	_add_state("Idle")
	_add_state("Move")
	
func _ready() -> void:
	set_state(states.Idle)
	
func _state_logic(_delta: float) -> void:
	parent.get_input()
	parent.Move()
	
func _get_transition() -> int:
	match state:
		states.Idle:
			if parent.velocity.length() > 10:
				return states.Move
		states.Move:
			if parent.velocity.length() < 10:
				return states.Idle
	return -1
