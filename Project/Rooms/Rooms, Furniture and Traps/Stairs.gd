extends Area2D

# Stores the collision shape in an onready variable
onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")

func _on_Stairs_body_entered(_body: KinematicBody2D) -> void:
# Disables the collision when the player enters the stairs 
	collision_shape.set_deferred("disabled", true)
	# Starts transition to the game's scene
	SceneTransistor.start_transistion_to("res://Game.tscn")
