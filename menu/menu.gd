extends MarginContainer

var continue_chapter = null
var continue_level = null

func _ready():
	if Data.data.size():
		continue_chapter = Data.data[0]
	if continue_chapter and continue_chapter.levels.size():
		continue_level = continue_chapter.levels[0]
		
	if continue_chapter and continue_level:
		$VBoxContainer/VBoxContainer/ContinueContainer.visible = true
		$VBoxContainer/VBoxContainer/ContinueContainer/ChapterAndLevelTitles.text = "%s, %s" % [continue_chapter.title, continue_level.title]
	else:
		$VBoxContainer/VBoxContainer/ContinueContainer.visible = false
		
	
func _on_continue():
	Level.init(continue_chapter, continue_level)
	get_tree().change_scene("res://game/game.tscn")
	
func _on_levels():
	get_tree().change_scene("res://levels/levels.tscn")
	
func _on_settings():
	get_tree().change_scene("res://settings/settings.tscn")




