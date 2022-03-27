extends Node2D

class_name Operator

onready var label = $Label
enum OperatorType { START, GOAL, HUB, BLOCK, TWIST, VOID }
enum OperatorStatus {PENDING = 0, SUCCESS = 1, FAIL = -1}

export(Vector2) var coord = Vector2.ZERO
export(int) var value = 1
export(Arithmetic.Operation) var operation: int = Arithmetic.Operation.addition
export(int) var color_idx: int = 0

export(OperatorStatus) var status = OperatorStatus.PENDING setget set_status

onready var colors: Colors = Colors.new()

func _ready():
	add_to_group("Operator")
	
	get_color_from_theme(color_idx)
	
	position = coord * Level.tile_size + Vector2.ONE * Level.tile_size / 2
	position -= Vector2.ONE * (Level.tile_size / 2) * Vector2(
		Level.level_data.grid_size[0], 
		Level.level_data.grid_size[1]
	)
	
	if get_node("Label"):
		label.align = Label.ALIGN_CENTER
		label.valign = Label.VALIGN_CENTER
		label.rect_position = Vector2.ONE * (-Level.tile_size / 2)
		label.rect_size = Vector2.ONE * (Level.tile_size)
		var arithmetic_symbol = Arithmetic.get_operation_string(operation, value, is_in_group("Start"))
		var string_format = "%s(%d)" if value < 0 and arithmetic_symbol != '' else "%s%d"
		if value < 0 and arithmetic_symbol != '':
			# Since parentheses and symbol take more space
			label.set("custom_fonts/font", preload("res://assets/font/font_16.tres"))
		label.text = (string_format % [arithmetic_symbol, value]).strip_edges()
		label.add_color_override("font_color", colors.on_background)
		
	var is_tutorial = Level.chapter == 0 and (Level.level == 0 or Level.level == 1)
	var tutorial_label = get_node_or_null("TutorialLabel")
	if tutorial_label:
		tutorial_label.visible = is_tutorial
	if is_tutorial and tutorial_label:
		tutorial_label.set("custom_fonts/font", preload("res://assets/font/font_16.tres"))
		tutorial_label.add_color_override("font_color", Themes.theme.on_background)
		tutorial_label.align = Label.ALIGN_CENTER
		tutorial_label.valign = Label.VALIGN_CENTER
		#tutorial_label.rect_position = Vector2.ONE * (-Level.tile_size / 2)
		tutorial_label.rect_size = Vector2.ONE * (Level.tile_size)
	
func get_color_from_theme(idx: int):
	colors.get_from_theme(idx)
	if label:
		label.add_color_override("font_color", colors.on_background)
	
func compute(_value: int) -> int:
	return _value

func set_status(_status):
	status = _status
	update()
