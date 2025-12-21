extends Node2D

@onready var PlayerScene: PackedScene = preload("res://scenes/entities/player.tscn")
@onready var MainCam: PhantomCamera2D = %MainPCam

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var index: int = 0
	for PId in GameManager.Players:
		
		var CurrentPlayer: Player = PlayerScene.instantiate()
		
		if GameManager.Players[PId].id as int == multiplayer.get_unique_id():
			MainCam.follow_target = CurrentPlayer.get_cam_spot()
	
		
		CurrentPlayer.name = str(GameManager.Players[PId].id)
		CurrentPlayer.get_name_tag().text = GameManager.Players[PId].name
		
		add_child(CurrentPlayer)
		
		for Spawn:Node2D in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if Spawn.name == str(index):
				CurrentPlayer.global_position = Spawn.global_position
		
		index += 1
