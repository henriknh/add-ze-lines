extends Node2D

onready var line = Line2D.new()

func _ready():
	add_child(line)
	line.width = 1
	line.joint_mode = Line2D.LINE_JOINT_SHARP
	line.begin_cap_mode = Line2D.LINE_CAP_BOX
	line.end_cap_mode = Line2D.LINE_CAP_BOX
	line.antialiased = true
	
	Level.connect("level_loaded", self, "generate_grid")

func generate_grid():
	line.default_color = Themes.theme.grid
	line.points = GridHelper.calc_grid()
