extends MarginContainer

func _ready():
	if Data.data.size():
		Level.current_chapter = Data.data[0]
	if Level.current_chapter and Level.current_chapter.levels.size():
		Level.current_level = Level.current_chapter.levels[0]
		
	if Level.current_chapter and Level.current_level:
		$VBoxContainer/VBoxContainer/ContinueContainer.visible = true
		$VBoxContainer/VBoxContainer/ContinueContainer/ChapterAndLevelTitles.text = "%s, %s" % [Level.current_chapter.title, Level.current_level.title]
	else:
		$VBoxContainer/VBoxContainer/ContinueContainer.visible = false
		
	
func _on_continue():
	get_tree().change_scene("res://game/game.tscn")
	
func _on_levels():
	get_tree().change_scene("res://levels/levels.tscn")
	
func _on_settings():
	get_tree().change_scene("res://settings/settings.tscn")




