extends Node2D

class_name Operator

enum OperatorStatus {PENDING, SUCCESS, FAIL = -1}

export(Vector2) var coord = Vector2.ZERO
export(int) var number = 1
export(Arithmetic.Operation) var operation: int = Arithmetic.Operation.addition
export(Color) var color_background = Color.black
export(Color) var color_foreground = Color.white

export(OperatorStatus) var status = OperatorStatus.PENDING

func _ready():
	add_to_group("Operator")
	var colors = Level.colors[get_tree().get_nodes_in_group("Operator").size() % Level.colors.size()]
	color_background = colors.background
	color_foreground = colors.foreground
	position = coord * Level.tile_size + Vector2.ONE * Level.tile_size / 2
	
	var label: Label = get_node_or_null("Label")
	if get_node("Label"):
		label.align = Label.ALIGN_CENTER
		label.valign = Label.VALIGN_CENTER
		label.rect_position = Vector2.ONE * (-Level.tile_size / 2)
		label.rect_size = Vector2.ONE * (Level.tile_size)
		label.text = ("%s%d" % [Arithmetic.get_operation_string(operation), number]).strip_edges()
		label.add_color_override("font_color", color_foreground)

func success():
	pass

func fail():
	pass
