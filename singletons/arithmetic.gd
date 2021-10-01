extends Node

enum Operation {
	addition,
	multiplication,
	division,
	equals,
}

func compute(value, operator):
	match operator.operation:
		Arithmetic.Operation.addition:
			return value + operator.value
		Arithmetic.Operation.multiplication:
			return value * operator.value
		Arithmetic.Operation.division:
			return value / operator.value
		Arithmetic.Operation.equals:
			return value
	
func compute_operators(operators: Array):
	var result = 0
	for operator in operators:
		result = compute(result, operator)
	
	# https://docs.godotengine.org/en/stable/classes/class_expression.html
	return result

func get_operation_string(operation: int, value: int) -> String:
	match operation:
		Arithmetic.Operation.addition:
			return '+' if Storage.show_addition_symbol else ''
		Arithmetic.Operation.multiplication:
			return '×'
		Arithmetic.Operation.division:
			return '÷'
		Arithmetic.Operation.equals:
			return ''
	return 'X'
