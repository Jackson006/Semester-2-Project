extends Navigation2D

const SPAWN_ROOMS: Array = [preload("res://Rooms/SpawnRoom0.tscn"), preload("res://Rooms/SpawnRoom1.tscn")]
const INTERMEDIATE_ROOMS: Array = [preload("res://Rooms/Room0.tscn"), preload(""), preload("")]
const END_ROOMS: Array = [preload("res://Rooms/EndRoom0.tscn")]

const TILE_SIZE: int = 16
const FLOOR_TILE_INDEX: int = 22
const RIGHT_WALL_TILE_INDEX: int = 6
const LEFT_WALL_TILE_INDEX: int = 7
