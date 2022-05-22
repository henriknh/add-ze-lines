extends Node2D

class_name Line

var points = [] setget set_points
var colors: Colors
var start_operator: Start = null

func _ready():
	add_to_group("Line")
	start_operator = Level.get_operator(points[0])
	$Line2D.default_color = colors.background
	$Line2D.points = points

func set_points(_points):
	if _points.size() and _points.size() > $Line2D.points.size():
		var line_effect = preload("res://operators/line/line_effect/line_effect.tscn").instance()
		line_effect.position = _points[_points.size() - 1]
		line_effect.self_modulate = colors.background
		add_child(line_effect)
	points = _points
	$Line2D.points = points
	
func on_goal_input():
	_remove_on_other_line()
	
	if points.size() <= 1:
		points = []
		queue_free()
	else:
		$Line2D.points = points
		

func _remove_on_other_line():
	
	var game = get_node_or_null("/root/Game")
	if not game:
		points = []
		return
		
	var _points = points
	while true:
		if points.size() == 0:
			break		
		
		var goal_on_other_line = game.any_line_has_point(_points[_points.size() - 1], self)
		if goal_on_other_line:
			_points.remove(_points.size() - 1)
		else:
			points = _points
			break

func compute(last_point = null) -> bool:
	var result = 0
	
	if last_point == null:
		for child in $Heads.get_children():
			child.queue_free()
		
	if points.size() <= 1:
		return false
	
	var start = Level.get_operator(points[0])
	var last_point_has_hub = false
	
	for goal in get_tree().get_nodes_in_group("Goal"):
		goal.reset_color()
	
	for i in range(points.size()):
		var curr_point = points[i]
		var prev_point = points[i - 1]
		var next_point = points[i + 1] if i + 1 < points.size() else null
		
		var operators = Level.get_coord_operators(self, curr_point)
		var prev_point_diff = curr_point - prev_point if prev_point else Vector2.ZERO
		var next_point_diff = curr_point - next_point if next_point else Vector2.ZERO
		
		for operator in operators:
			result = Arithmetic.compute(result, operator)
			
			if operator is Goal:
				var line_successful = result == operator.value
				
				if operator.color_idx > 0 and operator.color_idx != start.color_idx:
					line_successful = false
				
				operator.status = Operator.OperatorStatus.SUCCESS if line_successful else Operator.OperatorStatus.FAIL
				if line_successful:
					operator.set_line_color(colors.duplicate())
				else:
					instance_head(result, curr_point - prev_point_diff * 0.33, last_point == null)
				
				return line_successful
			elif operator is Hub:
				last_point_has_hub = curr_point == points[points.size() - 1]
				if last_point_has_hub:
					var offset = (curr_point as Vector2).direction_to(prev_point) * Level.tile_size * 0.33
					instance_head(result, curr_point + offset, last_point == null)
				else:
					var offset = (curr_point as Vector2).direction_to(next_point) * Level.tile_size * 0.33
					instance_head(result, curr_point + offset, last_point == null)
		
		if last_point and curr_point == last_point:
			break
	
	# Make end of line head
	if not last_point_has_hub and points.size() >= 2:
		instance_head(result, points[points.size() - 1], last_point == null)
	
	if last_point:
		return result
	else:
		return false

func instance_head(value, position: Vector2, should_render):
	if should_render == false:
		return
	var head = preload("res://operators/line/head/head.tscn").instance()
	head.value = value
	head.colors = colors
	head.position = position
	$Heads.add_child(head)
	
