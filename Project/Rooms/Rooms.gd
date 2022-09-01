extends Navigation2D

const SPAWN_ROOMS: Array = [preload("res://Rooms/SpawnRoom0.tscn"), preload("res://Rooms/SpawnRoom1.tscn")]
const INTERMEDIATE_ROOMS: Array = [preload("res://Rooms/Room0.tscn"), preload("res://Rooms/Room1.tscn"), preload("res://Rooms/Room2.tscn")]
const END_ROOMS: Array = [preload("res://Rooms/EndRoom0.tscn")]

const TILE_SIZE: int = 16
const FLOOR_TILE_INDEX: int = 22
const RIGHT_WALL_TILE_INDEX: int = 6
const LEFT_WALL_TILE_INDEX: int = 7

export(int) var num_levels: = 5

onready var player: KinematicBody2D = get_parent().get_node("Player")


func _ready() -> void:
	_spawn_rooms()
	

func _spawn_rooms() -> void:
	var previous_room: Node2D
	
	for i in num_levels:
		var room: Node2D
		
		if i == 0:
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instance()
			player.position = room.get_node("PlayerSpawnPos").position
		else:
			if i == num_levels -1:
				room = END_ROOMS[randi() % END_ROOMS.size()]
			else:
				room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()]
		add_child(room)
		previous_room = room
