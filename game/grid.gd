extends Node2D

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
