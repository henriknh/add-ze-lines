extends Node2D

onready var label = $Label
var value
var colors: Colors

func _ready():
	label.text = value as String
	label.add_color_override("font_color", colors.on_background)
	
func _draw():
	var nb_points = 32
	var points_arc = PoolVector2Array()
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad((360 / nb_points) * i)
		points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * Level.operator_diameter / 4)
	
	draw_polygon(points_arc, [colors.background], [], null, null, true)
