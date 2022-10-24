extends Enemy

# Spawns the slime and indicates the direction of the spawn impulse
func _spawn_slime(direction: Vector2) -> void:
	var slime: KinematicBody2D = load("res://Characters/Enemies/Bosses/SlimeBoss.tscn").instance()
	slime.position = position
	slime.scale = scale/2
	slime.hp = max_hp/2.0
	slime.max_hp = max_hp/2.0
	get_parent().add_child(slime)
	slime.velocity += direction * 150
