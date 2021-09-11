extends Line2D

class_name Line

var start_operator = null
onready var head = preload("res://operators/line/head/head.tscn").instance()

func _ready():
	add_to_group("Line")
	
	joint_mode = Line2D.LINE_JOINT_ROUND
	begin_cap_mode = Line2D.LINE_CAP_ROUND
	end_cap_mode = Line2D.LINE_CAP_ROUND
	
	points = [start_operator.position]
	default_color = start_operator.color_background
	
	add_child(head)

func on_end_input():
	_remove_on_other_line()
	
	if points.size() <= 1:
		points = []
		queue_free()

func _remove_on_other_line():
	var _points = points
	while true:
		if points.size() == 0:
			break
		
		var end_on_other_line = get_node("/root/Game").any_line_has_point(_points[_points.size() - 1], self)
		
		if end_on_other_line:
			_points.remove(_points.size() - 1)
		else:
			points = _points
			break

func compute() -> bool:
	var operators = []
	for point in points:
		operators.append_array(Level.get_coord_operators(self, point))
	
	var result = Arithmetic.compute(operators)
	head.redraw(result)
	print(points.size())
	return result is bool and result == true

