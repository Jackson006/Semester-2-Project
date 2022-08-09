extends KinematicBody2D
class_name Character, "res://Art/v1.1 dungeon crawler 16x16 pixel pack/heroes/knight/knight_idle_anim_f0.png" # The character image and class name

const FRICTION: float= 0.15 # Controls the character's friction with the floor

export(int) var hp: int = 2 # stores the health values of characters

export(int) var acceleration: int = 40 # The character's acceleration value
export(int) var max_speed: int = 100 # The character's maximum speed

onready var state_machine: Node = get_node("FiniteState") # Changes the state when player takes damage
onready var animated_sprite: AnimatedSprite = get_node("AnimatedSprite") # stores the AnimatedSprite node. This variable is used to flip the sprites

var mov_direction: Vector2 = Vector2.ZERO # A variable that determines the direction the character moves in
var velocity: Vector2 = Vector2.ZERO # A variable that determines the velocity/speed of the character


# warning-ignore:unused_argument
func _physics_process(delta: float) -> void: # moves the character using move and lside with velocity and applies friction
	velocity = move_and_slide(velocity) # Velocity is controlled by the move and slide vectors
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	
	
func move() -> void: # 
	mov_direction = mov_direction.normalized() # normalises the movement direction
	velocity += mov_direction * acceleration # adds acceleration in the direction of the movement to the velocity
	velocity = velocity.clamped(max_speed) # Clamps the max speed

func take_damage(dam: int, dir: Vector2, force: int) -> void: # Makes characters able to take damage
	hp -= dam # decreases the hp value with the dam parameter function
	state_machine.set_state(state_machine.states.hurt) # sets the state of the character to hurt and adds the knockback in the corresponding direction and force to the velocity
	velocity += dir * force
