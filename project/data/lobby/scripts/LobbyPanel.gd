extends Control

const DEFAULT_PORT := 8910
var IP_ADDRESS := "127.1.1.5"

onready var host_button : Button = $Host
onready var join_button : Button = $Join
onready var status_label : Label = $Status

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connection_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	return

func _set_status(text : String, status : bool) -> void:
	status_label.text = text
	if status : status_label.modulate = Color.green
	else : status_label.modulate = Color.red
	
	return

func _on_Host_pressed() -> void:
	var host := NetworkedMultiplayerENet.new()
	host.compression_mode = NetworkedMultiplayerENet.COMPRESS_RANGE_CODER
	var err = host.create_server(DEFAULT_PORT, 1)
	if err != OK:
		_set_status("Can't host, address in use.", false)
		return
	get_tree().network_peer = host
	host_button.disabled = true
	join_button.disabled = true
	_set_status("Waiting for the player...", true)
	
	return
	
func _on_Join_pressed() -> void:	
	if not IP_ADDRESS.is_valid_ip_address():
		_set_status("IP Address is not valid", false)
	else:
		var host = NetworkedMultiplayerENet.new()
		host.compression_mode = NetworkedMultiplayerENet.COMPRESS_RANGE_CODER
		host.create_client(IP_ADDRESS, DEFAULT_PORT)
		get_tree().network_peer = host
		
		_set_status("Connecting...", true)
	return
	
func _player_connected(_id) -> bool:
	var Map = load("res://data/map/scenes/Map.tscn").instance()

	#Map.connect("game_finished", self, "_end_game", [], CONNECT_DEFERRED)
	get_tree().root.add_child(Map)
	
	get_parent().hide()
	return false

func _player_disconnected(_id) -> bool:
	if get_tree().is_network_server():
		_end_game("Client disconnected")
	else:
		_end_game("Server disconnected")
	return false

func _end_game(status := "") -> void:
	if has_node("/root/Map"):
		get_node("/root/Map").queue_free()
		get_parent().show()
	get_tree().network_peer = null
	host_button.disabled = false
	join_button.disabled = false
	
	_set_status(status, false)
	return

func _connected_ok() -> bool:
	return false

func _connection_fail() -> bool:
	return false

func _server_disconnected() -> bool:
	_end_game("Server disconnected")
	return false

