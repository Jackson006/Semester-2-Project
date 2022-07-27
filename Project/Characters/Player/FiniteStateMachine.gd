extends FiniteStateMachine

func _init() -> void:
	_add_state("Idle")
	_add_state("Move")
	
func _ready() -> void:
	set_state(states.Idle)
