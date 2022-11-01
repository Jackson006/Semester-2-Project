extends Node2D

export(bool) var boss_room: bool = false

# Variable for the explosion animation
const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://Characters/Enemies/SpawnExplosion.tscn")
# Stores enemy scenes
const ENEMY_SCENES: Dictionary = {"FLYING_CREATURE": preload("res://Characters/Enemies/Flying Creature/FlyingCreature.tscn"), "GOBLIN": preload("res://Characters/Enemies/Goblin/Goblin.tscn"), "SLIME_BOSS": preload("res://Characters/Enemies/Bosses/SlimeBoss.tscn")}

var num_enemies: int

onready var tilemap: TileMap = get_node("TileMap2")
onready var entrance: Node2D = get_node("Entrance")
onready var door_container: Node2D = get_node("Doors")
onready var enemy_positions_container: Node2D = get_node("EnemyPositions")
onready var player_detector: Area2D = get_node("PlayerDetector")

func _ready() -> void:
	# Initialises the number of enemies with the number of children
	num_enemies = enemy_positions_container.get_child_count()

func _on_enemy_killed() -> void:
	# Opens the doors when all the enemies are dead
	num_enemies -= 1
	if num_enemies == 0:
		_open_doors()

func _open_doors() -> void:
	# calls the open function of all the doors using a loop
	for door in door_container.get_children():
		door.open()

func _close_entrance() -> void:
	# Closes the entrance behind the player
	for entry_position in entrance.get_children():
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position), 2)
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position) + Vector2.DOWN, 15)
		pass

func _open_entrance() -> void:
	for entry_position in entrance.get_children():
		queue_free()

func _spawn_enemies() -> void:
	# Spawns the enemies and the explosion effect. For each position spawn the enemy and spawn an explosion
	for enemy_position in enemy_positions_container.get_children():
		var enemy: KinematicBody2D
		if boss_room:
			enemy = ENEMY_SCENES.SLIME_BOSS.instance()
			num_enemies = 15
		else: 
			if randi() %2 == 0:
				enemy = ENEMY_SCENES.FLYING_CREATURE.instance()
			else:
				enemy = ENEMY_SCENES.GOBLIN.instance()
		enemy.position = enemy_position.position
		call_deferred("add_child", enemy)
		
		var spawn_explosion: AnimatedSprite = SPAWN_EXPLOSION_SCENE.instance()
		spawn_explosion.position = enemy_position.position
		call_deferred("add_child", spawn_explosion)


func _on_PlayerDetector_body_entered(_body: KinematicBody2D) -> void:
	# When the player enters the room spawn enemies, close entrance, and queue free the detector
	player_detector.queue_free()
	if num_enemies > 0:
		_close_entrance()
		_spawn_enemies()
	else: 
		_open_doors()
		_open_entrance()

func _game_over() -> void:
	get_tree().change_scene("res://Main_Menu.tscn")

