extends Character
class_name Enemy, "res://Art/v1.1 dungeon crawler 16x16 pixel pack/enemies/goblin/goblin_idle_anim_f0.png"

var path: PoolVector2Array # stores an array of points to the player 

onready var navigation: Navigation = get_tree().current_scene.get_node("Navigation")
onready var player: KinematicBody2D = get_tree().current_scene.get_node("Player")
