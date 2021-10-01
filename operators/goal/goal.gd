extends Operator

class_name Goal

func _ready():
	add_to_group("Goal")
	
	var tutorial_label = get_node_or_null("TutorialLabel")
	if tutorial_label:
		tutorial_label.rect_position = Vector2(1, -0.5) * (-Level.tile_size / 2)

func _draw():
	var _background = Themes.on_background_white
	var text_color = Themes.on_background_black
	if status == OperatorStatus.SUCCESS:
		_background = colors.background 
		text_color = colors.on_background
	elif status == OperatorStatus.FAIL:
		_background = Themes.theme.error
		text_color = Themes.theme.on_error
		
	var border = colors.background if status == OperatorStatus.SUCCESS else Color.black
	
	get_node("Label").add_color_override("font_color", text_color)
	
	var nb_points = 32
	var points_arc = PoolVector2Array()
	for i in range(nb_points + 1):
		var angle_point = deg2rad((360 / nb_points) * i)
		points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * Level.operator_diameter / 2)
	
	draw_polygon(points_arc, [_background], [], null, null, true)
	
	#draw_arc(Vector2.ZERO, Level.operator_diameter / 2 - Level.operator_diameter / 12, 0, 2 * PI, 32, border, Level.operator_diameter / 6, true)
	
	draw_arc(Vector2.ZERO, Level.operator_diameter / 2, 0, 2 * PI, 32, border, 2, true)


func compute(_value: int, start: Start = null) -> int:
	
	if _value == value:
		status = OperatorStatus.SUCCESS
	else:
		status = OperatorStatus.FAIL
	return value
