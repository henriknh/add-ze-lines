extends Camera2D

func _ready():
	Level.connect("level_loaded", self, "set_initial_position")
	
func set_initial_position():
	position = Vector2(Level.level_data.grid_size[0], Level.level_data.grid_size[1]) * Level.tile_size / 2
