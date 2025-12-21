extends Control

@export var Address: String = "127.0.0.1"
@export var port: int = 8910
var peer: ENetMultiplayerPeer

@onready var NameInput: LineEdit = $Name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	if "--server" in OS.get_cmdline_args():
		hostGame()
	

@rpc("any_peer","call_local")
func start_game() -> void:
	var scene: Node = preload("res://scenes/game_scene.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func hostGame() -> void:
	peer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_server(port, 2)
	if error != OK:
		print("cannot host: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting For Players!")

func join_by_ip(ip: String) -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

# called from clients and server
func peer_connected(id: int) -> void:
	print("Player Connected " + str(id))

func peer_disconnected(id: int) -> void:
	print("Player Disconnected " + str(id))
	GameManager.Players.erase(id)
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	for i in players:
		if i.name == str(id):
			i.queue_free()


# called from clients
func connected_to_server() -> void:
	print("Connected To Server!")
	send_player_information.rpc_id(1, NameInput.text, multiplayer.get_unique_id())
	
func connection_failed() -> void:
	print("Couldnt Connect")

@rpc("any_peer")
func send_player_information(name: String, id: int) -> void:
	if !GameManager.Players.has(id):
		
		if name.matchn("Photographer") : 
			name = name + str(id)
		
		GameManager.Players[id] = {
			"name": name,
			"id": id,
		}
	
	if multiplayer.is_server():
		for PlayerID: int in GameManager.Players:
			send_player_information.rpc(GameManager.Players[PlayerID].name, PlayerID)

func _on_start_button_pressed() -> void:
	start_game.rpc()
	pass # Replace with function body.


func _on_join_button_pressed() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)


func _on_host_button_pressed() -> void:
	peer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_server(port, 8)
	
	if error != OK:
		print("cannot host: " + error_string(error))
		return
	
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting For Players!")
	send_player_information(NameInput.text, multiplayer.get_unique_id())
