extends Camera2D

func _ready():
	position = Vector2(Level.level_data.grid_size[0], Level.level_data.grid_size[1]) * Level.tile_size / 2
