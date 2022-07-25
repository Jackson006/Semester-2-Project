extends KinematicBody2D
class_name Character, "res://Art/v1.1 dungeon crawler 16x16 pixel pack/heroes/knight/knight_idle_anim_f0.png" # The character image and class name

const FRICTION: float= 0.15 # Controls the character's friction with the floor

export(int) var acceleration: int = 40
export(int) var max_speed: int = 100
