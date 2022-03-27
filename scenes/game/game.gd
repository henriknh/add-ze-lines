extends Node2D

class_name Game

var current_line: Line = null
var valid_points = []

func _ready():
	#position = get_viewport().size / 2
	#Level.initalize()
	get_tree().get_root().connect("size_changed", self, "_on_resize")
	_on_resize()
	
func _on_resize():
	var offset = get_viewport().get_visible_rect().size / 2
	$Grid.position = offset
	$Outline.position = offset
	$Lines.position = offset
	$Nodes.position = offset

func _exit_tree():
	Level.destroy()

func _input(event):
	if Level.level_complete:
		return
	
	if Data.is_mobile() and not event is InputEventScreenTouch and not event is InputEventScreenDrag:
		return 
	if not Data.is_mobile() and not event is InputEventMouseButton and not event is InputEventMouseMotion:
		return
	
	var mouse_coord = _get_mouse_coord(event)
	
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed and current_line == null:
			_get_existing_or_create(mouse_coord)
		else:
			goal_input()
	
	elif (event is InputEventMouseMotion or event is InputEventScreenDrag) and is_instance_valid(current_line) and point_on_grid(mouse_coord):
		var points = current_line.points
		var mouse_operator = Level.get_operator(mouse_coord)
	
		if mouse_operator and current_line.start_operator.color_idx > 0:
			var same_color = current_line.start_operator.color_idx == mouse_operator.color_idx
			var operator_is_neutral = mouse_operator.color_idx == 0
			if not (same_color || operator_is_neutral):
				return
		
		if points.size() > 0 and points[points.size() - 1] == mouse_coord:
			valid_points = []
		
		if points.size() >= 2 and points[points.size() - 2] == mouse_coord:
			points.remove(points.size() - 1)
		elif mouse_coord in points:
			return
		elif points.size() > 0 and Level.get_operator(points[points.size() - 1]) is Goal:
			return
		elif mouse_operator is Start or mouse_operator is Block or mouse_operator is Void:
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
		
		current_line.points = points
		
		Level.update()
	
func point_on_grid(point: Vector2) -> bool:
	var half_width = Level.tile_size * Level.level_data.grid_size[0] / 2
	var half_height = Level.tile_size * Level.level_data.grid_size[1] / 2
	return point.x >= -half_width and point.y >= -half_height and point.x <= half_width and point.y <= half_height

func goal_input():
	if is_instance_valid(current_line):
		current_line.on_goal_input()
	Level.update()
	
	current_line = null
	valid_points = []

func _get_existing_or_create(mouse_coord: Vector2):
	if not point_on_grid(mouse_coord):
		return
	
	var exists = any_line_has_point(mouse_coord)
	if exists:
		# If is goal point
		if exists.points.size() > 0 and exists.points[exists.points.size() - 1] == mouse_coord:
			current_line = exists
		else:
			return
	else:
		var is_on_start = null
		for start in get_tree().get_nodes_in_group("Start"):
			if start.position== mouse_coord:
				is_on_start = start
		
		if is_on_start:
			var line = preload("res://operators/line/line.tscn").instance()
			line.colors = is_on_start.colors
			line.points = [is_on_start.position]
			get_node("/root/Game/Lines").add_child(line)
			current_line = line

func _get_mouse_coord(event) -> Vector2:
	if not event.get('position'):
		return Vector2.INF
	
	var mouse_coord = event.position - get_viewport().get_visible_rect().size / 2
	mouse_coord += Vector2.ONE * Level.tile_size / 2
	mouse_coord /= Level.tile_size
	mouse_coord = mouse_coord.floor()
	mouse_coord *= Level.tile_size
	return mouse_coord

func any_line_has_point(point: Vector2, exclude = null) -> Line:
	if not exclude:
		exclude = current_line
	
	for line in get_tree().get_nodes_in_group("Line"):
		if line != exclude and point in line.points:
			return line
	return null

func cross_existing_and_valid(from: Vector2, to: Vector2) -> Array:
	var to_operator: Operator = Level.get_operator(to)
	var crossing = any_line_has_point(to)
	var valid_points = [from]
	
	if to_operator and to_operator is Twist:
		var up = to + Vector2(0,1) * Level.tile_size
		if up != from and not any_line_has_point(up):
			valid_points.append(up)
		
		var left = to + Vector2(-1,0) * Level.tile_size
		if left != from and not any_line_has_point(left):
			valid_points.append(left)
		
		var down = to + Vector2(0,-1) * Level.tile_size
		if down != from and not any_line_has_point(down):
			valid_points.append(down)
		
		var right = to + Vector2(1,0) * Level.tile_size
		if right != from and not any_line_has_point(right):
			valid_points.append(right)
			
		
		if valid_points.size() > 1:
			valid_points.append(to)
		
		return valid_points
	elif crossing:
		var diff = to - from
		to = from + diff
		
		while crossing and is_valid_cross(from, to, crossing):
			valid_points.append(to)
			
			from = to
			to = from + diff
			crossing = any_line_has_point(to)
		if valid_points.size() > 1:
			valid_points.append(to)
		
		return valid_points
	else:
		return []

func is_valid_cross(from: Vector2, to: Vector2, line: Line) -> bool:
	var diff = to - from 
	var destination = to + diff
	var idx = -1
	for i in range(line.points.size()):
		if line.points[i] == to:
			idx = i
			break
	
	if idx == 0 or idx == line.points.size() - 1:
		# First point or last point
		return false
	elif line.points[idx - 1] != destination and line.points[idx + 1] != destination:
		return true
	else:
		return false
