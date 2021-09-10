extends Node2D

func on_add_operator():
	var dialog = AcceptDialog.new()
	dialog.window_title = "Add new operator"
	
	var container = VBoxContainer.new()
	
	# Type
	
	var type_label = Label.new()
	type_label.text = "Type"
	container.add_child(type_label)
	
	var type = OptionButton.new()
	type.add_item("Start", 0)
	type.add_item("End", 1)
	type.add_item("Hub", 2)
	container.add_child(type)
	
	# Coord
	
	var coord_label = Label.new()
	coord_label.text = "Coord"
	container.add_child(coord_label)
	
	var coord_container = HBoxContainer.new()
	
	var coord_x = SpinBox.new()
	coord_x.min_value = 0
	coord_x.max_value = Level.current_level.grid_size - 1
	coord_container.add_child(coord_x)
	
	var coord_y = SpinBox.new()
	coord_y.min_value = 0
	coord_y.max_value = Level.current_level.grid_size - 1
	coord_container.add_child(coord_y)
	
	container.add_child(coord_container)
	
	# Value
	
	var value_label = Label.new()
	value_label.text = "Value"
	container.add_child(value_label)
	
	var value = SpinBox.new()
	container.add_child(value)
	
	# Operation
	
	var operation_label = Label.new()
	operation_label.text = "Operation"
	container.add_child(operation_label)
	
	var operation = OptionButton.new()
	for _operation in Arithmetic.Operation:
		operation.add_item(_operation, Arithmetic.Operation.get(_operation))
	container.add_child(operation)
	
	dialog.add_child(container)
	add_child(dialog)
	dialog.popup_centered()
	
	dialog.connect("confirmed", self, "dialog_add_operator", [type, coord_x, coord_y, value, operation])


func dialog_add_operator(type: OptionButton, coord_x: SpinBox, coord_y: SpinBox, value: SpinBox, operation: OptionButton):
	var coord = Vector2(coord_x.value, coord_y.value)
	
	if Level.get_operator(coord):
		print('Coord already used by operator')
		breakpoint
		return
		
	Level.current_level.operators.append({
		"type": type.selected,
		"coord_x": coord_x.value,
		"coord_y": coord_y.value,
		"value": value.value,
		"operation": operation.selected
	})
	Data.save_data()
	
	pass # Replace with function body.
