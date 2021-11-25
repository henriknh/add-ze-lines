extends Node2D

onready var operator = Level.get_operator(position)

var color_idx = 0

func _ready():
	if operator:
		$Button.text = ''
	
func on_add_operator():
	
	# Type
	var type = $AcceptDialog/VBoxContainer/Type/OptionButton
	for _operator in Operator.OperatorType:
		type.add_item(_operator, Operator.OperatorType[_operator])
	if operator is Start:
		type.select(Operator.OperatorType.START)
	if operator is Goal:
		type.select(Operator.OperatorType.GOAL)
	if operator is Hub:
		type.select(Operator.OperatorType.HUB)
	if operator is Block:
		type.select(Operator.OperatorType.BLOCK)
	if operator is Twist:
		type.select(Operator.OperatorType.TWIST)
	if operator is Void:
		type.select(Operator.OperatorType.VOID)
	
	# Coord
	var coord_x = $AcceptDialog/VBoxContainer/Coord/HBoxContainer/XSpinBox
	coord_x.max_value = Level.level_data.grid_size[0] - 1
	coord_x.value = operator.coord.x if operator else ((position - Vector2.ONE * Level.tile_size / 2) / Level.tile_size).x
	var coord_y = $AcceptDialog/VBoxContainer/Coord/HBoxContainer/YSpinBox
	coord_y.max_value = Level.level_data.grid_size[1] - 1
	coord_y.value = operator.coord.y if operator else ((position - Vector2.ONE * Level.tile_size / 2) / Level.tile_size).y

	# Value
	var value = $AcceptDialog/VBoxContainer/Value/SpinBox
	if operator:
		value.value = operator.value
	
	# Operation
	var operation = $AcceptDialog/VBoxContainer/Operation/OptionButton
	for _operation in Arithmetic.Operation:
		operation.add_item(_operation, Arithmetic.Operation.get(_operation))
	if operator:
		operation.select(operator.operation)
	
	# Color
	var color = $AcceptDialog/VBoxContainer/Color/GridContainer
	var color_button_group = ButtonGroup.new()
	
	for theme_color_idx in range(Themes.theme.colors.size()):
		var theme_color = Themes.theme.colors[theme_color_idx]
		
		var color_button = TextureButton.new()
		color_button.toggle_mode = true
		color_button.group = color_button_group
		color_button.connect("pressed", self, "on_color_idx", [theme_color_idx])
		if operator and operator.color_idx == theme_color_idx:
			color_button.pressed = true
		
		var texture_normal = ImageTexture.new()
		var image_normal = Image.new()
		image_normal.create(32, 32, false, 4)
		image_normal.fill(theme_color.background.darkened(0.5))
		image_normal.lock()
		texture_normal.create_from_image(image_normal)
		color_button.texture_normal = texture_normal
	
		var texture_pressed = ImageTexture.new()
		var image_pressed = Image.new()
		image_pressed.create(32, 32, false, 4)
		image_pressed.fill(theme_color.background)
		image_pressed.lock()
		texture_pressed.create_from_image(image_pressed)
		color_button.texture_pressed = texture_pressed
		
		color.add_child(color_button)
	
	var node_dialog = $AcceptDialog
	node_dialog.window_title = "Edit operator" if operator else "Add new operator"
	if operator:
		node_dialog.add_button("delete", false, "delete")
	node_dialog.popup_centered()
	node_dialog.connect("custom_action", self, "on_custom_action")
	node_dialog.connect("confirmed", self, "dialog_edit_operator", [type, coord_x, coord_y, value, operation])

func dialog_edit_operator(type: OptionButton, coord_x: SpinBox, coord_y: SpinBox, value: SpinBox, operation: OptionButton):
	var coord = Vector2(coord_x.value, coord_y.value)
	
	if type.selected == Operator.OperatorType.GOAL:
		operation.select(Arithmetic.Operation.equals)
	
	if Level.get_operator(coord):
		print('Coord already used by operator')
		breakpoint
		return

	if operator:
		var level_operator = null
		for _operator in Level.level_data.operators:
			if _operator.coord[0] == operator.coord.x and _operator.coord[1] == operator.coord.y:
				level_operator = _operator
		
		level_operator.type = type.selected
		level_operator.coord = [coord_x.value, coord_y.value]
		level_operator.value = value.value
		level_operator.operation = operation.selected
		level_operator.color_idx = color_idx
	else:
		Level.level_data.operators.append({
			"type": type.selected,
			"coord": [coord_x.value, coord_y.value],
			"value": value.value,
			"operation": operation.selected,
			"color_idx": color_idx
		})
	
	Data.save_data()

func on_custom_action(action):
	var idx_operator = null
	for i in range(Level.level_data.operators.size()):
		if Level.level_data.operators[i].coord[0] == operator.coord.x and Level.level_data.operators[i].coord[1] == operator.coord.y:
			idx_operator = i
			break
	
	if idx_operator >= 0:
		Level.level_data.operators.remove(idx_operator)
	
	Data.save_data()

func on_color_idx(_color_idx: int):
	color_idx = _color_idx
