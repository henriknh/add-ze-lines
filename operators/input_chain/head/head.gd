extends Node2D

func _ready():
	visible = false

func redraw(result):
	visible = typeof(result) == TYPE_REAL 
	if get_parent().points.size():
		position = get_parent().points[get_parent().points.size() - 1]
	
	$Label.text = result as String
	
	update()

func _draw():
	var nb_points = 32
	var points_arc = PoolVector2Array()
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad((360 / nb_points) * i)
		points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * Level.operator_diameter / 4)
	
	draw_polygon(points_arc, [get_parent().default_color], [], null, null, true)
