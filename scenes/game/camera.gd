extends Camera2D

func _ready():
	position = Vector2.ONE * Level.tile_size * Level.current_level.grid_size / 2
