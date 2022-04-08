extends GridContainer

var chapter: int = -1
var chapter_data = null
onready var button_new_level = Button.new()
var levels = []

func _ready():
	chapter_data = Data.data[chapter]
	
	for level in range(chapter_data.levels.size()):
		var level_instance = preload("res://scenes/levels/chapter/level/level.tscn").instance()
		level_instance.chapter = chapter
		level_instance.level = level
		add_child(level_instance)
		levels.append(level_instance)

	button_new_level.theme = preload("res://scenes/levels/level_button.tres")
	button_new_level.text = "New level"
	button_new_level.rect_min_size = Vector2(60, 40)
	button_new_level.focus_mode = Control.FOCUS_NONE
	button_new_level.connect("pressed", self, "_on_new_level")
	add_child(button_new_level)
	
	Storage.connect("storage_changed", self, "_update_ui")
	Themes.connect("theme_changed", self, "_update_ui")
	get_tree().get_root().connect("size_changed", self, "_on_resize")
	_update_ui()

func _on_new_level():
	Data.data[chapter].levels.append({
		"id": Data.generate_id(),
		"grid_size": [5,5],
		"operators": []
	})
	Data.save_data()

func _update_ui():
	if Data.data.size() < chapter - 1:
		queue_free()
		return
	
	_on_resize()
	
	button_new_level.visible = Storage.get_editor()
	for level in levels:
		level.theme_color = Themes.theme.colors[chapter + 1]

func _on_resize():
	if Storage.get_editor():
		columns = 1
	else:
		columns = int(ceil((get_viewport().size.x - 100) / 75))
