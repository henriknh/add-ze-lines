extends Node2D

class_name Operator

enum OperatorType { START, END, HUB, BLOCK, TWIST, VOID }
enum OperatorStatus {PENDING, SUCCESS, FAIL = -1}

export(Vector2) var coord = Vector2.ZERO
export(int) var value = 1
export(Arithmetic.Operation) var operation: int = Arithmetic.Operation.addition
export(Color) var background = Color.black
export(Color) var on_background = Color.white

export(OperatorStatus) var status = OperatorStatus.PENDING

func _ready():
	add_to_group("Operator")
	var color = Themes.theme.colors[get_tree().get_nodes_in_group("Operator").size() % Themes.theme.colors.size()]
	background = color.background
	on_background = color.on_background
	position = coord * Level.tile_size + Vector2.ONE * Level.tile_size / 2
	
	var label: Label = get_node_or_null("Label")
	if get_node("Label"):
		label.align = Label.ALIGN_CENTER
		label.valign = Label.VALIGN_CENTER
		label.rect_position = Vector2.ONE * (-Level.tile_size / 2)
		label.rect_size = Vector2.ONE * (Level.tile_size)
		var arithmetic_symbol = Arithmetic.get_operation_string(operation, value)
		var string_format = "%s(%d)" if value < 0 else "%s%d"
		if value < 0 and arithmetic_symbol != '':
			# Since parentheses and symbol take more space
			label.set("custom_fonts/font", preload("res://assets/font/font_16.tres"))
		label.text = (string_format % [arithmetic_symbol, value]).strip_edges()
		label.add_color_override("font_color", on_background)

func success():
	pass

func fail():
	pass
