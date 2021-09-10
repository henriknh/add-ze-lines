extends Node2D


onready var operator = Level.get_operator(position)

func _ready():
	if operator:
		$Button.text = ''
	
func on_add_operator():
	var dialog = AcceptDialog.new()
	dialog.window_title = "Edit operator" if operator else "Add new operator"
	
	var container = VBoxContainer.new()
	
	# Type
	
	var type_label = Label.new()
	type_label.text = "Type"
	container.add_child(type_label)
	
	var type = OptionButton.new()
	type.add_item("Start", Operator.OperatorType.START)
	type.add_item("End", Operator.OperatorType.END)
	type.add_item("Hub", Operator.OperatorType.HUB)
	type.add_item("Block", Operator.OperatorType.BLOCK)
	if operator is Start:
		type.select(Operator.OperatorType.START)
	if operator is End:
		type.select(Operator.OperatorType.END)
	if operator is Hub:
		type.select(Operator.OperatorType.HUB)
	if operator is Block:
		type.select(Operator.OperatorType.BLOCK)
	container.add_child(type)
	
	# Coord
	
	var coord_label = Label.new()
	coord_label.text = "Coord"
	container.add_child(coord_label)
	
	var coord_container = HBoxContainer.new()
	
	var coord_x = SpinBox.new()
	coord_x.min_value = 0
	coord_x.max_value = Level.current_level.grid_size - 1
	if operator:
		coord_x.value = operator.coord.x
	else:
		coord_x.value = ((position - Vector2.ONE * Level.tile_size / 2) / Level.tile_size).x
	coord_container.add_child(coord_x)
	
	var coord_y = SpinBox.new()
	coord_y.min_value = 0
	coord_y.max_value = Level.current_level.grid_size - 1
	if operator:
		coord_y.value = operator.coord.y
	else:
		coord_y.value = ((position - Vector2.ONE * Level.tile_size / 2) / Level.tile_size).y
	coord_container.add_child(coord_y)
	
	container.add_child(coord_container)
	
	# Value
	
	var value_label = Label.new()
	value_label.text = "Value"
	container.add_child(value_label)
	
	var value = SpinBox.new()
	value.min_value = -100
	value.max_value = 100
	if operator:
		value.value = operator.value
	container.add_child(value)
	
	# Operation
	
	var operation_label = Label.new()
	operation_label.text = "Operation"
	container.add_child(operation_label)
	
	var operation = OptionButton.new()
	for _operation in Arithmetic.Operation:
		operation.add_item(_operation, Arithmetic.Operation.get(_operation))
	if operator:
		operation.select(operator.operation)
	container.add_child(operation)
	
	if operator:
		dialog.add_button("delete", false, "delete")
		
	
	dialog.add_child(container)
	add_child(dialog)
	dialog.popup_centered()
	
	dialog.connect("custom_action", self, "on_custom_action")
	
	dialog.connect("confirmed", self, "dialog_edit_operator", [type, coord_x, coord_y, value, operation])

func dialog_edit_operator(type: OptionButton, coord_x: SpinBox, coord_y: SpinBox, value: SpinBox, operation: OptionButton):
	var coord = Vector2(coord_x.value, coord_y.value)
	
	if type.selected == Operator.OperatorType.END:
		operation.select(Arithmetic.Operation.equals)
	
	if Level.get_operator(coord):
		print('Coord already used by operator')
		breakpoint
		return
	
	if operator:
		var level_operator = null
		for _operator in Level.current_level.operators:
			if _operator.coord_x == operator.coord.x and _operator.coord_y == operator.coord.y:
				level_operator = _operator
		
		level_operator.type = type.selected
		level_operator.coord_x = coord_x.value
		level_operator.coord_y = coord_y.value
		level_operator.value = value.value
		level_operator.operation = operation.selected
	else:
		Level.current_level.operators.append({
			"type": type.selected,
			"coord_x": coord_x.value,
			"coord_y": coord_y.value,
			"value": value.value,
			"operation": operation.selected
		})
	
	Data.save_data()

func on_custom_action(action):
	var idx_operator = null
	for i in range(Level.current_level.operators.size()):
		if Level.current_level.operators[i].coord_x == operator.coord.x and Level.current_level.operators[i].coord_y == operator.coord.y:
			idx_operator = i
			break
	
	if idx_operator >= 0:
		Level.current_level.operators.remove(idx_operator)
	
	Data.save_data()
