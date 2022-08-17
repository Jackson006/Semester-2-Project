extends Node2D

# Variable for the explosion animation
const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://Characters/Enemies/SpawnExplosion.tscn")
# Stores enemy scenes
const ENEMY_SCENES: Dictionary = {"FLYING CREATURE": preload("res://Characters/Enemies/Flying Creature/FlyingCreature.tscn")}

var num_enemies: int

onready var tilemap: TileMap = get_node("Navigation2D/TileMap2")
onready var entrance: Node2D = get_node("Entrance")
onready var door_container: Node2D = get_node("Doors")
onready var enemy_positions_container: Node2D = get_node("EnemyPositions")
onready var player_detector: Area2D = get_node("PlayerDetector")

func _ready() -> void:
	# Initialises the number of enemies with the number of children
	num_enemies = enemy_positions_container.get_child_count()

func _open_doors() -> void:
	# calls the open function of all the doors using a loop
	for door in door_container.get_children():
		door.open()

func _close_entrance() -> void:
	# Closes the entrance behind the player
	for entry_position in entrance.get_children():
		tilemap.set_cellv(tilemap.world_to_map(entry_position.global_position), 1)
		tilemap.set_cellv(tilemap.world_to_map(entry_position.global_position) + Vector2.UP, 2)

func _spawn_enemies() -> void:
	# Spawns the enemies and the explosion effect. For each position spawn the enemy and spawn an explosion
	for enemy_position in enemy_positions_container.get_children():
		var enemy: KinematicBody2D = ENEMY_SCENES.FLYING_CREATURE.instance()
		var __ = enemy.connect("tree_exited", self, "_on_enemy_killed")
		enemy.global_position = enemy_position.global_position
		call_deferred("add_child", enemy)
		
		var spawn_explosion: AnimatedSprite = SPAWN_EXPLOSION_SCENE.instance()
		spawn_explosion.global_position = enemy_position.global_position
		call_deferred("add_child", spawn_explosion)








