extends Node
class_name FiniteStateMachine # The class name allows the inheriting of functions and other variables

# This script controls automated behaviours and controls different states

var states: Dictionary = {} # This variable stores all the states 
var previous_state: int = -1 # This variable stores the anterior state
var state: int = -1 setget set_state # The variable state stores the current state

onready var parent: Character = get_parent()
onready var animation_player: AnimationPlayer = parent.get_node("AnimationPlayer")


func _physics_process(delta: float) -> void:
	if state != -1:
		_state_logic(delta)
		var transition: int = _get_transition()
		if transition != -1:
			set_state(transition)


func _state_logic(_delta: float) -> void:
	pass
	
	
func _get_transition() -> int:
	return -1


func _add_state(new_state: String) -> void:
	states[new_state] = states.size()
	
	
func set_state(new_state: int) -> void:
	_exit_state(state)
	previous_state = state
	state = new_state
	_enter_state(previous_state, state)


func _enter_state(_previous_state: int, _new_state: int) -> void:
	pass
	
	
func _exit_state(_state_exited: int) -> void:
	pass
