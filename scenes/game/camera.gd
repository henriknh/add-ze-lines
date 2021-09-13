extends Camera2D

func _ready():
	position = Vector2(Level.current_level.grid_size[0], Level.current_level.grid_size[1]) * Level.tile_size / 2
