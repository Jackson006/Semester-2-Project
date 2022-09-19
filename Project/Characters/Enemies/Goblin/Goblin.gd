extends Enemy

const MAX_DISTANCE_TO_PLAYER: int = 80
const MIN_DISTANCE_TO_PLAYER: int = 40

# variable for the goblin's distance from the player
var distance_to_player: float 

# updates the distance to the player 
func _on_PathTimer_timeout() -> void:
	if is_instance_valid(player):
		distance_to_player = (player.position - global_position).length()
		if distance_to_player > MAX_DISTANCE_TO_PLAYER: 
			_get_path_to_player()
		# if the player is a valid instance and is closer than the minimum 
		# distance constant, get the path to move away from the player
		elif distance_to_player < MIN_DISTANCE_TO_PLAYER:
			_get_path_to_move_away_from_player()
	# If the player is not a valid instance, stop the timer, empty the path 
	# array, and change the movement direction to an empty vector
	else:
		path_timer.stop
		path = []
		mov_direction = Vector2.ZERO

# updates the path with the position 100 pixels away from the player
func _get_path_to_move_away_from_player() -> void:
	var dir: Vector2 = (global_position - player.position).normalized()
	path = navigation.get_simple_path(global_position, global_position + dir * 100)


