extends Node2D

class_name Game

var current_line: Line = null
var valid_points = []

signal level_loaded

var level_ready = false
var level_complete = false

func _ready():
	var fallback_chapter = null
	var fallback_level = null
	
	if not Level.current_chapter and Data.data.size():
		fallback_chapter = Data.data[0]
	if not Level.current_chapter and Level.current_chapter and Level.current_chapter.levels.size():
		fallback_level = Level.current_chapter.levels[0]
	
	if fallback_chapter and fallback_level:
		Level.init(fallback_chapter, fallback_level)
	
	Data.connect("data_saved", self, "load_level")
	Level.connect("level_changed", self, "load_level")
	load_level()
	
func _physics_process(delta):
	
	if not level_ready:
		return
	
	var to_satisfy = 0
	var satisfied = 0
	for end in get_tree().get_nodes_in_group("End"):
		to_satisfy += 1
		if end.status == Operator.OperatorStatus.SUCCESS:
			satisfied += 1
	for equals_hub in get_tree().get_nodes_in_group("Hub"):
		if equals_hub.operation ==  Arithmetic.Operation.equals:
			to_satisfy += 1
			
			for line in Level.get_lines(equals_hub.position):
				if line.compute(equals_hub.position) == equals_hub.value:
					satisfied += 1
					break
	
	level_complete = to_satisfy > 0 and to_satisfy == satisfied
	
	if level_complete:
		Storage.set_level_complete(Level.current_chapter, Level.current_level)
	
func load_level():
	level_ready = false
	level_complete = false
	current_line = null
	
	for line in get_tree().get_nodes_in_group("Line"):
		line.get_parent().remove_child(line)
		line.queue_free()
	
	add_operators()
	
	emit_signal("level_loaded")
	level_ready = true

func add_operators():
	for operator in get_tree().get_nodes_in_group("Operator"):
		operator.get_parent().remove_child(operator)
	
	for operator in Level.current_level.operators:
		
		var operator_node = null
		match operator.type as int:
			Operator.OperatorType.START:
				operator_node = preload("res://operators/start/start.tscn").instance()
			Operator.OperatorType.END:
				operator_node = preload("res://operators/end/end.tscn").instance()
			Operator.OperatorType.HUB:
				operator_node = preload("res://operators/hub/hub.tscn").instance()
			Operator.OperatorType.BLOCK:
				operator_node = preload("res://operators/block/block.tscn").instance()
			Operator.OperatorType.TWIST:
				operator_node = preload("res://operators/twist/twist.tscn").instance()
			Operator.OperatorType.VOID:
				operator_node = preload("res://operators/void/void.tscn").instance()
		
		operator_node.coord = Vector2(operator.coord[0], operator.coord[1])
		operator_node.value = operator.value
		operator_node.operation = operator.operation
		get_node("/root/Game/Nodes").add_child(operator_node)


	
func _input(event):
	if level_complete:
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
			end_input()
	
	elif (event is InputEventMouseMotion or event is InputEventScreenDrag) and current_line and point_on_grid(mouse_coord):
		var points = current_line.points
		var mouse_operator = Level.get_operator(mouse_coord)
		
		if points.size() > 0 and points[points.size() - 1] == mouse_coord:
			valid_points = []
		
		if points.size() >= 2 and points[points.size() - 2] == mouse_coord:
			points.remove(points.size() - 1)
		elif mouse_coord in points:
			return
		elif points.size() > 0 and Level.get_operator(points[points.size() - 1]) is End:
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
		
		for line in get_tree().get_nodes_in_group("Line"):
			line.compute()
			
func point_on_grid(point: Vector2) -> bool:
	return point.x >= 0 and point.y >= 0 and point.x <= Level.tile_size * Level.current_level.grid_size[0] and point.y <= Level.tile_size * Level.current_level.grid_size[1]

func end_input():
	if current_line:
		current_line.on_end_input()
	
	current_line = null
	valid_points = []

func _get_existing_or_create(mouse_coord: Vector2):
	if not point_on_grid(mouse_coord):
		return
	
	var exists = any_line_has_point(mouse_coord)
	if exists:
		# If is end point
		if exists.points.size() > 0 and exists.points[exists.points.size() - 1] == mouse_coord:
			current_line = exists
		else:
			return
	else:
		var is_on_start = null
		for start in get_tree().get_nodes_in_group("Start"):
			if start.position == mouse_coord:
				is_on_start = start
		
		if is_on_start:
			var line = preload("res://operators/line/line.tscn").instance()
			line.start = is_on_start
			line.points = [is_on_start.position]
			get_node("/root/Game/Lines").add_child(line)
			current_line = line

func _get_mouse_coord(event) -> Vector2:
	if not event.get('position'):
		return Vector2.INF
	
	var offset = Vector2(Level.current_level.grid_size[0], Level.current_level.grid_size[1]) * Level.tile_size / 2
	var mouse_coord = event.position - get_viewport().get_visible_rect().size / 2  + offset
	mouse_coord /= Level.tile_size
	mouse_coord = mouse_coord.floor()
	mouse_coord *= Level.tile_size
	mouse_coord += Vector2.ONE * Level.tile_size / 2
	return mouse_coord

func any_line_has_point(point: Vector2, exclude = null) -> Line:
	if not exclude:
		exclude = current_line
	
	for line in get_tree().get_nodes_in_group("Line"):
		if line != exclude and point in line.points:
			return line
	return null

func cross_existing_and_valid(from: Vector2, to: Vector2) -> Array:
	var to_operator = Level.get_operator(to)
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
