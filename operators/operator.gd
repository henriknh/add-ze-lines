extends Node2D

class_name Operator

enum OperatorType { START, END, HUB, BLOCK }
enum OperatorStatus {PENDING, SUCCESS, FAIL = -1}

export(Vector2) var coord = Vector2.ZERO
export(int) var value = 1
export(Arithmetic.Operation) var operation: int = Arithmetic.Operation.addition
export(Color) var background = Color.black
export(Color) var on_background = Color.white

export(OperatorStatus) var status = OperatorStatus.PENDING

func _ready():
	add_to_group("Operator")
	var colors = Themes.theme.colors[get_tree().get_nodes_in_group("Operator").size() % Themes.theme.colors.size()]
	background = colors.background
	on_background = colors.on_background
	position = coord * Level.tile_size + Vector2.ONE * Level.tile_size / 2
	
	var label: Label = get_node_or_null("Label")
	if get_node("Label"):
		label.align = Label.ALIGN_CENTER
		label.valign = Label.VALIGN_CENTER
		label.rect_position = Vector2.ONE * (-Level.tile_size / 2)
		label.rect_size = Vector2.ONE * (Level.tile_size)
		label.text = ("%s%d" % [Arithmetic.get_operation_string(operation), value]).strip_edges()
		label.add_color_override("font_color", on_background)

func success():
	pass

func fail():
	pass
