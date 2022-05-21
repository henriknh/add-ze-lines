extends Control

onready var node_gem_icon: TextureRect = $VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/GemIcon
onready var node_gems_label: Label = $VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/GemsLabel
onready var node_grid: GridContainer = $VBoxContainer/MarginContainer3/ScrollContainer/GridContainer
func _ready():
	yield(get_tree(), "idle_frame")
	Storage.connect("storage_changed", self, "_update_ui")
	Themes.connect("theme_changed", self, "_update_ui")
	
	get_tree().get_root().connect("size_changed", self, "_on_resize")
	_on_resize()
	_update_ui()
	
	for i in range(Themes.themes.size()):
		var theme = Themes.themes[i]
		var theme_button = preload("res://scenes/themes/theme_button/theme_button.tscn").instance()
		theme_button.theme_index = i
		theme_button.theme_button = theme
		node_grid.add_child(theme_button)
		theme_button._update_ui()

func _update_ui():
	node_gem_icon.self_modulate = Themes.theme.on_background
	node_gems_label.text = Storage.get_gems() as String

func _on_back():
	#get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")
	SceneHandler.back()
	
func _on_resize():
	if not SceneHandler.is_current(SceneHandler.SCENES.THEMES):
		return
	
	if Storage.get_editor():
		node_grid.columns = 1
	else:
		var display_width = OS.window_size.x
		node_grid.columns = int(floor((display_width - (24 + 32*2)) / 340))
