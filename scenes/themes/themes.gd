extends MarginContainer

var _theme_solid = preload("res://theme_solid.tres")
onready var node_gem_icon: TextureRect = $VBoxContainer/HBoxContainer/GemIcon
onready var node_gems_label: Label = $VBoxContainer/HBoxContainer/GemsLabel

func _ready():
	_update_ui()
	for i in range(Themes.themes.size()):
		var theme = Themes.themes[i]
		var button = Button.new()
		button.text = theme.title
		button.theme = Themes.update_theme_solid(_theme_solid.duplicate(true), theme, true)
		button.connect("pressed", self, "_on_set_theme", [i])
		$VBoxContainer/GridContainer.add_child(button)
	
	
func _on_set_theme(idx: int):
	Storage.set_theme(idx)
	_update_ui()

func _update_ui():
	node_gem_icon.self_modulate = Themes.theme.on_background
	node_gems_label.text = Storage.get_gems() as String

func _on_back():
	get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")
