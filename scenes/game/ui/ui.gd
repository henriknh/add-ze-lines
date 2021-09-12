extends CanvasLayer

var next_chapter = null
var next_level = null

func _ready():
		
	var center = get_viewport().get_visible_rect().size.x / 2
	$OnLevelComplete/ConfettiLeft.position = Vector2(center - 150, -80)
	$OnLevelComplete/ConfettiRight.position = Vector2(center + 150, -80)

	print(get_viewport().get_visible_rect().size.y - 80)
	
	_show_hide_ui()
	
	Themes.connect("theme_changed", self, "_on_theme_changed")
	_on_theme_changed()
	
	Level.connect("level_changed", self, "on_level_changed")
	on_level_changed()

func _on_theme_changed():
	$TopRight/MarginContainer/HBoxContainer/Restart.self_modulate = Themes.theme.on_background

func on_level_changed():
	$TopLeft/MarginContainer2/VBoxContainer/LevelTitle.text = Level.current_level.title
	$TopLeft/MarginContainer2/VBoxContainer/ChapterTitle.text = Level.current_chapter.title
	
	next_chapter = null
	next_level = null
	
	var idx_level = Level.current_chapter.levels.find(Level.current_level) + 1
	
	if idx_level > Level.current_chapter.levels.size() - 1:
		var idx_chapter = Data.data.find(Level.current_chapter) + 1
		if idx_chapter < Data.data.size():
			next_chapter = Data.data[idx_chapter]
	else:
		next_level = Level.current_chapter.levels[idx_level]
	
	$OnLevelComplete/MarginContainer/CenterContainer/VBoxContainer/NextLevel.visible = next_chapter or next_level
	$OnLevelComplete/MarginContainer/CenterContainer/VBoxContainer/NextLevel.text = "Next chapter" if next_chapter else "Next level"
	$OnLevelComplete/MarginContainer/CenterContainer/VBoxContainer/NoMoreLevels.visible = not next_chapter and not next_level

func _physics_process(delta):
	_show_hide_ui()
	
func _show_hide_ui():
	$OnLevelComplete.visible = get_parent().level_ready and get_parent().level_complete
	$TopRight/MarginContainer/HBoxContainer/Restart.visible = get_parent().level_ready and get_tree().get_nodes_in_group("Line").size() > 0

func _on_back():
	if Level.previous_scene:
		get_tree().change_scene(Level.previous_scene)
	else:
		get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")

func _on_next_level():
	if next_chapter:
		Level.init(next_chapter, next_chapter.levels[0])
	elif next_level:
		Level.init(Level.current_chapter, next_level)

func _on_redo_level():
	Level.init(Level.current_chapter, Level.current_level)
