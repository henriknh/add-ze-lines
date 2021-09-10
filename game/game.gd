extends Node2D

var current_input_chain: InputChain = null
var valid_points = []

signal level_loaded

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
	var satisfied = 0
	for end in get_tree().get_nodes_in_group("End"):
		if end.status == Operator.OperatorStatus.SUCCESS:
			satisfied += 1
	
	level_complete = get_tree().get_nodes_in_group("End").size() > 0 and get_tree().get_nodes_in_group("End").size() == satisfied
	
	if level_complete:
		Storage.set_level_complete(Level.current_chapter, Level.current_level)
		
	$PostGame.visible = level_complete

func load_level():
	level_complete = false
	current_input_chain = null
	
	for input_chain in get_tree().get_nodes_in_group("InputChain"):
		input_chain.get_parent().remove_child(input_chain)
		input_chain.queue_free()
	
	add_operators()
	
	emit_signal("level_loaded")

func add_operators():
	for operator in get_tree().get_nodes_in_group("Operator"):
		operator.get_parent().remove_child(operator)
	
	for operator in Level.current_level.operators:
		
		var operator_node = null
		match operator.type as int:
			Operator.OperatorType.START:
				operator_node = preload("res://operators/start.tscn").instance()
			Operator.OperatorType.END:
				operator_node = preload("res://operators/end.tscn").instance()
			Operator.OperatorType.HUB:
				operator_node = preload("res://operators/hub.tscn").instance()
			Operator.OperatorType.BLOCK:
				operator_node = preload("res://operators/block.tscn").instance()
		
		operator_node.coord = Vector2(operator.coord_x, operator.coord_y)
		operator_node.value = operator.value
		operator_node.operation = operator.operation
		get_node("/root/Game/Nodes").add_child(operator_node)

func is_mobile():
	return OS.get_name() in ["Android", "iOS"]
	
func _input(event):
	if level_complete:
		return
	
	if is_mobile() and not event is InputEventScreenTouch and not event is InputEventScreenDrag:
		return 
	if not is_mobile() and not event is InputEventMouseButton and not event is InputEventMouseMotion:
		return
	
	var mouse_coord = _get_mouse_coord(event)
	
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed and current_input_chain == null:
			_get_existing_or_create(mouse_coord)
		else:
			end_input()
	
	elif (event is InputEventMouseMotion or event is InputEventScreenDrag) and current_input_chain and point_on_grid(mouse_coord):
		var points = current_input_chain.points
		
		if points.size() > 0 and points[points.size() - 1] == mouse_coord:
			valid_points = []
		
		if points.size() >= 2 and points[points.size() - 2] == mouse_coord:
			points.remove(points.size() - 1)
		elif mouse_coord in points:
			return
		elif points.size() > 0 and Level.get_operator(points[points.size() - 1]) is End:
			return
		elif Level.get_operator(mouse_coord) is Block:
			return
		elif Level.get_operator(mouse_coord) is Start:
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
	return point.x >= 0 and point.y >= 0 and point.x <= Level.tile_size * Level.current_level.grid_size and point.y <= Level.tile_size * Level.current_level.grid_size

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
			get_node("/root/Game/InputChains").add_child(input)
			current_input_chain = input

func _get_mouse_coord(event) -> Vector2:
	if not event.get('position'):
		return Vector2.INF
	
	var mouse_coord = event.position - get_viewport().get_visible_rect().size / 2  + Vector2.ONE * Level.tile_size * Level.current_level.grid_size / 2
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
