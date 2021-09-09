extends MarginContainer

func _on_continue():
	get_tree().change_scene("res://game/game.tscn")
	
func _on_levels():
	get_tree().change_scene("res://levels/levels.tscn")
	
func _on_settings():
	get_tree().change_scene("res://settings/settings.tscn")




