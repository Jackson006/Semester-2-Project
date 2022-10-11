extends StaticBody2D

# Stores tthe animationPlayer node
onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")

func open() -> void:
	#plays the open animation 
	$StoneDoor.play()
	animation_player.play("open")
