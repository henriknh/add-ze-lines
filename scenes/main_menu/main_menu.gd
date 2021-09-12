extends MarginContainer

class_name MainMenu

var next_chapter = null
var next_level = null

func _ready():
		
	var storage_next = Storage.get_last_completed_level()
	
	if storage_next:
		var last_chapter = null
		var last_level = null
		for chapter in Data.data:
			if chapter.title == storage_next[0]:
				last_chapter = chapter
				var idx_next_chapter = Data.data.find(last_chapter) + 1
				
				for level in last_chapter.levels:
					if level.title == storage_next[1]:
						last_level = level
				var idx_next_level = last_chapter.levels.find(last_level) + 1
				
				if idx_next_level > last_chapter.levels.size() - 1:
					if idx_next_chapter > Data.data.size() - 1:
						# All completed
						pass
					else:
						next_chapter = Data.data[idx_next_chapter]
						if next_chapter.levels.size():
							next_level = next_chapter.levels[0]
				else:
					next_chapter = last_chapter
					next_level = last_chapter.levels[idx_next_level]
	else:
		if Data.data.size():
			next_chapter = Data.data[0]
		if next_chapter and next_chapter.levels.size():
			next_level = next_chapter.levels[0]
		else:
			breakpoint
	
	$VBoxContainer/VBoxContainer/PlayContainer/Play.visible = next_chapter and next_level
	$VBoxContainer/VBoxContainer/PlayContainer/Play.text = "Continue" if storage_next else "Play"
	if next_chapter and next_level:
		$VBoxContainer/VBoxContainer/PlayContainer/ChapterAndLevelTitles.text = "%s, %s" % [next_chapter.title, next_level.title]
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
