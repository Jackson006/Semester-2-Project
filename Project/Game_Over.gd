extends Control

func _on_Play_pressed():
	$MouseClick.play()
	SceneTransistor.start_transition_to("res://Main_Menu.tscn")
