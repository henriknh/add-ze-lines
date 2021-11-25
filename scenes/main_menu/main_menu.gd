extends MarginContainer

class_name MainMenu

var next_chapter = null
var next_level = null

func _ready():
	$VBoxContainer/VBoxContainer/QuitDesktop.visible = !Data.is_mobile()
	
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
	
	$VBoxContainer/VBoxContainer/PlayContainer/Play.visible = next_chapter != null and next_level != null
	$VBoxContainer/VBoxContainer/PlayContainer/Play.text = "Continue" if storage_next else "Play"
	if next_chapter != null and next_level != null:
		$VBoxContainer/VBoxContainer/PlayContainer/ChapterAndLevelTitles.text = "Chapter %s, Level %s" % [next_chapter + 1, next_level + 1]
	else:
		$VBoxContainer/VBoxContainer/PlayContainer/ChapterAndLevelTitles.text = "All levels completed!"

func _on_continue():
	Level.init(next_chapter, next_level)
	
func _on_levels():
	get_tree().change_scene("res://scenes/levels/levels.tscn")
	
func _on_themes():
	get_tree().change_scene("res://scenes/themes/themes.tscn")
	
func _on_settings():
	get_tree().change_scene("res://scenes/settings/settings.tscn")

func _on_quit():
	get_tree().quit()
