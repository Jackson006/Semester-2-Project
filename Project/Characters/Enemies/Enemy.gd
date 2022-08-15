extends Character
class_name Enemy, "res://Art/v1.1 dungeon crawler 16x16 pixel pack/enemies/goblin/goblin_idle_anim_f0.png"

var path: PoolVector2Array # stores an array of points to the player 

onready var navigation: Navigation2D = get_tree().current_scene.get_node("Navigation2D")
onready var player: KinematicBody2D = get_tree().current_scene.get_node("Player")
onready var path_timer: Timer = get_node("PathTimer")

func chase() -> void:
	# if the path is not empty, create two variables: vector_to_next_point that stores the vector to the next
	# point in the path
	if path:
		var vector_to_next_point: Vector2 = path[0] - global_position
		var distance_to_next_point: float = vector_to_next_point.length()
		# if the distance to the next point is less than 1, remove the first point of the path
		# and if there aren't more points in the path, return.
		if distance_to_next_point < 1:
			path.remove(0)
			if not path:
				return
		# Updates the movement direction with the vector to the next point
		mov_direction = vector_to_next_point
		# If the enemy is moving to the right and the animated sprite is flipped, change flip_h to
		# false to restore the original orientation
		if vector_to_next_point.x > 0 and animated_sprite.flip_h:
			animated_sprite.flip_h = false
		# If the enemy is moving left and the animated sprite is not flipped, flip it
		elif vector_to_next_point.x < 0 and not animated_sprite.flip_h:
			animated_sprite.flip_h = true


func _on_PathTimer_timeout() -> void:
	if is_instance_valid(player): # checks if the player is a valid instance before making the path so that the game doesn't crash when the player dies
		path = navigation.get_simple_path(global_position, player.position)
	else: # if the player is no longer a valid instance, stop the timer
		path_timer.stop()
		path = []
		mov_direction = Vector2.ZERO
