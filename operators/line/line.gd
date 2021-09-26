extends Node2D

class_name Line

var points = [] setget set_points
var start: Start

func _ready():
	add_to_group("Line")
	
	$Line2D.default_color = start.background
	$Line2D.points = points

func set_points(_points):
	if _points.size() and _points.size() > $Line2D.points.size():
		var line_effect = preload("res://operators/line/line_effect/line_effect.tscn").instance()
		line_effect.position = _points[_points.size() - 1]
		line_effect.self_modulate = start.background
		add_child(line_effect)
	points = _points
	$Line2D.points = points
	
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

func compute(last_point = null) -> bool:
	var operators = []
	for point in points:
		if last_point and point == last_point:
			operators.append_array(Level.get_coord_operators(self, point))
			break
		else:
			operators.append_array(Level.get_coord_operators(self, point))
	var last_operator = operators[operators.size() - 1]
	
	var result = Arithmetic.compute(operators)
	$Head.redraw(result)
	
	if last_point:
		return result
	elif last_operator is End:
		return result == last_operator.value
	else:
		return false

