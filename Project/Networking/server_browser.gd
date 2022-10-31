extends Control

onready var server_listener = $Server_listener 
onready var server_ip_text_edit = $background_panel/Server_ip_text_edit
onready var server_container = $background_panel/VBoxContainer
onready var manual_setup_button = $background_panel/Manual_setup

func _ready() -> void:
	server_ip_text_edit.hide()

func _on_server_listener_new_server(serverInfo):
	var server_node = Global.instance_node(load("res://Networking/Server_display.tscn"), server_container)
	server_node.text = "%S - %S" % [serverInfo.ip, serverInfo.name]
	server_node.ip_address = str(serverInfo.ip )

func _on_server_listener_remove_server():
	pass # Replace with function body.
