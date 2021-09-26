extends Node

enum Operation {
	addition,
	multiplication,
	division,
	equals,
}

func compute(operators: Array):
	var result = 0
	for operator in operators:
		match operator.operation:
			Arithmetic.Operation.addition:
				result += operator.value
			Arithmetic.Operation.multiplication:
				result *= operator.value
			Arithmetic.Operation.division:
				result /= operator.value
			Arithmetic.Operation.equals:
				return result
	
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
