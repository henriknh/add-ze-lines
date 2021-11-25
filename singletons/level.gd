extends Node2D

onready var tile_size: int = 64
var operator_diameter: int = 42

var chapter: int = 0
var level: int = 0
var chapter_data = null
var level_data = null
var is_editor = false
var previous_scene = null

signal level_changed

func init(_chapter: int, _level: int, _is_editor = false):
	tile_size = min(OS.window_size.x, get_viewport().get_size_override().x) / 6
	tile_size = min(tile_size, 64)
	chapter = _chapter
	level = _level
	chapter_data = Data.data[chapter]
	level_data = chapter_data.levels[level]
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
