extends Node

signal storage_changed
const SAVE_FILE: String = "user://settings.cfg"
const CHAPTER_MULTIPLIER = 1000
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
	emit_signal("storage_changed")

func _get_config_value(section, key, default):
	return config.get_value(section, key, default)
	
func set_gems(gems: int):
	_set_config_value("user", "gems", gems)
	
func get_gems() -> int:
	return _get_config_value("user", "gems", 0)
	
func set_theme(theme: int):
	_set_config_value("user", "theme", theme)
	
func get_theme() -> int:
	return _get_config_value("user", "theme", 0)
	
func set_locale(locale: String):
	_set_config_value("setting", "locale", locale)
	
func get_locale() -> String:
	return _get_config_value("setting", "locale", "en")

func set_show_addition_symbol(show_addition_symbol):
	_set_config_value("setting", "show_addition_symbol", show_addition_symbol)

func get_show_addition_symbol() -> bool:
	return _get_config_value("setting", "show_addition_symbol", false)

func set_editor(_editor):
	_set_config_value("setting", "editor", _editor)

func get_editor() -> bool:
	return OS.is_debug_build() and _get_config_value("setting", "editor", false)

func set_level_complete(chapter: int, level: int):
	var value = chapter * CHAPTER_MULTIPLIER + level
	var completed_levels = _get_config_value("level", "completed", [])
	if not value in completed_levels:
		completed_levels.append(value)
	_set_config_value("level", "completed", completed_levels)

func get_level_completed(chapter: int, level: int) -> bool:
	var value = chapter * CHAPTER_MULTIPLIER + level
	var completed_levels = _get_config_value("level", "completed", [])
	return value in completed_levels

func get_last_completed_level():
	var completed_levels = _get_config_value("level", "completed", [])
	
	if completed_levels.size() > 0:
		var largest = 0
		
		for level in completed_levels:
			if level > largest:
				largest = level
		
		var level = largest % CHAPTER_MULTIPLIER
		var chapter = int(largest / CHAPTER_MULTIPLIER)
		return [chapter, level]
	return null
	
func clear_completed_levels():
	_set_config_value("level", "completed", [])
