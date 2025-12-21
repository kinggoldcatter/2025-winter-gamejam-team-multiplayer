extends Area2D


func _process(delta: float) -> void:
	if %MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	
	global_position = get_global_mouse_position()
	for body: Node2D in get_overlapping_bodies() :
		if Input.is_action_just_pressed("primary") && body.is_in_group("enemy") :
			body.queue_free()
			%Flash.show()
			%FlashSound.play()
			%MobSound.play()
			await get_tree().create_timer(.3).timeout
			%Flash.hide()
			
