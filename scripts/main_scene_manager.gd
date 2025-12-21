extends Node2D

@onready var PlayerScene: PackedScene = preload("res://scenes/entities/player.tscn")
@onready var PlayerScene2: PackedScene = preload("res://scenes/entities/player2.tscn")
@onready var PlayerScene3: PackedScene = preload("res://scenes/entities/player3.tscn")
@onready var PlayerScene4: PackedScene = preload("res://scenes/entities/player4.tscn")
@onready var MainCam: PhantomCamera2D = %MainPCam
@onready var enemy_spawn: Marker2D = %EnemySpawn

var enemy_scene: PackedScene = preload("res://scenes/entities/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var index: int = 0
	for PId in GameManager.Players:
		
		var CurrentPlayer: Player
		
		if index == 0:
			CurrentPlayer = PlayerScene.instantiate()
		if index == 1:
			CurrentPlayer = PlayerScene2.instantiate()
		if index == 2:
			CurrentPlayer = PlayerScene3.instantiate()
		if index == 3:
			CurrentPlayer = PlayerScene4.instantiate()
		
		if index == 0 :
			GameManager.host_authority = GameManager.Players[PId].id as int
			%MobSpawner.set_multiplayer_authority(GameManager.Players[PId].id as int)
		
		if GameManager.Players[PId].id as int == multiplayer.get_unique_id():
			MainCam.follow_target = CurrentPlayer.get_cam_spot()
	
		
		CurrentPlayer.name = str(GameManager.Players[PId].id)
		CurrentPlayer.get_name_tag().text = GameManager.Players[PId].name
		
		%Players.add_child(CurrentPlayer)
		
		for Spawn:Node2D in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if Spawn.name == str(index):
				CurrentPlayer.global_position = Spawn.global_position
		
		index += 1
	for i in range(1000) :
		await get_tree().create_timer(5.0).timeout
		var test_enemy: Node = enemy_scene.instantiate()
		add_child(test_enemy)
		test_enemy.global_position = enemy_spawn.global_position

	
	
