extends Control

func _on_Play_pressed():
	$MouseClick.play()
	SavedData.num_floor = 1
	SavedData.hp = 4
	SceneTransistor.start_transition_to("res://Game.tscn")
