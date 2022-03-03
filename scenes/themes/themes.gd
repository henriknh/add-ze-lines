extends MarginContainer

onready var node_gem_icon: TextureRect = $VBoxContainer/HBoxContainer/GemIcon
onready var node_gems_label: Label = $VBoxContainer/HBoxContainer/GemsLabel

func _ready():
	Storage.connect("storage_changed", self, "_update_ui")
	_update_ui()
	
	for i in range(Themes.themes.size()):
		var theme = Themes.themes[i]
		var theme_button = preload("res://scenes/themes/theme_button/theme_button.tscn").instance()
		theme_button.theme_index = i
		theme_button.theme_button = theme
		$VBoxContainer/GridContainer.add_child(theme_button)
		theme_button._update_ui()

func _update_ui():
	node_gem_icon.self_modulate = Themes.theme.on_background
	node_gems_label.text = Storage.get_gems() as String

func _on_back():
	get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")
