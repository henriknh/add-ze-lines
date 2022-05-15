extends Control

class_name MainMenu

onready var node_header: Label = $VBoxContainer/CenterContainer/Header
onready var node_play: Button = $VBoxContainer/PlayContainer/Play
onready var node_current_level: Label = $VBoxContainer/PlayContainer/ChapterAndLevelTitles
onready var node_gem_icon: TextureRect = $VBoxContainer/ThemesContainer/HBoxContainer/GemIcon
onready var node_gem_label: Label = $VBoxContainer/ThemesContainer/HBoxContainer/GemsLabel
onready var node_quit: Button = $VBoxContainer/QuitDesktop

onready var scene_levels = preload("res://scenes/levels/levels.tscn")
onready var scene_themes = preload("res://scenes/themes/themes.tscn")
onready var scene_settings = preload("res://scenes/settings/settings.tscn")

var next_chapter = null
var next_level = null

var header_click_count = 0

func _ready():
	yield(get_tree(), "idle_frame")
	
	if OS.is_debug_build():
		OS.window_fullscreen = false
		OS.window_borderless = false
		OS.window_size = Vector2(800, 600)
	
	$VBoxContainer/Settings.visible = false
	
	node_quit.visible = !Data.is_mobile()
	
	Storage.connect("storage_changed", self, "_update_ui")
	Themes.connect("theme_changed", self, "_update_ui")
	_update_ui()

func _update_ui():
	node_gem_icon.self_modulate = Themes.theme.on_background
	node_gem_label.text = Storage.get_gems() as String
	
	var storage_next = Storage.get_last_completed_level()
	if storage_next:
		var last_chapter = storage_next[0]
		var last_level = storage_next[1]
		
		var chapter_has_next_level = Data.data.size() > last_chapter and Data.data[last_chapter].levels.size() > last_level + 1
		
		if chapter_has_next_level:
			 next_chapter = last_chapter
			 next_level = last_level + 1
		else:
			var next_chapter_has_level = Data.data.size() > (last_chapter + 1) and Data.data[last_chapter + 1].levels.size() > 1
			if next_chapter_has_level:
				next_chapter = last_chapter + 1
				next_level = 0
	else:
		if Data.data.size():
			next_chapter = 0
		if Data.data[next_chapter] and Data.data[next_chapter].levels.size():
			next_level = 0
		else:
			breakpoint
	
	node_play.visible = next_chapter != null and next_level != null
	node_play.text = tr("CONTINUE") if storage_next else tr("PLAY")
	if next_chapter != null and next_level != null:
		node_current_level.text = tr("LEVEL") + " %s" % Level.get_absolute_level(next_chapter, next_level)
	else:
		node_current_level.text = tr("ALL_LEVELS_COMPLETED")
	
func _on_continue():
	SceneHandler.switch_to(SceneHandler.SCENES.GAME)
	Level.create(next_chapter, next_level)
	Level.initalize()
	
func _on_levels():
	#get_tree().change_scene_to(scene_levels)
	SceneHandler.switch_to(SceneHandler.SCENES.LEVELS)
	
func _on_themes():
	#get_tree().change_scene_to(scene_themes)
	SceneHandler.switch_to(SceneHandler.SCENES.THEMES)
	
func _on_settings():
	SceneHandler.switch_to(SceneHandler.SCENES.SETTINGS)
	#get_tree().change_scene_to(scene_settings)

func _on_quit():
	get_tree().quit()

func _on_header_click(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1) and OS.is_debug_build():
		header_click_count += 1
		prints("Header click:", header_click_count)
		
		if header_click_count >= 5:
			$VBoxContainer/Settings.visible = OS.is_debug_build()
