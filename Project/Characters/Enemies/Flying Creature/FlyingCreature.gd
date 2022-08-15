extends Enemy

onready var hitbox: Area2D = get_node("Hitbox")

# updates the knockback direction with the normalised velocity to make the knockback direction the same as the creature's velocity
func _process(_delta: float) -> void:
	hitbox.knockback_direction = velocity.normalized()
	
