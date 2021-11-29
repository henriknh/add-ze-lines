extends Node

# https://lospec.com/palette-list/bloom-16

var on_background_black =  Color(0,0,0,0.87)
var on_background_white = Color(1,1,1,1)

var themes = [
	{
		"title": "LIGHT",
		"background": Color('#fffce8'),
		"on_background": Color('#110f3e'),
		"grid": Color("#110f3e"),
		"error": Color('#ff0f0f'),
		"on_error": on_background_white,
		"colors": [
			{
				'background': Color("#fff"),
				'on_background': on_background_black
			}, {
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
		"title": "DARK",
		"background": Color('#110f3e'),
		"on_background": on_background_white,
		"grid": Color(1,1,1,1),
		"error": Color('#ff0f0f'),
		"on_error": on_background_white,
		"colors": [
			{
				'background': Color("#fff"),
				'on_background': on_background_black
			}, {
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
		"title": "outrun", # https://lospec.com/palette-list/funkyfuture-8
		"background": Color('#2b0f54'),
		"on_background": on_background_white,
		"grid": Color('#ab1f65'),
		"error": Color('#ff0f0f'),
		"on_error": on_background_white,
		"colors": [
			{
				'background': Color("#fff"),
				'on_background': on_background_black
			}, {
				'background': Color('#ff4f69'),
				'on_background': on_background_white
			}, {
				'background': Color('#ff8142'),
				'on_background': on_background_white
			}, {
				'background': Color('#ffda45'),
				'on_background': on_background_black
			}, {
				'background': Color('#3368dc'),
				'on_background': on_background_white
			}, {
				'background': Color('#49e7ec'),
				'on_background': on_background_white
			}
		]
	}, {
		"title": "sunset", # https://lospec.com/palette-list/dialup-sunset
		"background": Color('#ffd7d7'),
		"on_background": on_background_black,
		"grid": Color('#f0a6a6'),
		"error": Color('#ff708b'),
		"on_error": on_background_white,
		"colors": [
			{
				'background': Color("#fff"),
				'on_background': on_background_black
			}, {
				'background': Color('#cd5981'),
				'on_background': on_background_white
			}, {
				'background': Color('#824882'),
				'on_background': on_background_white
			}, {
				'background': Color('#b26e9b'),
				'on_background': on_background_black
			}, {
				'background': Color('#dd94d2'),
				'on_background': on_background_white
			}, {
				'background': Color('#ebcbeb'),
				'on_background': on_background_black
			}
		]
	}
]

onready var theme
signal theme_changed
var current_theme_idx = -1

func _ready():
	Storage.connect("storage_changed", self, "_set_theme")
	_set_theme()
	
func _set_theme():
	var new_theme_idx = Storage.get_theme()
	
	if new_theme_idx == current_theme_idx:
		return
	
	theme = themes[new_theme_idx]
	current_theme_idx = new_theme_idx
	
	VisualServer.set_default_clear_color(theme.background)
	
	var _theme = preload("res://theme.tres")
	update_theme(_theme, theme)
	
	var _theme_solid = preload("res://theme_solid.tres")
	update_theme_solid(_theme_solid, theme)
	
	propagate_call("update")
	emit_signal("theme_changed")
	get_tree().reload_current_scene()

func update_theme(_theme: Theme, theme) -> Theme:
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
	
	return _theme

func update_theme_solid(_theme_solid: Theme, theme, inverted = false) -> Theme:
	
	_theme_solid = update_theme(_theme_solid, theme)
	var font_color_solid = theme.background if not inverted else theme.on_background
	var font_color_solid_disabled = font_color_solid
	font_color_solid_disabled.a = 0.38
	var font_color_solid_hover = font_color_solid
	font_color_solid_hover.lightened(0.15)
	var font_color_solid_pressed = font_color_solid
	font_color_solid_pressed.lightened(0.3)
	
	var background = theme.on_background if not inverted else theme.background
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
	
	return _theme_solid
