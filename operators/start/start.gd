extends Operator

class_name Start

func _ready():
	add_to_group("Start")
	
	var tutorial_label = get_node_or_null("TutorialLabel")
	if tutorial_label:
		tutorial_label.rect_position = Vector2(1, 2.5) * (-Level.tile_size / 2)

func _draw():
	var nb_points = 32
	var points_arc = PoolVector2Array()
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad((360 / nb_points) * i)
		points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * Level.operator_diameter / 2)
	
	draw_polygon(points_arc, [colors.background], [], null, null, true)

func _on_reset_line():
	var line = Level.get_lines(coord * Level.tile_size + Vector2.ONE * Level.tile_size / 2)
	if line:
		line[0].queue_free()
