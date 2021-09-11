extends Node2D

var tile_size: int = 64
var operator_diameter: int = 42

var current_chapter = null
var current_level = null

var background = Color('#110f3e')
var background_border = Color('#371a77')

var foreground_black = Color(0,0,0,0.87)
var foreground_white = Color(1,1,1,1)


# https://lospec.com/palette-list/bloom-16
var colors = [
	{
		'background': Color('#afe48d'),
		'foreground': foreground_black
	}, {
		'background': Color('#ff9072'),
		'foreground': foreground_white
	}, {
		'background': Color('#ffc567'),
		'foreground': foreground_white
	}, {
		'background': Color('#2b75b7'),
		'foreground': foreground_white
	}, {
		'background': Color('#371a77'),
		'foreground': foreground_white
	}
]

signal level_changed

func _ready():
	VisualServer.set_default_clear_color(background)

func init(_current_chapter, _current_level):
	current_chapter = _current_chapter
	current_level = _current_level
	emit_signal("level_changed")

func get_coord_operators(caller: Line, point: Vector2) -> Array:
	var operators = []
	
	var cell_operator = get_operator(point)
	if cell_operator:
		operators.append(cell_operator)
	
	for line in get_lines(point, caller):
		operators.append(line.start_operator)
	
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
