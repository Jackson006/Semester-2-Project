extends Node

export (float) var broadcast_interval = 1.0
var server_info = {"name": "LAN Game"}

var socket_udp
var broadcast_timer = Timer.new()
var broadcast_port = Network.DEFAULT_PORT

func _enter_tree():
	broadcast_timer.wait_time = broadcast_interval
	broadcast_timer.one_shot = false 
	broadcast_timer.autostart = true 
	
	if get_tree().is_network_server():
		add_child(broadcast_timer)
		broadcast_timer.connect("timeout", self, "broadcast")
		
		socket_udp = PacketPeerUDP.new()
		socket_udp.set_broadcast_enabled(true)
		socket_udp.set_dest_address('255.255.255.255', broadcast_port)
		
