extends Sprite

# Stores the animation player in an onready variable
onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")

# Plays the animation
func _ready() -> void:
	animation_player.play("animation")
