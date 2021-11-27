extends Node2D

func _ready():
	
	if Storage.get_editor() == false:
		return
	
	if Storage.editor:
		Level.connect("level_loaded", self, "editable_cells")
	
func editable_cells():
	for child in get_children():
		remove_child(child)
	
	for x in range(Level.level_data.grid_size[0]):
		for y in range(Level.level_data.grid_size[1]):
			var point = Vector2(x, y) * Level.tile_size + Vector2.ONE * Level.tile_size / 2
			var cell_operator = Level.get_operator(point)

			var add_operator = preload("res://scenes/game/edit_operator/edit_operator.tscn").instance()
			add_operator.position = point
			add_child(add_operator)
