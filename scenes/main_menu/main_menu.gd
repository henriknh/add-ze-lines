extends Control

class_name MainMenu

onready var node_play: Button = $VBoxContainer/PlayContainer/Play
onready var node_current_level: Label = $VBoxContainer/PlayContainer/ChapterAndLevelTitles
onready var node_gem_icon: TextureRect = $VBoxContainer/ThemesContainer/HBoxContainer/GemIcon
onready var node_gem_label: Label = $VBoxContainer/ThemesContainer/HBoxContainer/GemsLabel
onready var node_quit: Button = $VBoxContainer/QuitDesktop

var next_chapter = null
var next_level = null

func _ready():
	$VBoxContainer/Settings.visible = OS.is_debug_build()
	
	node_gem_icon.self_modulate = Themes.theme.on_background
	node_gem_label.text = Storage.get_gems() as String
	node_quit.visible = !Data.is_mobile()
	#$AdMob.load_banner()
	#$AdMob.show_banner()
	
	if rect_size.x > 600:
		rect_size = Vector2(600, rect_size.y)
		
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
	Level.create(next_chapter, next_level)
	
func _on_levels():
	get_tree().change_scene("res://scenes/levels/levels.tscn")
	
func _on_themes():
	get_tree().change_scene("res://scenes/themes/themes.tscn")
	
func _on_settings():
	get_tree().change_scene("res://scenes/settings/settings.tscn")

func _on_quit():
	get_tree().quit()
