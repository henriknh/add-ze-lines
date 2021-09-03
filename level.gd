extends Node2D

export(int) var grid_size = 5
var colors = [
	Color.green,
	Color.blue,
	Color.red,
	Color.purple
]

var grid = {}
func _ready():
	for x in range(grid_size):
		for y in range(grid_size):
			grid[Vector2(x, y)] = null
	
	call_deferred("add_tiles")
	
func add_tiles():
	for tile in get_tree().get_nodes_in_group("Tile"):
		grid[tile.coord] = tile
		print(tile)
	print(grid)
