extends Line2D

class_name InputChain

var start_operator = null
onready var head = preload("res://operators/input_chain/head/head.tscn").instance()

func _ready():
	add_to_group("InputChain")
	
	joint_mode = Line2D.LINE_JOINT_ROUND
	begin_cap_mode = Line2D.LINE_CAP_ROUND
	end_cap_mode = Line2D.LINE_CAP_ROUND
	
	points = [start_operator.position]
	default_color = start_operator.color_background
	
	add_child(head)

func on_end_input():
	_remove_on_other_input_chain()
	
	if points.size() <= 1:
		points = []
		queue_free()

func _remove_on_other_input_chain():
	var _points = points
	while true:
		if points.size() == 0:
			break
		
		var end_on_other_input_chain = UserInput.any_input_chain_has_point(_points[_points.size() - 1], self)
		
		if end_on_other_input_chain:
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
	return result is bool and result == true

