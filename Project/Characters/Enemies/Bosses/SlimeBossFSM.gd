extends FiniteStateMachine

# Variable for the boss's jump state
var can_jump: bool = false

# Onready variables for the path and jump timers
onready var jump_timer: Timer = parent.get_node("JumpTimer")
onready var hitbox: Area2D = parent.get_node("Hitbox")

func _init() -> void:
	_add_state("idle")
	_add_state("jump")
	_add_state("hurt")
	_add_state("dead")

# sets beginning state to idle
func _ready() -> void:
	set_state(states.idle)

func _state_logic(_delta: float) -> void:
	# If the slime is in the jump state, call his chase and move functions
	if state == states.jump:
		parent.chase()
		parent.move()

# Matches the current state
func _get_transition() -> int:
	match state: 
		states.idle: # if the slime is in the idle state it can jump and sets the state to jump
			if can_jump:
				return states.jump
		states.jump: # If the slime is in the jump or hurt state, set the state to idle
			if not animation_player.is_playing():
				return states.idle
		states.hurt:
			if not animation_player.is_playing():
				return states.idle
	return -1 # Otherwise deon't set the state and return -1

func _enter_state(_previous_state: int, new_state: int) -> void: # matches the new state
	match new_state: # plays the corresponding animations for each state
		states.idle:
			animation_player.play("idle")
		states.jump:
			if is_instance_valid(parent.player):
				parent.path = [parent.global_position, parent.player.position]
			hitbox.knockback_direction = (parent.path[1] - parent.path[0]).normalized()
			animation_player.play("jump")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")

# When the slime exits the jump state, set the can_jump to false and start the path timer
func _exit_state(state_exited: int) -> void:
	if state_exited == states.jump:
		can_jump = false
		jump_timer.start()

func _on_JumpTimer_timeout(): # Enables the slime to jump 5 seconds after the last jump
	 can_jump = true
