extends Control

func _on_Play_pressed():
	$MouseClick.play()
	get_tree().change_scene("res://Game.tscn")
