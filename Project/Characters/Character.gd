extends KinematicBody2D
class_name Character, "res://Art/v1.1 dungeon crawler 16x16 pixel pack/heroes/knight/knight_idle_anim_f0.png" # The character image and class name

const FRICTION: float= 0.15 # Controls the character's friction with the floor

export(int) var acceleration: int = 40 # The character's acceleration value
export(int) var max_speed: int = 100 # The character's maximum speed

var mov_direction: Vector2 = Vector2.ZERO # A variable that determines the direction the character moves in
var velocity: Vector2 = Vector2.ZERO # A variable that determines the velocity/speed of the character


func _physics_process(delta: float) -> void: # moves the character using move and lside with velocity and applies friction
	velocity = move_and_slide(velocity) # Velocity is controlled by the move and slide vectors
	velocity = lerp(velocity, Vector2.ZERO, FRICTION)
	
	
func move() -> void: # 
	mov_direction = mov_direction.normalized() # normalises the movement direction
	velocity += mov_direction * acceleration # adds acceleration in the direction of the movement to the velocity
	velocity = velocity.clamped(max_speed) # Clamps the max speed
