extends CanvasLayer

func _ready():
	$TopLeft/MarginContainer2/VBoxContainer/LevelTitle.text = Level.current_level.title
	$TopLeft/MarginContainer2/VBoxContainer/ChapterTitle.text = Level.current_chapter.title

func _on_back():
	get_tree().change_scene("res://menu/menu.tscn")
