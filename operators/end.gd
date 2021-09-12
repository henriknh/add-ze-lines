extends Operator

class_name End

func _ready():
	add_to_group("End")

func _physics_process(delta):
	var lines = Level.get_lines(position)
	if lines.size() == 1:
		
		if lines[0].compute():
			status = OperatorStatus.SUCCESS
		else:
			status = OperatorStatus.FAIL
		
		var start = Level.get_operator(lines[0].points[0])
		on_background = start.on_background
		background = start.background
	else:
		status = OperatorStatus.PENDING
		
		on_background = Themes.theme.on_background
		background = Themes.theme.background
	update()

func _draw():
	var _background = Themes.theme.background
	var text_color = Themes.theme.on_background
	if status == OperatorStatus.SUCCESS:
		_background = background 
		text_color = on_background
	elif status == OperatorStatus.FAIL:
		_background = Themes.theme.error
		text_color = Themes.theme.on_error
		
	var border = Themes.on_background_white if status == OperatorStatus.PENDING else background
	
	get_node("Label").add_color_override("font_color", text_color)
	
	var nb_points = 32
	var points_arc = PoolVector2Array()
	for i in range(nb_points + 1):
		var angle_point = deg2rad((360 / nb_points) * i)
		points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * Level.operator_diameter / 2)
	
	draw_polygon(points_arc, [_background], [], null, null, true)
	
	draw_arc(Vector2.ZERO, Level.operator_diameter / 2 - Level.operator_diameter / 12, 0, 2 * PI, 32, border, Level.operator_diameter / 6, true)
