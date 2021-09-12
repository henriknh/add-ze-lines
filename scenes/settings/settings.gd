extends MarginContainer

func _ready():
	$VBoxContainer/VBoxContainer/Editor.pressed = Storage.editor
	$VBoxContainer/VBoxContainer/Editor.visible = OS.is_debug_build()
	Themes.connect("theme_changed", self, "_on_theme_changed")
	_on_theme_changed()

func _on_theme_changed():
	$VBoxContainer/VBoxContainer/Editor.self_modulate = Themes.theme.on_background

func _on_editor_toggled(editor: bool):
	Storage.editor = editor

func _on_back():
	get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")
