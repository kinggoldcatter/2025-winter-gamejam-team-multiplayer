extends Control

func _on_join_lobby_pressed() -> void:
	get_tree().change_scene_to_file("res://lan_lobby_scene.tscn")

func _on_join_local_pressed() -> void:
	get_tree().change_scene_to_file("res://game_scene.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://credit_Scene.tscn")

func _on_quit_game_pressed() -> void:
	get_tree().quit()
