extends Enemy

func _process(_delta: float) -> void:
	if player.global_position.y > global_position.y:
		z_index = 0
	else:
		z_index = 1

# Called before que_freeing the slime and duplicates the slime
func duplicate_slime() -> void:
	# if the scale of slime is greater than 1, generate a random direction and store it in a variable
	# called impulse_direction
	if scale > Vector2(1, 1):
		var impulse_direction: Vector2 = Vector2.RIGHT.rotated(rand_range(0, 2*PI))
		# Spawns two slimes, one in the direction of the impulse and the other in the contrary direction
		_spawn_slime(impulse_direction)
		_spawn_slime(impulse_direction * -1)

# Spawns the slime and indicates the direction of the spawn impulse
func _spawn_slime(direction: Vector2) -> void:
	var slime: KinematicBody2D = load("res://Characters/Enemies/Bosses/SlimeBoss.tscn").instance()
	slime.position = position
	slime.scale = scale/2
	slime.hp = max_hp/2.0
	slime.max_hp = max_hp/2.0
	get_parent().add_child(slime)
	slime.velocity += direction * 150

func _you_win() -> void:
	SceneTransistor.start_transition_to("res://Main_Menu.tscn")
