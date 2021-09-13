extends Node

# https://lospec.com/palette-list/bloom-16

var on_background_black =  Color(0,0,0,0.87)
var on_background_white = Color(1,1,1,1)

var themes = [
	{
		"title": "light",
		"background": Color('#fffce8'),
		"on_background": Color('#110f3e'),
		"grid": Color("#110f3e"),
		"error": Color('#ff0f0f'),
		"on_error": on_background_white,
		"colors": [
			{
				'background': Color('#afe48d'),
				'on_background': on_background_black
			}, {
				'background': Color('#ff9072'),
				'on_background': on_background_white
			}, {
				'background': Color('#ffc567'),
				'on_background': on_background_white
			}, {
				'background': Color('#2b75b7'),
				'on_background': on_background_white
			}, {
				'background': Color('#371a77'),
				'on_background': on_background_white
			}
		]
	}, {
		"title": "dark",
		"background": Color('#110f3e'),
		"on_background": on_background_white,
		"grid": Color(1,1,1,1),
		"error": Color('#ff0f0f'),
		"on_error": on_background_white,
		"colors": [
			{
				'background': Color('#afe48d'),
				'on_background': on_background_black
			}, {
				'background': Color('#ff9072'),
				'on_background': on_background_white
			}, {
				'background': Color('#ffc567'),
				'on_background': on_background_white
			}, {
				'background': Color('#2b75b7'),
				'on_background': on_background_white
			}, {
				'background': Color('#371a77'),
				'on_background': on_background_white
			}
		]
	}
]

onready var theme
signal theme_changed

func _ready():
	set_theme(0)

func set_theme(idx: int):
	theme = themes[idx]
	
	VisualServer.set_default_clear_color(theme.background)
	
	var _theme = preload("res://theme.tres")
	
	var font_color = theme.on_background
	var font_color_disabled = font_color
	font_color_disabled.a = 0.38
	var font_color_hover = font_color
	font_color_hover.lightened(0.15)
	var font_color_pressed = font_color
	font_color_pressed.lightened(0.3)
	
	for node_type in _theme.get_type_list(""):
		if _theme.has_color("font_color", node_type):
			_theme.set_color("font_color", node_type, font_color)
		if _theme.has_color("font_color_disabled", node_type):
			_theme.set_color("font_color_disabled", node_type, font_color_disabled)
		if _theme.has_color("font_color_hover", node_type):
			_theme.set_color("font_color_hover", node_type, font_color_hover)
		if _theme.has_color("font_color_pressed", node_type):
			_theme.set_color("font_color_pressed", node_type, font_color_pressed)
	
	
	var _theme_solid = preload("res://theme_solid.tres")
	
	var font_color_solid = theme.background
	var font_color_solid_disabled = font_color_solid
	font_color_solid_disabled.a = 0.38
	var font_color_solid_hover = font_color_solid
	font_color_solid_hover.lightened(0.15)
	var font_color_solid_pressed = font_color_solid
	font_color_solid_pressed.lightened(0.3)
	
	var background = theme.on_background
	var background_disabled = background
	background_disabled.a = 0.38
	var background_hover = background
	background_hover.lightened(0.15)
	var background_pressed = background
	background_pressed.lightened(0.3)
	
	for node_type in _theme_solid.get_type_list(""):
		
		if _theme_solid.has_color("font_color", node_type):
			_theme_solid.set_color("font_color", node_type, font_color_solid)
		if _theme_solid.has_color("font_color_disabled", node_type):
			_theme_solid.set_color("font_color_disabled", node_type, font_color_solid_disabled)
		if _theme_solid.has_color("font_color_hover", node_type):
			_theme_solid.set_color("font_color_hover", node_type, font_color_solid_hover)
		if _theme_solid.has_color("font_color_pressed", node_type):
			_theme_solid.set_color("font_color_pressed", node_type, font_color_solid_pressed)
		
		if _theme_solid.has_stylebox("disabled", node_type):
			var style_box_disabled = _theme_solid.get_stylebox("disabled", node_type)
			style_box_disabled.bg_color = background_disabled
			_theme_solid.set_stylebox("disabled", node_type, style_box_disabled)
		if _theme_solid.has_stylebox("hover", node_type):
			var style_box_hover = _theme_solid.get_stylebox("hover", node_type)
			style_box_hover.bg_color = background_hover
			_theme_solid.set_stylebox("hover", node_type, style_box_hover)
		if _theme_solid.has_stylebox("normal", node_type):
			var style_box_normal = _theme_solid.get_stylebox("normal", node_type)
			style_box_normal.bg_color = background
			_theme_solid.set_stylebox("normal", node_type, style_box_normal)
		if _theme_solid.has_stylebox("pressed", node_type):
			var style_box_pressed = _theme_solid.get_stylebox("pressed", node_type)
			style_box_pressed.bg_color = background_pressed
			_theme_solid.set_stylebox("pressed", node_type, style_box_pressed)
	
	propagate_call("update")
	emit_signal("theme_changed")
