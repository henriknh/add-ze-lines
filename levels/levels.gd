extends MarginContainer

func _on_load_level():
	get_tree().change_scene("res://game/game.tscn")
	
func _on_back():
	get_tree().change_scene("res://menu/menu.tscn")
