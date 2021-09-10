extends Node2D

func _ready():
	generate_grid()
	if Settings.editor:
		get_parent().connect("level_loaded", self, "editable_cells")
		print('grid')

func generate_grid():
	var points = []
	
	for y in range(Level.current_level.grid_size + 1):
		var left = y * Level.tile_size * Vector2(0, 1)
		var right = y * Level.tile_size * Vector2(0, 1) + Vector2(1, 0) * Level.current_level.grid_size * Level.tile_size
		points.append(left)
		points.append(right)
		points.append(left)

	for x in range(Level.current_level.grid_size + 1):
		var top = x * Level.tile_size * Vector2(1, 0) 
		var bottom = x * Level.tile_size * Vector2(1, 0) + Vector2(0, 1) * Level.current_level.grid_size * Level.tile_size
		points.append(bottom)
		points.append(top)
		points.append(bottom)

	var line = Line2D.new()
	line.default_color = Color.white
	line.width = 1
	line.antialiased = true
	line.points = points
	add_child(line)
	
func editable_cells():
	for child in $AddOperators.get_children():
		$AddOperators.remove_child(child)
	
	for x in range(Level.current_level.grid_size):
		for y in range(Level.current_level.grid_size):
			var point = Vector2(x, y) * Level.tile_size + Vector2.ONE * Level.tile_size / 2
			var cell_operator = Level.get_operator(point)
			if not cell_operator:
				
				var add_operator = preload("res://game/add_operator/add_operator.tscn").instance()
				add_operator.position = point
				$AddOperators.add_child(add_operator)
	pass
