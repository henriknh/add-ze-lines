extends Node

# https://lospec.com/palette-list/bloom-16

var on_background_black =  Color(0,0,0,0.87)
var on_background_white = Color(1,1,1,1)

var themes = [
	{
		"index": 0,
		"price": 0,
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
		"index": 0,
		"price": 0,
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
		"index": 1,
		"price": 10,
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
		"index": 2,
		"price": 10,
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
	}, {
		"index": 3,
		"price": 10,
		"title": "cryptic ocean", # https://lospec.com/palette-list/cryptic-ocean
		"background": Color('#95c5ac'),
		"on_background": on_background_white,
		"grid": on_background_black,
		"error": Color('#ff0f0f'),
		"on_error": on_background_white,
		"colors": [
			{
				'background': Color("#fff"),
				'on_background': on_background_black
			}, {
				'background': Color('#2a173b'),
				'on_background': on_background_white
			}, {
				'background': Color('#3f2c5f'),
				'on_background': on_background_white
			}, {
				'background': Color('#443f7b'),
				'on_background': on_background_white
			}, {
				'background': Color('#4c5c87'),
				'on_background': on_background_white
			}, {
				'background': Color('#69809e'),
				'on_background': on_background_white
			}
		]
	}, {
		"index": 4,
		"price": 10,
		"title": "curiosities", # https://lospec.com/palette-list/curiosities
		"background": Color('#46425e'),
		"on_background": on_background_white,
		"grid": Color('#46425e').lightened(0.2),
		"error": Color('#ff708b'),
		"on_error": on_background_white,
		"colors": [
			{
				'background': Color("#fff"),
				'on_background': on_background_black
			}, {
				'background': Color('#15788c'),
				'on_background': on_background_white
			}, {
				'background': Color('#00b9be'),
				'on_background': on_background_white
			}, {
				'background': Color('#ffeecc'),
				'on_background': on_background_black
			}, {
				'background': Color('#ffb0a3'),
				'on_background': on_background_white
			}, {
				'background': Color('#ff6973'),
				'on_background': on_background_white
			}
		]
	}, {
		"index": 5,
		"price": 20,
		"title": "inkpink", # https://lospec.com/palette-list/inkpink
		"background": Color('#ffffff'),
		"on_background": on_background_black,
		"grid": Color('#fff').darkened(0.2),
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
	}, {
		"index": 6,
		"price": 20,
		"title": "hotel paintings", # https://lospec.com/palette-list/hotel-paintings-6
		"background": Color('#f7ede2'),
		"on_background": on_background_black,
		"grid": Color('#f7ede2').darkened(0.2),
		"error": Color('#ff708b'),
		"on_error": on_background_white,
		"colors": [
			{
				'background': Color("#fff"),
				'on_background': on_background_black
			}, {
				'background': Color('#f6bd60'),
				'on_background': on_background_white
			}, {
				'background': Color('#f5cac3'),
				'on_background': on_background_black
			}, {
				'background': Color('#f28482'),
				'on_background': on_background_white
			}, {
				'background': Color('#84a59d'),
				'on_background': on_background_white
			}, {
				'background': Color('#3c3744'),
				'on_background': on_background_black
			}
		]
	}, {
		"index": 7,
		"price": 20,
		"title": "stormy", # https://lospec.com/palette-list/stormy-6
		"background": Color('#7f9860'),
		"on_background": on_background_white,
		"grid": Color('#7f9860').lightened(0.2),
		"error": Color('#ff708b'),
		"on_error": on_background_white,
		"colors": [
			{
				'background': Color("#fff"),
				'on_background': on_background_black
			}, {
				'background': Color('#f8eebf'),
				'on_background': on_background_black
			}, {
				'background': Color('#edbb70'),
				'on_background': on_background_white
			}, {
				'background': Color('#a95a3f'),
				'on_background': on_background_white
			}, {
				'background': Color('#242828'),
				'on_background': on_background_white
			}, {
				'background': Color('#3a5043'),
				'on_background': on_background_white
			}
		]
	}, {
		"index": 8,
		"price": 40,
		"title": "puffball", # https://lospec.com/palette-list/puffball-8
		"background": Color('#eedbc8'),
		"on_background": on_background_black,
		"grid": Color('#eedbc8').darkened(0.2),
		"error": Color('#ff708b'),
		"on_error": on_background_white,
		"colors": [
			{
				'background': Color("#fff"),
				'on_background': on_background_black
			}, {
				'background': Color('#e0bb68'),
				'on_background': on_background_white
			}, {
				'background': Color('#97b34e'),
				'on_background': on_background_white
			}, {
				'background': Color('#d58353'),
				'on_background': on_background_white
			}, {
				'background': Color('#548b71'),
				'on_background': on_background_white
			}, {
				'background': Color('#5a473e'),
				'on_background': on_background_white
			}
		]
	}, {
		"index": 9,
		"price": 40,
		"title": "vintage voltage", # https://lospec.com/palette-list/vintage-voltage
		"background": Color('#191930'),
		"on_background": on_background_white,
		"grid": Color('#191930').lightened(0.2),
		"error": Color('#ff708b'),
		"on_error": on_background_white,
		"colors": [
			{
				'background': Color("#fff"),
				'on_background': on_background_black
			}, {
				'background': Color('#263d6e'),
				'on_background': on_background_white
			}, {
				'background': Color('#2f729e'),
				'on_background': on_background_white
			}, {
				'background': Color('#eba254'),
				'on_background': on_background_white
			}, {
				'background': Color('#f5d689'),
				'on_background': on_background_black
			}, {
				'background': Color('#fff5d9'),
				'on_background': on_background_black
			}
		]
	}, {
		"index": 10,
		"price": 40,
		"title": "sunny days", # https://lospec.com/palette-list/sunny-days
		"background": Color('#f7ffed'),
		"on_background": on_background_black,
		"grid": Color('#f7ffed').darkened(0.2),
		"error": Color('#ff708b'),
		"on_error": on_background_white,
		"colors": [
			{
				'background': Color("#fff"),
				'on_background': on_background_black
			}, {
				'background': Color('#00177c'),
				'on_background': on_background_white
			}, {
				'background': Color('#84396c'),
				'on_background': on_background_white
			}, {
				'background': Color('#598344'),
				'on_background': on_background_white
			}, {
				'background': Color('#d09071'),
				'on_background': on_background_white
			}, {
				'background': Color('#eace75'),
				'on_background': on_background_black
			}
		]
	}, {
		"index": 11,
		"price": 60,
		"title": "theo", # https://lospec.com/palette-list/theo
		"background": Color('#2e243f'),
		"on_background": on_background_white,
		"grid": Color('#2e243f').lightened(0.2),
		"error": Color('#ff708b'),
		"on_error": on_background_white,
		"colors": [
			{
				'background': Color("#fff"),
				'on_background': on_background_black
			}, {
				'background': Color('#d3473d'),
				'on_background': on_background_white
			}, {
				'background': Color('#f6ad0f'),
				'on_background': on_background_white
			}, {
				'background': Color('#f5efeb'),
				'on_background': on_background_black
			}, {
				'background': Color('#86bcd1'),
				'on_background': on_background_white
			}, {
				'background': Color('#316a96'),
				'on_background': on_background_white
			}
		]
	}, {
		"index": 12,
		"price": 60,
		"title": "cozy christmas", # https://lospec.com/palette-list/cozy-christmas
		"background": Color('#121a16'),
		"on_background": on_background_white,
		"grid": Color('#121a16').lightened(0.2),
		"error": Color('#ff708b'),
		"on_error": on_background_white,
		"colors": [
			{
				'background': Color("#fff"),
				'on_background': on_background_black
			}, {
				'background': Color('#1f3325'),
				'on_background': on_background_white
			}, {
				'background': Color('#36593b'),
				'on_background': on_background_white
			}, {
				'background': Color('#80193b'),
				'on_background': on_background_white
			}, {
				'background': Color('#cc2944'),
				'on_background': on_background_white
			}, {
				'background': Color('#ffb3bf'),
				'on_background': on_background_black
			}
		]
	}, {
		"index": 13,
		"price": 60,
		"title": "journey", # https://lospec.com/palette-list/journey-6
		"background": Color('#261f1f'),
		"on_background": on_background_white,
		"grid": Color('#261f1f').lightened(0.2),
		"error": Color('#ff708b'),
		"on_error": on_background_white,
		"colors": [
			{
				'background': Color("#fff"),
				'on_background': on_background_black
			}, {
				'background': Color('#ff2d2d'),
				'on_background': on_background_white
			}, {
				'background': Color('#0f4d32'),
				'on_background': on_background_white
			}, {
				'background': Color('#319835'),
				'on_background': on_background_white
			}, {
				'background': Color('#f1f1d1'),
				'on_background': on_background_black
			}, {
				'background': Color('#c0aa74'),
				'on_background': on_background_white
			}
		]
	}, {
		"index": 14,
		"price": 100,
		"title": "inkra",
		"background": Color('#261f1f'),
		"on_background": on_background_white,
		"grid": Color('#261f1f').lightened(0.2),
		"error": Color('#ff708b'),
		"on_error": on_background_white,
		"colors": [
			{
				'background': Color("#fff"),
				'on_background': on_background_black
			}, {
				'background': Color('#ff2d2d'),
				'on_background': on_background_white
			}, {
				'background': Color('#0f4d32'),
				'on_background': on_background_white
			}, {
				'background': Color('#319835'),
				'on_background': on_background_white
			}, {
				'background': Color('#f1f1d1'),
				'on_background': on_background_black
			}, {
				'background': Color('#c0aa74'),
				'on_background': on_background_white
			}
		]
	}
]

onready var theme
signal theme_changed
signal theme_purchase_initiated
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
	#get_tree().reload_current_scene()

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
			
		if node_type == 'PanelContainer':
			var style_box: StyleBoxFlat = _theme.get_stylebox("panel", node_type)
			style_box.bg_color = theme.background
			style_box.bg_color.a = 1
			style_box.border_color = theme.on_background
			style_box.shadow_color = theme.background
			style_box.shadow_color.a = 0.6
			_theme.set_stylebox("panel", node_type, style_box)
	
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
		
		if node_type == 'Label':
			_theme_solid.set_color("font_color", node_type, background)
			
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
		if _theme_solid.has_stylebox("panel", node_type):
			var style_box_pressed = _theme_solid.get_stylebox("panel", node_type)
			style_box_pressed.border_color = background
			_theme_solid.set_stylebox("panel", node_type, style_box_pressed)
	
	return _theme_solid
