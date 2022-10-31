extends Navigation2D

# Source: https://www.youtube.com/watch?v=Cx5VA_8KuEE&list=PL2-ArCpIQtjELkyLKec8BaVVCeunuHSK9&index=10&t=1020s

# The Spawn rooms constant are the rooms that are placed at the start of the level
const SPAWN_ROOMS: Array = [preload("res://Rooms/SpawnRoom0.tscn"), preload("res://Rooms/SpawnRoom1.tscn")]
# The intermidiate rooms are the rooms that are placed in the middle of the level
const INTERMEDIATE_ROOMS: Array = [preload("res://Rooms/Room0.tscn"), preload("res://Rooms/Room1.tscn"), preload("res://Rooms/Room2.tscn"), preload("res://Rooms/Room3.tscn")]
# The end rooms constant is the room that is placed at the end of the level
const END_ROOMS: Array = [preload("res://Rooms/EndRoom0.tscn")]
const SLIME_BOSS_SCENE: PackedScene = preload("res://Rooms/BossRoom.tscn")

# These constants store the size of the tiles and which tiles from the tilemap are used for the walls and floors
const TILE_SIZE: int = 16
const FLOOR_TILE_INDEX: int = 22
const RIGHT_WALL_TILE_INDEX: int = 6
const LEFT_WALL_TILE_INDEX: int = 7

# This variable is the number of rooms that are generated at the beginning of the game = 8
export(int) var num_levels: int = 2 

# This variable stores the player scene for the procedural generation
onready var player: KinematicBody2D = get_parent().get_node("Player")

# This function rrandomly spawns rooms at the beginning of the game
func _ready() -> void:
	SavedData.num_floor += 1
	if SavedData.num_floor == 3:
		num_levels = 3
	_spawn_rooms()
	

func _spawn_rooms() -> void:
	# The previous room variable stores the last room spawned
	var previous_room: Node2D
	
	# The for i in num_levels loops the code
	for i in num_levels:
		# the room variable stores the room that we want to create
		var room: Node2D
		
		# If i = 0, then the first room that is spawned will be be taken from the spawn room array. At the end of the 
		# loop, it updates the previous room variable with the current room. The randi functions 
		# randomises the room taken from the intermediate room to randomise the map
		if i == 0:
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instance()
			player.position = room.get_node("PlayerSpawnPos").position #Spawns the player in the player position in the spawn rooms
		# checks if this is the last room, if so, it chooses a random room from the END_ROOMS array
		else:
			if SavedData.num_floor == 3: 
				room = SLIME_BOSS_SCENE.instance()
			else: 
				if i == num_levels -1:
					room = END_ROOMS[randi() % END_ROOMS.size()].instance()
				# checks if this is an intermediate room, if so, it chooses a random room from the INTERMEDIATE_ROOMS array
				else:
					room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instance()
				
			# if the room is not the spawn room, it is connected to the last room
			# These rooms store the tilemap of the previous room, door, and tile position, then starts making a corridor
			# 2 Vectors above where the door's position is
			var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
			var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
			var exit_tile_pos: Vector2 = previous_room_tilemap.world_to_map(previous_room_door.position) + Vector2.UP * 2
				
			# determines the length/height of the corridor above the last door's position
			var corridor_height: int = randi() % 5 + 2 # 5 + 2
			# Stores the positions of the corridor's walls and tiles
			for y in corridor_height:
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-2, -y), LEFT_WALL_TILE_INDEX) # -2
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-1, -y), FLOOR_TILE_INDEX) # -1
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(0, -y), FLOOR_TILE_INDEX) # 0
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(1, -y), RIGHT_WALL_TILE_INDEX) # 1
				
			# moves the new room to connect the corridor with the entrance.
			# The room_tilemap variable stores the variable for the room's tilemap
			var room_tilemap: TileMap = room.get_node("TileMap")
			# moves the room onto the door of the previous room and then moves the room up the number of verticle tiles
			# by a multiple of the size of the tile as well as calculates the vertical size of the corridor plus one tile.
			# The room is then moved horizontally until the rooms are connected by getting the x tile position of the right
			# tile of the entrance and multiplying it for the tile's size
			room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.world_to_map(room.get_node("Entrance/Position2D2").position).x * TILE_SIZE # +1 corridor height
				
		add_child(room)
		previous_room = room
