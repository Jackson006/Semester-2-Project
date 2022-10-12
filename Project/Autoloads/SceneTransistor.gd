extends CanvasLayer

var new_scene: String

# Stores the node for the animation player
onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")

# Function is called when the scene transistions
func start_transistion_to(path_to_scene: String) -> void:
	new_scene = path_to_scene
	animation_player.play("change_scene")

# Changes the scene using the new scene path
func change_scene() -> void:
	assert(get_tree().change_scene(new_scene) == OK)
