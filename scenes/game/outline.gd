extends Node2D

func _ready():
	get_parent().connect("level_loaded", self, "generate_outline")
	generate_outline()

func generate_outline():
	for child in get_children():
		remove_child(child)
	
	var points = []
	
	for y in range(Level.level_data.grid_size[1]):
		for x in range(Level.level_data.grid_size[0]):
			
			var has_void = false
			for operator in Level.level_data.operators:
				if operator.coord[0] == x and operator.coord[1] == y and operator.type == Operator.OperatorType.VOID:
					has_void = true
					break
				
			if not has_void:
				var origin = Vector2(x,y)*Level.tile_size
				
				points.append(origin) #topleft
				points.append(origin + Vector2(0, 1) * Level.tile_size) #bottomleft
				points.append(origin + Vector2(1, 1) * Level.tile_size) #bottomright
				points.append(origin + Vector2(1, 0) * Level.tile_size) #topright
				
		if points.size() > 4:
			points.append(points[points.size() - 4])

	var outline = Line2D.new()
	outline.default_color = Themes.theme.grid
	outline.width = 2
	outline.joint_mode = Line2D.LINE_JOINT_SHARP
	outline.begin_cap_mode = Line2D.LINE_CAP_BOX
	outline.end_cap_mode = Line2D.LINE_CAP_BOX
	outline.antialiased = true
	outline.points = get_edge_points(points)
	add_child(outline)

func get_edge_points(points):
	var dirs = {
		Vector2(0,1): Vector2(-1,0),
		Vector2(-1,0): Vector2(0,-1),
		Vector2(0,-1): Vector2(1,0),
		Vector2(1,0): Vector2(0,1)
	}
	var current = Vector2(INF, 0)
	var dir = Vector2(0, -1)
	for point in points:
		if point.x < current.x:
			current = point
	var edge_points = [current]
	
	while true:
		var dirs_to_check = [
			dirs[dir] * -1, # right
			dir, 			# straight
			dirs[dir], 		# left
		]
		
		for _dir in dirs_to_check:
			var _edge_point = current + _dir * Level.tile_size
			
			if _edge_point in points:
				edge_points.append(_edge_point)
				current = _edge_point
				dir = _dir
				
				if current == edge_points[0]:
					return edge_points
				break
