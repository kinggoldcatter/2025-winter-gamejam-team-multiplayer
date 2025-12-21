extends CharacterBody2D
class_name enemy
var movement_speed: float = 150.0
var movement_target_position: Vector2 = Vector2(60.0,180.0)
@export var target_player: Node2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	$MultiplayerSynchronizer.set_multiplayer_authority(GameManager.host_authority)

	if $MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		return
	
	
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	set_target_player(players.pick_random())
	


func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta: float) -> void:
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		_apply_movment(delta)

func _process(delta: float) -> void:
	set_movement_target(target_player.position)
	
@rpc("any_peer","call_local")
func set_target_player(player: Node) -> void:
	target_player = player
	
func _apply_movment(delta: float) -> void:
	if target_player != null:
		
		var player_direction: Vector2 = global_transform.origin.direction_to(target_player.global_transform.origin)
		player_direction *= movement_speed
		velocity = player_direction
	move_and_slide()
