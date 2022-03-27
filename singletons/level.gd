extends Node2D

onready var tile_size: int = 64
var operator_diameter: int = 42

var chapter: int = 0
var chapter_data = null
var level: int = 0
var level_data = null

signal level_changed
signal level_loaded

var level_ready: bool = false
var level_complete: bool = false

func create(_chapter: int, _level: int):
	tile_size = min(OS.window_size.x, get_viewport().get_size_override().x) / 6
	tile_size = min(tile_size, 64)
	chapter = _chapter
	level = _level
	
	Data.connect("data_saved", self, "initalize")
	emit_signal("level_changed")

func destroy():
	if Data.is_connected("data_saved", self,  "initalize"):
		Data.disconnect("data_saved", self, "initalize")
	reset()
	
func reset():
	level_ready = false
	level_complete = false
	
	for line in get_tree().get_nodes_in_group("Line"):
		line.get_parent().remove_child(line)
		line.queue_free()
	
	for operator in get_tree().get_nodes_in_group("Operator"):
		operator.get_parent().remove_child(operator)
	
func initalize():
	reset()
	
	chapter_data = Data.data[chapter]
	level_data = chapter_data.levels[level]
	
	for operator in Level.level_data.operators:
		
		var operator_node = null
		match operator.type as int:
			Operator.OperatorType.START:
				operator_node = preload("res://operators/start/start.tscn").instance()
			Operator.OperatorType.GOAL:
				operator_node = preload("res://operators/goal/goal.tscn").instance()
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
		operator_node.color_idx = operator.color_idx
		get_node("/root/Game/Nodes").add_child(operator_node)
	
	emit_signal("level_loaded")
	level_ready = true
	
func update():
	if level_complete:
		return
	
	for goal in get_tree().get_nodes_in_group("Goal"):
		goal.status = Operator.OperatorStatus.PENDING
		
	for line in get_tree().get_nodes_in_group("Line"):
		line.compute()
	
	
	level_complete = check_for_level_completed()
	if level_complete:
		var already_completed = Storage.get_level_completed(Level.level_data.id)
		if not already_completed:
			Storage.set_level_complete(Level.level_data.id)
			Storage.set_gems(Storage.get_gems() + 10)

func check_for_level_completed() -> bool:
	var to_satisfy = 0
	var satisfied = 0
	
	for goal in get_tree().get_nodes_in_group("Goal"):
		to_satisfy += 1
		if goal.status == Operator.OperatorStatus.SUCCESS:
			satisfied += 1
	
	for equals_hub in get_tree().get_nodes_in_group("Hub"):
		if equals_hub.operation ==  Arithmetic.Operation.equals:
			to_satisfy += 1
			
			for line in Level.get_lines(equals_hub.position):
				if line.compute(equals_hub.position) == equals_hub.value:
					satisfied += 1
					break
	
	return to_satisfy > 0 and to_satisfy == satisfied

func get_coord_operators(caller: Line, point: Vector2) -> Array:
	var operators = []
	
	var cell_operator = get_operator(point)
	if cell_operator:
		operators.append(cell_operator)
	
	for line in get_lines(point, caller):
		operators.append(get_operator(line.points[0]))
	
	return operators

func get_operator(point: Vector2) -> Operator:
	for operator in get_tree().get_nodes_in_group("Operator"):
		if point == operator.position:
			return operator
	return null

func get_lines(point: Vector2, exclude = null) -> Array:
	var lines = []
	for line in get_tree().get_nodes_in_group("Line"):
		if point in line.points and line != exclude:
			lines.append(line)
	return lines

func get_absolute_level(chapter: int, level: int) -> int:
	var prev_levels = 0
	for prev_chapter in range(chapter):
		prev_levels += Data.data[prev_chapter].levels.size()
	return  prev_levels + level + 1
