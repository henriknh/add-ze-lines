extends Node2D

onready var tile_size: int = 64
var operator_diameter: int = 42

var current_chapter = null
var current_level = null
var is_editor = false
var previous_scene = null

signal level_changed

func init(_current_chapter, _current_level, _is_editor = false):
	tile_size = min(OS.window_size.x, get_viewport().get_size_override().x) / 6
	tile_size = min(tile_size, 64)
	print(OS.window_size)
	print(get_viewport().get_size_override())
	current_chapter = _current_chapter
	current_level = _current_level
	is_editor = _is_editor
	
	if not get_tree().current_scene is Game:
		previous_scene = get_tree().current_scene.filename
	
	emit_signal("level_changed")
	
	get_tree().change_scene("res://scenes/game/game.tscn")

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
