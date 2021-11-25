extends CanvasLayer

var next_chapter = null
var next_level = null

func _ready():
		
	var center = get_viewport().get_visible_rect().size.x / 2
	$OnLevelComplete/ConfettiLeft.position = Vector2(center - 150, -80)
	$OnLevelComplete/ConfettiRight.position = Vector2(center + 150, -80)
	
	_show_hide_ui()
	
	Themes.connect("theme_changed", self, "_on_theme_changed")
	_on_theme_changed()
	
	Level.connect("level_changed", self, "on_level_changed")
	on_level_changed()

func _on_theme_changed():
	$TopRight/MarginContainer/HBoxContainer/Restart.self_modulate = Themes.theme.on_background

func on_level_changed():
	$TopLeft/MarginContainer2/VBoxContainer/LevelTitle.text = "Level %d" % (Level.level + 1)
	$TopLeft/MarginContainer2/VBoxContainer/ChapterTitle.text = "Chapter %d" % (Level.chapter + 1)
	
	next_chapter = null
	next_level = null
	
	if Level.level + 1 < Level.chapter_data.levels.size():
		next_chapter = Level.chapter
		next_level = Level.level + 1
	elif Level.chapter + 1 < Data.data.size() and Data.data[Level.chapter + 1].levels.size():
		next_chapter = Level.chapter + 1
		next_level = 0
	
	$OnLevelComplete/MarginContainer/CenterContainer/VBoxContainer/NextLevel.visible = next_chapter or next_level
	$OnLevelComplete/MarginContainer/CenterContainer/VBoxContainer/NextLevel.text = "Next chapter" if next_chapter else "Next level"
	$OnLevelComplete/MarginContainer/CenterContainer/VBoxContainer/NoMoreLevels.visible = not next_chapter and not next_level

func _physics_process(delta):
	_show_hide_ui()
	
func _show_hide_ui():
	var line_has_two_points = false
	for line in get_tree().get_nodes_in_group("Line"):
		if line.points.size() >= 2:
			line_has_two_points = true
			break
	$TopRight/MarginContainer/HBoxContainer/Restart.visible = get_parent().level_ready and line_has_two_points
	
	if Storage.get_editor():
		$UIEditor.visible = true
		$OnLevelComplete.visible = false
	else:
		$UIEditor.visible = false
		$OnLevelComplete.visible = get_parent().level_ready and get_parent().level_complete

func _on_back():
	if Level.previous_scene:
		get_tree().change_scene(Level.previous_scene)
	else:
		get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")

func _on_next_level():
	Level.init(next_chapter, next_level)

func _on_redo_level():
	Level.init(Level.chapter, Level.level)
