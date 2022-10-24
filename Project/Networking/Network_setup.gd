extends Control

var player = load("Characters/Player/Player.tscn")
#var player2 = load() 

onready var multiplayer_config_ui = $Multiplayer_configure
onready var server_ip_address = $Multiplayer_configure/Server_ip_address

onready var device_ip_address = $CanvasLayer/Device_ip_address
onready var Start_game = $CanvasLayer/Start_game

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	
	device_ip_address.text = Network.ip_address

	if get_tree().network_peer != null:
		pass
	else:
		Start_game.hide()

func _process(_delta: float) -> void:
	if get_tree().network_peer != null:
		if get_tree().get_network_connected_peers().size() >= 1  and get_tree().is_network_server(): 
			Start_game.show()
		else:
			Start_game.hide()

func _player_connected(id) -> void:
	print("player " + str(id) + "has connected")
	
	instance_player(id)

func _player_disconnected(id) -> void:
	print("player " + str(id) + "has disconnected")
	
	if Players.has_node(str(id)):
		Players.get_node(str(id)).queue_free()

func _on_Create_server_pressed():
	multiplayer_config_ui.hide()
	Network.create_server()
	instance_player(get_tree().get_network_unique_id())

func _on_Join_server_pressed():
	if server_ip_address.text != "":
		multiplayer_config_ui.hide()
		
		Network.ip_address = server_ip_address.text
		Network.join_server()

func _connected_to_server() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	instance_player(get_tree().get_network_unique_id())

func instance_player(id) -> void:
	var player_instance = Global.instance_node_at_location(player, Players, Vector2(160, 176))
	player_instance.name = str(id)
	player_instance.set_network_master(id)

func _on_Start_game_pressed():
	rpc("_switch_to_game")

sync func _switch_to_game() -> void:
	get_tree().change_scene("res://Game.tscn")



