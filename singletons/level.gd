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

var grid = {}

func init(level: int):
	for x in range(current_level.grid_size):
		for y in range(current_level.grid_size):
			grid[Vector2(x, y) * tile_size + Vector2.ONE * tile_size / 2] = null
	
	get_node("/root/Game/Grid").generate_grid()
	
	var level_data = JSON.parse("level_1.json")
	add_tiles()
	
	VisualServer.set_default_clear_color(background)

func add_tiles():
	for tile in get_tree().get_nodes_in_group("Operator"):
		grid[tile.coord * tile_size + Vector2.ONE * tile_size / 2] = tile

func get_coord_operators(caller: InputChain, point: Vector2) -> Array:
	var operators = []
	
	var grid_operator = get_grid_operator(point)
	if grid_operator:
		operators.append(grid_operator)
	
	for input_chain in get_tree().get_nodes_in_group("InputChain"):
		if input_chain != caller and point in input_chain.points:
			operators.append(grid[input_chain.points[0]])
	
	return operators

func get_grid_operator(point: Vector2) -> Operator:
	if grid.has(point) and grid[point]:
		return grid[point]
	return null

func get_input_chain(point: Vector2) -> InputChain:
	for input_chain in get_tree().get_nodes_in_group("InputChain"):
		if point in input_chain.points:
			return input_chain
	return null
