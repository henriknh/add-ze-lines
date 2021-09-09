extends Node

var current_input_chain: InputChain = null
var valid_points = []

func _input(event):
	if not event is InputEventMouseButton or not event is InputEventMouseMotion:
		return
	
	var mouse_coord = _get_mouse_coord(event)
	
	if event is InputEventMouseButton:
		if event.pressed and current_input_chain == null:
			_get_existing_or_create(mouse_coord)
		else:
			end_input()
	
	elif event is InputEventMouseMotion and current_input_chain and point_on_grid(mouse_coord):
		var points = current_input_chain.points
		
		if points.size() > 0 and points[points.size() - 1] == mouse_coord:
			valid_points = []
		
		if points.size() >= 2 and points[points.size() - 2] == mouse_coord:
			points.remove(points.size() - 1)
		elif mouse_coord in points:
			return
		elif points[points.size() - 1] != mouse_coord and mouse_coord.distance_to(points[points.size() - 1]) == Level.tile_size:
			if valid_points.size() == 0:
				# Check if crossing existing chain, then find next valid points
				valid_points = cross_existing_and_valid(points[points.size() - 1], mouse_coord)
			
			if valid_points.size() > 0:
				if mouse_coord in valid_points:
					points.append(mouse_coord)
			else:
				points.append(mouse_coord)
				
			if valid_points.size() > 0 and valid_points[valid_points.size() - 1] == mouse_coord:
				valid_points = []
		
		current_input_chain.points = points
		
		for input_chain in get_tree().get_nodes_in_group("InputChain"):
			input_chain.compute()
			
func point_on_grid(point: Vector2) -> bool:
	return point.x >= 0 and point.y >= 0 and point.x <= Level.tile_size * Level.grid_size and point.y <= Level.tile_size * Level.grid_size

func end_input():
	if current_input_chain:
		current_input_chain.on_end_input()
	
	current_input_chain = null
	valid_points = []

func _get_existing_or_create(mouse_coord: Vector2):
	if not point_on_grid(mouse_coord):
		return
	
	var exists = any_input_chain_has_point(mouse_coord)
	if exists:
		# If is end point
		if exists.points.size() > 0 and exists.points[exists.points.size() - 1] == mouse_coord:
			current_input_chain = exists
		else:
			return
	else:
		var is_on_start = null
		for start in get_tree().get_nodes_in_group("Start"):
			if start.position == mouse_coord:
				is_on_start = start
		if is_on_start:
			
			var input = InputChain.new()
			input.start_operator = is_on_start
			get_node("/root/Game/Inputs").add_child(input)
			current_input_chain = input

func _get_mouse_coord(event: InputEventMouse) -> Vector2:
	var mouse_coord = event.global_position
	mouse_coord /= Level.tile_size
	mouse_coord = mouse_coord.floor()
	mouse_coord *= Level.tile_size
	mouse_coord += Vector2.ONE * Level.tile_size / 2
	return mouse_coord

func any_input_chain_has_point(point: Vector2, exclude = null) -> InputChain:
	if not exclude:
		exclude = current_input_chain
	
	for input_chain in get_tree().get_nodes_in_group("InputChain"):
		if input_chain != exclude and point in input_chain.points:
			return input_chain
	return null

func cross_existing_and_valid(from: Vector2, to: Vector2) -> Array:
	var crossing = any_input_chain_has_point(to)
	if crossing:
		var valid_points = [from]
		var diff = to - from 
		to = from + diff
		
		while crossing and is_valid_cross(from, to, crossing):
			valid_points.append(to)
			
			from = to
			to = from + diff
			crossing = any_input_chain_has_point(to)
		if valid_points.size() > 1:
			valid_points.append(to)
		
		return valid_points
	else:
		return []

func is_valid_cross(from: Vector2, to: Vector2, input_chain: InputChain) -> bool:
	var diff = to - from 
	var destination = to + diff
	var idx = -1
	for i in range(input_chain.points.size()):
		if input_chain.points[i] == to:
			idx = i
			break
	
	if idx == 0 or idx == input_chain.points.size() - 1:
		# First point or last point
		return false
	elif input_chain.points[idx - 1] != destination and input_chain.points[idx + 1] != destination:
		return true
	else:
		return false
