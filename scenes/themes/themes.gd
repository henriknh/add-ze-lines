extends MarginContainer

var _theme_solid = preload("res://theme_solid.tres")

func _ready():
	for i in range(Themes.themes.size()):
		var theme = Themes.themes[i]
		var button = Button.new()
		button.text = theme.title
		button.theme = Themes.update_theme_solid(_theme_solid.duplicate(true), theme)
		button.connect("pressed", self, "_on_set_theme", [i])
		$VBoxContainer/GridContainer.add_child(button)

func _on_set_theme(i):
	Themes.set_theme(i)
	get_tree().change_scene("res://scenes/themes/themes.tscn")
	
func _on_back():
	get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")
