extends MarginContainer

func _ready():
	$VBoxContainer/VBoxContainer/Editor.pressed = Storage.editor
	$VBoxContainer/VBoxContainer/Editor.visible = OS.is_debug_build()

func _on_editor_toggled(editor: bool):
	Storage.editor = editor

func _on_back():
	get_tree().change_scene("res://main_menu/main_menu.tscn")
