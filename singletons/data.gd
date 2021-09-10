extends Node

var data = []
signal data_loaded

func _ready():
	load_data()

func save_data():
	var file = File.new()
	file.open("res://assets/levels.json", file.WRITE)
	file.store_string(JSON.print(data, "\t"))
	file.close()
	
	load_data()

func load_data():
	var file = File.new()
	file.open("res://assets/levels.json", file.READ)
	var data_json = JSON.parse(file.get_as_text())
	file.close()
	
	if data_json.error:
		breakpoint
	
	data = data_json.result
	
	emit_signal("data_loaded")
