extends Control

onready var node_play = $Play
onready var node_move = $Move
onready var node_move_up = $Move/Up
onready var node_move_down = $Move/Down
onready var node_delete = $Delete

var chapter: int = -1
var level: int = -1

func _ready():
	
	# Text
	var prev_levels = 0
	for prev_chapter in range(chapter):
		prev_levels += Data.data[prev_chapter].levels.size()
	node_play.text = (prev_levels + level + 1) as String
	
	# Check if should be disabled
	if Storage.get_editor():
		node_play.disabled = false
	elif (level - 1) < 0 and (chapter - 1) < 0:
		node_play.disabled = false
	elif (level - 1) < 0:
		node_play.disabled = not Storage.get_level_completed(chapter - 1, Data.data[chapter - 1].levels.size() - 1)
	else:
		node_play.disabled = not Storage.get_level_completed(chapter, level - 1)
	
	var theme_color = Themes.theme.colors[chapter + 1]
	var button_theme: Theme = node_play.theme.duplicate(true)
	
	for node_type in button_theme.get_type_list(""):
		if button_theme.has_color("font_color", node_type):
			button_theme.set_color("font_color", node_type, theme_color.on_background)
		if button_theme.has_color("font_color_disabled", node_type):
			button_theme.set_color("font_color_disabled", node_type, theme_color.on_background)
		if button_theme.has_color("font_color_hover", node_type):
			button_theme.set_color("font_color_hover", node_type, theme_color.on_background)
		if button_theme.has_color("font_color_pressed", node_type):
			button_theme.set_color("font_color_pressed", node_type, theme_color.on_background)
		
		if button_theme.has_stylebox("disabled", node_type):
			var disabled_color = Color(theme_color.background.r, theme_color.background.g, theme_color.background.b, 0.38)
			var style_box_disabled = button_theme.get_stylebox("disabled", node_type)
			style_box_disabled.bg_color = disabled_color
			button_theme.set_stylebox("disabled", node_type, style_box_disabled)
		if button_theme.has_stylebox("hover", node_type):
			var style_box_hover = button_theme.get_stylebox("hover", node_type)
			style_box_hover.bg_color = theme_color.background.lightened(0.2)
			button_theme.set_stylebox("hover", node_type, style_box_hover)
		if button_theme.has_stylebox("normal", node_type):
			var style_box_normal = button_theme.get_stylebox("normal", node_type)
			style_box_normal.bg_color = theme_color.background
			button_theme.set_stylebox("normal", node_type, style_box_normal)
		if button_theme.has_stylebox("pressed", node_type):
			var style_box_pressed = button_theme.get_stylebox("pressed", node_type)
			style_box_pressed.bg_color = theme_color.background.lightened(0.4)
			button_theme.set_stylebox("pressed", node_type, style_box_pressed)
			
	for button in [node_play, node_move_up, node_move_down, node_delete]:
		button.theme = button_theme
	
	node_move.visible = Storage.get_editor()
	node_move_up.disabled = level == 0
	node_move_down.disabled = (level + 1) == Data.data[chapter].levels.size()
	node_delete.visible = Storage.get_editor()

func _on_play():
	Level.create(chapter, level)

func _on_move(dir: int):
	var chapter_data = Data.data[chapter]
	var level_data = chapter_data.levels[level]
	chapter_data.levels.remove(level)
	chapter_data.levels.insert(level + dir, level_data)
	Data.save_data()

func _on_delete():
	var chapter_data = Data.data[chapter]
	chapter_data.levels.remove(level)
	Data.save_data()
