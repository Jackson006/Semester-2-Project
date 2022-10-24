extends KinematicBody2D
class_name Character, "res://Art/v1.1 dungeon crawler 16x16 pixel pack/heroes/knight/knight_idle_anim_f0.png" # The character image and class name

const FRICTION: float= 0.15 # Controls the character's friction with the floor
const HIT_EFFECT_SCENE: PackedScene = preload("res://Characters/HitEffect.tscn")

# stores the health values of characters and defines the hp as a set variable
export(int) var max_hp: int = 2 # The character's maximum speed
export(int) var hp: int = 2 setget set_hp
signal hp_changed(new_hp)

export(int) var acceleration: int = 40 # The character's acceleration value
export(int) var max_speed: int = 100 # The character's maximum speed

onready var state_machine: Node = get_node("FiniteStateMachine") # Changes the state when player takes damage
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
	if state_machine.state != state_machine.states.hurt and state_machine.state != state_machine.states.dead:
		_spawn_hit_effect()
		self.hp -= dam # decreases the hp value with the dam parameter function
		if name == "Player":
			SavedData.hp = hp
		$EnemyHit.play()
		if hp > 0: # if after taking damage, the hp is greater than 0, set the state to hurt and apply normal knockback
			state_machine.set_state(state_machine.states.hurt) # sets the state of the character to hurts and adds the knockback in the corresponding direction and force to the velocity
			velocity += dir * force
		else: # if character is dead change the state to dead and apply double knockback
			state_machine.set_state(state_machine.states.dead)
			velocity += dir * force * 2

# Function is called automatically every time the value of the hp variable is modified
func set_hp(new_hp: int) -> void:
	# updates the hp variable and emits the signal hp_changed with new_hp as paramenter
	hp = new_hp
	emit_signal("hp_changed", new_hp)

func _spawn_hit_effect() -> void:
	var hit_effect: Sprite = HIT_EFFECT_SCENE.instance()
	add_child(hit_effect)
