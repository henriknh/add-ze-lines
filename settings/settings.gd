extends MarginContainer

func _ready():
	$VBoxContainer/VBoxContainer/Editor.pressed = Settings.editor
	$VBoxContainer/VBoxContainer/Editor.visible = OS.is_debug_build()

func _on_editor_toggled(editor: bool):
	Settings.editor = editor

func _on_back():
	get_tree().change_scene("res://menu/menu.tscn")
