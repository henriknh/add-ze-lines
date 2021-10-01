extends Node

class_name Colors

export(Color) var background = Color.black
export(Color) var on_background = Color.white

func get_from_theme(idx: int):
	var color = Themes.theme.colors[idx % Themes.theme.colors.size()]
	background = color.background
	on_background = color.on_background

func reset():
	background = Themes.theme.background
	on_background = Themes.theme.on_background
