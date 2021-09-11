extends CanvasLayer

var next_chapter = null
var next_level = null

func _ready():
	Level.connect("level_changed", self, "on_level_changed")
	on_level_changed()

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
	$OnLevelComplete.visible = get_parent().level_complete

func _on_back():
	if Level.previous_scene:
		get_tree().change_scene(Level.previous_scene)
	else:
		get_tree().change_scene("res://main_menu/main_menu.tscn")

func _on_next_level():
	if next_chapter:
		Level.init(next_chapter, next_chapter.levels[0])
	elif next_level:
		Level.init(Level.current_chapter, next_level)

func _on_redo_level():
	Level.init(Level.current_chapter, Level.current_level)
