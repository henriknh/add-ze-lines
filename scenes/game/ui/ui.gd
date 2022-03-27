extends CanvasLayer

var next_chapter = null
var next_level = null

func _ready():
	var center = get_viewport().get_visible_rect().size.x / 2
	$OnLevelComplete/ConfettiLeft.position = Vector2(center - 150, -80)
	$OnLevelComplete/ConfettiRight.position = Vector2(center + 150, -80)
	
	$AdMob.load_banner()
	$AdMob.load_rewarded_video()
	
	_show_hide_ui()
	
	Themes.connect("theme_changed", self, "_on_theme_changed")
	_on_theme_changed()
	
	Level.connect("level_changed", self, "on_level_changed")
	on_level_changed()

func _on_theme_changed():
	$TopRight/MarginContainer/HBoxContainer/Restart.self_modulate = Themes.theme.on_background
	$TopRight/MarginContainer/HBoxContainer/Skip.self_modulate = Themes.theme.on_background
	$TopRight/MarginContainer/HBoxContainer/Back.self_modulate = Themes.theme.on_background

func on_level_changed():
	#yield(get_tree(), "idle_frame")
	var prev_levels = 0
	for prev_chapter in range(Level.chapter):
		prev_levels += Data.data[prev_chapter].levels.size()
	$TopLeft/MarginContainer2/VBoxContainer/LevelTitle.text = tr("LEVEL") + " %d" % (prev_levels + Level.level + 1)
	$TopLeft/MarginContainer2/VBoxContainer/ChapterTitle.text = tr("CHAPTER") + " %d" % (Level.chapter + 1)
	
	next_chapter = null
	next_level = null
	
	if Level.level + 1 < Data.data[Level.chapter].levels.size():
		next_chapter = Level.chapter
		next_level = Level.level + 1
	elif Level.chapter + 1 < Data.data.size() and Data.data[Level.chapter + 1].levels.size():
		next_chapter = Level.chapter + 1
		next_level = 0
	
	$OnLevelComplete/MarginContainer/CenterContainer/VBoxContainer/NextLevel.visible = next_chapter or next_level
	$OnLevelComplete/MarginContainer/CenterContainer/VBoxContainer/NextLevel.text = tr("NEXT_CHAPTER") if next_chapter else tr("NEXT_LEVEL")
	$OnLevelComplete/MarginContainer/CenterContainer/VBoxContainer/NoMoreLevels.visible = not next_chapter and not next_level
	var level_data = Data.data[Level.chapter].levels[Level.level]
	var level_completed = Storage.get_level_completed(level_data.id)
	var level_skipped = Storage.get_level_skipped(level_data.id)
	$TopRight/MarginContainer/HBoxContainer/Skip.visible = not level_completed or level_skipped
	if level_skipped:
		$TopRight/MarginContainer/HBoxContainer/Skip.disabled = true
		$TopRight/MarginContainer/HBoxContainer/Skip.self_modulate.a = 0.38
	

func _physics_process(delta):
	_show_hide_ui()
	
func _show_hide_ui():
	var line_has_two_points = false
	for line in get_tree().get_nodes_in_group("Line"):
		if line.points.size() >= 2:
			line_has_two_points = true
			break
	$TopRight/MarginContainer/HBoxContainer/Restart.visible = Level.level_ready and line_has_two_points
	
	if Storage.get_editor():
		$UIEditor.visible = true
		$OnLevelComplete.visible = false
	else:
		$UIEditor.visible = false
		$OnLevelComplete.visible = Level.level_ready and Level.level_complete

func _on_back():
#	if Level.previous_scene:
#		get_tree().change_scene(Level.previous_scene)
#	else:
#		get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")
	SceneHandler.back()

func _on_next_level():
	Level.create(next_chapter, next_level)
	Level.initalize()

func _on_redo_level():
	#Level.create(Level.chapter, Level.level)
	Level.initalize()
	
func _on_skip_level():
	$AdMob.show_rewarded_video()
	
	_on_AdMob_rewarded(-1, -1)


func _on_AdMob_rewarded_video_loaded():
	print("_on_AdMob_rewarded_video_loaded")
	pass # Replace with function body.


func _on_AdMob_rewarded_video_opened():
	print("_on_AdMob_rewarded_video_opened")
	pass # Replace with function body.


func _on_AdMob_rewarded(currency, ammount):
	prints("_on_AdMob_rewarded", currency, ammount)
	Storage.set_level_skipped(Level.level_data.id)
	_on_next_level()
