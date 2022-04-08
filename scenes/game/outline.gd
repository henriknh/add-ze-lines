extends Line2D

onready var outline = $Line
onready var background = $Background

func _ready():
	Level.connect("level_loaded", self, "generate_outline")

	width = 2
	joint_mode = Line2D.LINE_JOINT_SHARP
	begin_cap_mode = Line2D.LINE_CAP_BOX
	end_cap_mode = Line2D.LINE_CAP_BOX
	antialiased = true
	
func generate_outline():
	points = GridHelper.get_edge_points(GridHelper.calc_grid())
	default_color = Themes.theme.grid
#	outline.width = 2
#	outline.joint_mode = Line2D.LINE_JOINT_SHARP
#	outline.begin_cap_mode = Line2D.LINE_CAP_BOX
#	outline.end_cap_mode = Line2D.LINE_CAP_BOX
#	outline.antialiased = true
	
