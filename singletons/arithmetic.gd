extends Node

enum Operation {
	addition,
	subtraction,
	multiplication,
	division,
	equals,
}

func compute(operators: Array):
	var result = 0
	for operator in operators:
		match operator.operation:
			Arithmetic.Operation.addition:
				result += operator.number
			Arithmetic.Operation.subtraction:
				result -= operator.number
			Arithmetic.Operation.multiplication:
				result *= operator.number
			Arithmetic.Operation.division:
				result /= operator.number
			Arithmetic.Operation.equals:
				return result == operator.number
	
	# https://docs.godotengine.org/en/stable/classes/class_expression.html
	return result

func get_operation_string(operation: int) -> String:
	match operation:
		Arithmetic.Operation.addition:
			return ''
		Arithmetic.Operation.subtraction:
			return '-'
		Arithmetic.Operation.multiplication:
			return '*'
		Arithmetic.Operation.division:
			return '/'
		Arithmetic.Operation.equals:
			return ''
	return 'X'
