extends Control





func _on_copy_code_pressed() -> void:
	DisplayServer.clipboard_set(%LineEdit.text)


func _on_paste_code_pressed() -> void:
	%LineEdit.text = DisplayServer.clipboard_get()
