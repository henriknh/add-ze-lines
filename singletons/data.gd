extends Node

var data = []
signal data_saved

func _ready():
	load_data()

func save_data():
	var file = File.new()
	file.open("res://assets/levels.json", file.WRITE)
	file.store_string(JSON.print(data, "\t"))
	file.close()
	
	emit_signal("data_saved")

func load_data():
	var file = File.new()
	file.open("res://assets/levels.json", file.READ)
	var data_json = JSON.parse(file.get_as_text())
	file.close()
	
	if data_json.error:
		breakpoint
	
	data = data_json.result
	
func is_mobile():
	return OS.get_name() in ["Android", "iOS"]
