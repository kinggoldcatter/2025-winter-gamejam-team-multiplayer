class_name Player extends CharacterBody2D


@export var speed: float = 400

func _ready() -> void:
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func get_input() -> void:
	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta: float) -> void:
	if $MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	get_input()
	move_and_slide()

func get_name_tag() -> Label:
	return %NameLable

func get_cam_spot() -> Node2D:
	return %CamSpot
