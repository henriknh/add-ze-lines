extends Node2D

func _ready():
	generate_grid()

func generate_grid():
	var points = []
	
	for y in range(Level.current_level.grid_size[1]):
		for x in range(Level.current_level.grid_size[0]):
			
			var has_void = false
			for operator in Level.current_level.operators:
				if operator.coord[0] == x and operator.coord[1] == y and operator.type == Operator.OperatorType.VOID:
					has_void = true
					break
				
			if not has_void:
				var origin = Vector2(x,y)*Level.tile_size
				
				points.append(origin) #topleft
				points.append(origin + Vector2(0, 1) * Level.tile_size) #bottomleft
				points.append(origin + Vector2(1, 1) * Level.tile_size) #bottomright
				points.append(origin + Vector2(1, 0) * Level.tile_size) #topright
				points.append(origin) #topleft
				
		if points.size() > 4:
			points.append(points[points.size() - 4])

	var line = Line2D.new()
	line.default_color = Themes.theme.grid
	line.width = 1
	line.joint_mode =Line2D.LINE_JOINT_SHARP
	line.begin_cap_mode = Line2D.LINE_CAP_BOX
	line.end_cap_mode = Line2D.LINE_CAP_BOX
	line.antialiased = true
	line.points = points
	add_child(line)
	
	var edge = line.duplicate()
	edge.width = 2
	edge.points = [
		Vector2(0.5, 0) * Level.tile_size * Level.current_level.grid_size[0],
		Vector2(0, 0),
		Vector2(0, 1) * Level.tile_size * Level.current_level.grid_size[1], #bottomleft
		Vector2(1, 1) * Level.tile_size * max(Level.current_level.grid_size[0], Level.current_level.grid_size[1]), #bottomright
		Vector2(1, 0) * Level.tile_size * Level.current_level.grid_size[0], #topright
		Vector2(0.5, 0) * Level.tile_size * Level.current_level.grid_size[0]
	]
	add_child(edge)
	
	
