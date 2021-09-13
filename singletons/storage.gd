extends Node

const SAVE_FILE: String = "user://settings.cfg"
var config = ConfigFile.new()

var show_addition_symbol: bool = false setget set_show_addition_symbol, get_show_addition_symbol
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

func set_show_addition_symbol(show_addition_symbol):
	_set_config_value("setting", "show_addition_symbol", show_addition_symbol)

func get_show_addition_symbol() -> bool:
	return OS.is_debug_build() and _get_config_value("setting", "show_addition_symbol", false)

func set_editor(_editor):
	_set_config_value("setting", "editor", _editor)

func get_editor() -> bool:
	return OS.is_debug_build() and _get_config_value("setting", "editor", false)

func set_level_complete(chapter, level):
	var completed_levels = _get_config_value("level", chapter.title, [])
	if not level.title in completed_levels:
		completed_levels.append(level.title)
	_set_config_value("level", chapter.title, completed_levels)

func get_last_completed_level():
	var chapters = Data.data.duplicate()
	chapters.invert()
	for chapter in chapters:
		if config.has_section_key("level", chapter.title):
			return [chapter.title, _get_config_value("level", chapter.title, null).back()]
	return null
	
