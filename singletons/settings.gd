extends Node

const SAVE_FILE: String = "user://settings.cfg"
var config = ConfigFile.new()

var editor: bool = false setget set_editor, get_editor

func _ready():
	var directory = Directory.new();
	var file_exists = directory.file_exists(SAVE_FILE)
	if not file_exists:
		var new_config_file = File.new()
		new_config_file.open(SAVE_FILE, File.WRITE)
		new_config_file.close()
	
	var err = config.load(SAVE_FILE)
	if err != OK:
		breakpoint

func _set_config_value(section, key, value):
	config.set_value(section, key, value)
	config.save(SAVE_FILE)

func _get_config_value(section, key, default):
	return config.get_value(section, key, default)

func set_editor(_editor):
	_set_config_value("setting", "editor", _editor)

func get_editor() -> bool:
	return OS.is_debug_build() and _get_config_value("setting", "editor", false)
	
