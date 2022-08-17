extends AnimatedSprite

func _ready() -> void:
	playing = true

func _on_SpawnExplosion_animation_finished() -> void:
	# When the animation stops playing, free the scene
	queue_free()
