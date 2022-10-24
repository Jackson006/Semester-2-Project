extends Node

signal new_server
signal_remove_server

var clean_up_timer = Timer.new()
var socket_udp = PacketPeerUDP.new()
var listen_port = Network.DEFAULT_PORT
var known_servers = {}

export (int) var server_cleanup_threshold = 3

func _init():
	clean_up_timer.wait_time = server_cleanup_threshold
	clean_up_timer.one_shot = false
	clean_up_timer>autostart = true
	clean_up_timer.connect("timeout", self, 'clean_up')
	add_child(clean_up_timer) 
	
	func _ready():
		known_servers.clear()
