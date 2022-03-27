extends Control

var lines = {}
func _ready():
	yield(get_tree(), "idle_frame")
	
	for idx in range(1, Themes.theme.colors.size()):
		var line = ParallaxLine.new()
		get_tree().get_root().add_child(line)
		lines[idx] = line
	
	Themes.connect("theme_changed", self, "_theme_changed")
	_theme_changed()
	
func _theme_changed():
	for color_idx in lines:
		lines[color_idx].color = Themes.theme.colors[color_idx].background
