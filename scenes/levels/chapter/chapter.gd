extends Control

var chapter: int = -1
var chapter_data = null
onready var color_rect = $HBoxContainer/ColorRect
onready var levels_outlet = $HBoxContainer/GridContainer

func _ready():
	chapter_data = Data.data[chapter]
	
	color_rect.color = Themes.theme.colors[chapter + 1].background
	
	levels_outlet.columns = 1 if Storage.get_editor() else 4
	
	for level in range(chapter_data.levels.size()):
		var level_instance = preload("res://scenes/levels/chapter/level/level.tscn").instance()
		level_instance.chapter = chapter
		level_instance.level = level
		levels_outlet.add_child(level_instance)

	if Storage.get_editor():
		var button_new_level = Button.new()
		button_new_level.theme = preload("res://scenes/levels/level_button.tres")
		button_new_level.text = "New level"
		button_new_level.rect_min_size = Vector2(60, 40)
		button_new_level.focus_mode = Control.FOCUS_NONE
		button_new_level.connect("pressed", self, "_on_new_level")
		levels_outlet.add_child(button_new_level)

func _on_new_level():
	Data.data[chapter].levels.append({
		"id": Data.generate_id(),
		"grid_size": [5,5],
		"operators": []
	})
	Data.save_data()
