extends Control

var lines = {}
func _ready():
	yield(get_tree(), "idle_frame")

	print('parallax bg')
	
	for idx in range(1, Themes.theme.colors.size()):
		var line = ParallaxLine.new()
		get_tree().get_root().add_child(line)
		lines[idx] = line
	
	
	Themes.connect("theme_changed", self, "_theme_changed")
	_theme_changed()

func _theme_changed():
	for color_idx in lines:
		print(color_idx)
		##Themes.theme.colors[theme_color_index].background
