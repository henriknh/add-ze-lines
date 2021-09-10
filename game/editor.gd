extends Node2D

func _ready():
	if Storage.editor:
		get_parent().connect("level_loaded", self, "editable_cells")
	
func editable_cells():
	for child in get_children():
		remove_child(child)
	
	for x in range(Level.current_level.grid_size):
		for y in range(Level.current_level.grid_size):
			var point = Vector2(x, y) * Level.tile_size + Vector2.ONE * Level.tile_size / 2
			var cell_operator = Level.get_operator(point)

			var add_operator = preload("res://game/edit_operator/edit_operator.tscn").instance()
			add_operator.position = point
			add_child(add_operator)
