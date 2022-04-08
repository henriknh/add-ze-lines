extends Node2D

func _ready():
	Level.connect("level_loaded", self, "update")

func _draw():
	var points = GridHelper.calc_grid()
	points = GridHelper.get_edge_points(points)
	var color = Themes.theme.background
	color.a = 0.8
	draw_polygon(points, [color])

