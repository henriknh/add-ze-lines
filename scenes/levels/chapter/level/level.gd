extends Control

onready var node_color_rect: ColorRect = $ColorRect
onready var node_skipped = $Skipped
onready var node_play = $Buttons/Play
onready var node_move = $Buttons/Move
onready var node_move_up = $Buttons/Move/Up
onready var node_move_down = $Buttons/Move/Down
onready var node_delete = $Buttons/Delete

var chapter: int = -1
var level: int = -1
var theme_color = null setget set_theme_color

func _ready():
	
	Storage.connect("storage_changed",self, "_update_ui")
	_update_ui()
	
	node_play.text = Level.get_absolute_level(chapter, level) as String
	
func _update_ui():
	if Data.data.size() == chapter:
		queue_free()
		return
	
	if Data.data[chapter].levels.size() == level:
		queue_free()
		return
	
	# Check if should be disabled
	if Storage.get_editor():
		node_play.disabled = false
	elif (level - 1) < 0 and (chapter - 1) < 0:
		node_play.disabled = false
	elif (level - 1) < 0:
		var prev_chapter = Data.data[chapter - 1]
		var prev_level = prev_chapter.levels[prev_chapter.levels.size() - 1]
		node_play.disabled = not Storage.get_level_completed(prev_level.id)
	else:
		var curr_chapter = Data.data[chapter]
		var prev_level = curr_chapter.levels[level - 1]
		node_play.disabled = not Storage.get_level_completed(prev_level.id)
	
	var level_data = Data.data[chapter].levels[level]
	node_skipped.visible = not Storage.get_editor() and Storage.get_level_skipped(level_data.id)
	
	node_move.visible = Storage.get_editor()
	node_move_up.disabled = level == 0
	node_move_down.disabled = (level + 1) == Data.data[chapter].levels.size()
	node_delete.visible = Storage.get_editor()

func set_theme_color(_theme_color):
	theme_color = _theme_color
	var disabled_color = Color(theme_color.background.r, theme_color.background.g, theme_color.background.b, 0.38)
	
	var style_box_normal = StyleBoxFlat.new()
	style_box_normal.bg_color = theme_color.background
	var style_box_hover = StyleBoxFlat.new()
	style_box_hover.bg_color = theme_color.background.darkened(0.05)
	var style_box_pressed = StyleBoxFlat.new()
	style_box_pressed.bg_color = theme_color.background.darkened(0.1)
	var style_box_disabled = StyleBoxFlat.new()
	style_box_disabled.bg_color = disabled_color
	
	for button in [node_play, node_move_up, node_move_down, node_delete]:
		button.add_color_override("font_color", theme_color.on_background)
		button.add_stylebox_override("normal", style_box_normal)
		button.add_stylebox_override("hover", style_box_hover)
		button.add_stylebox_override("pressed", style_box_pressed)
		button.add_stylebox_override("disabled", style_box_disabled)
	
	node_skipped.self_modulate = theme_color.on_background
	node_color_rect.color = Themes.theme.background
	
func _on_play():
	SceneHandler.switch_to(SceneHandler.SCENES.GAME)
	Level.create(chapter, level)
	Level.initalize()

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
