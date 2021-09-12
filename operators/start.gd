extends Operator

class_name Start

func _ready():
	add_to_group("Start")

func success():
	pass

func fail():
	pass

func _draw():
	var nb_points = 32
	var points_arc = PoolVector2Array()
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad((360 / nb_points) * i)
		points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * Level.operator_diameter / 2)
	print(Level.tile_size)
	print(Level.operator_diameter)
	print(Level.operator_diameter / 2)
	print((Level.operator_diameter / 2.0) / Level.tile_size)
	
	draw_polygon(points_arc, [background], [], null, null, true)
