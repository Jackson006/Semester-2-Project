extends Area2D
class_name Hitbox

export(int) var damage: int = 1 # damage variable
var knockback_direction: Vector2 = Vector2.ZERO # Direction of impact variable
export(int) var knockback_force: int = 300 # Knockback force variable

onready var collision_shape: CollisionShape2D = get_child(0) # collision shape to be added as a child node

func _init() -> void:
	connect("body_entered", self, "_on_body_entered") # Connects the signal to the entered body

func _ready() -> void:
	assert(collision_shape != null) # Makes sure the hitbox has a collision shape

func _on_body_entered(body: PhysicsBody2D) -> void:
	body.take_damage(damage, knockback_direction, knockback_force) # When a body enters the collision area, call the function take_damage of the body with the variables of the script as parameters
