extends FiniteStateMachine

func _init() -> void:
	_add_state("chase") # adds the chase state to the script

func _ready() -> void:
	set_state(states.chase) # sets the starting state to the chase state
