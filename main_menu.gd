extends Control

var lobby_scene: Control

func _ready() -> void:
	lobby_scene = preload("res://online_join.tscn").instantiate()
	get_tree().root.add_child.call_deferred(lobby_scene)
	lobby_scene.hide()

func _on_join_lobby_pressed() -> void:
	hide()
	lobby_scene.show()
#	get_tree().change_scene_to_file("res://lan_lobby_scene.tscn")

func _on_join_local_pressed() -> void:
#	get_tree().change_scene_to_file("res://game_scene.tscn")
	pass

func _on_credits_pressed() -> void:
	pass
#	get_tree().change_scene_to_file("res://credit_Scene.tscn")

func _on_quit_game_pressed() -> void:
	get_tree().quit()
