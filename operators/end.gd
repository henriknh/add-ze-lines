extends Operator

class_name End

func _ready():
	add_to_group("End")

func _physics_process(delta):
	var input_chain = Level.get_input_chain(position)
	if input_chain:
		
		var start = Level.get_grid_operator(input_chain.points[0])
		if input_chain.compute():
			status = OperatorStatus.SUCCESS
		else:
			status = OperatorStatus.FAIL
		
		color_foreground = start.color_foreground
		color_background = start.color_background
	else:
		status = OperatorStatus.PENDING
		
		color_foreground = Level.foreground_white
		color_background = Level.background
	update()

func success():
	pass

func fail():
	pass

func _draw():
	
	get_node("Label").add_color_override("font_color", color_foreground)
	
	var background = color_background if status == OperatorStatus.SUCCESS else Level.background
	var border = color_foreground if status == OperatorStatus.PENDING else color_background
	

	var nb_points = 32
	var points_arc = PoolVector2Array()
	for i in range(nb_points + 1):
		var angle_point = deg2rad((360 / nb_points) * i)
		points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * Level.operator_diameter / 2)
	
	draw_polygon(points_arc, [background], [], null, null, true)
	
	draw_arc(Vector2.ZERO, Level.operator_diameter / 2 - Level.operator_diameter / 12, 0, 2 * PI, 32, border, Level.operator_diameter / 6, true)
