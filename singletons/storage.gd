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

func reset_storage():
	config.clear()
	config.save(SAVE_FILE)
	emit_signal("storage_changed")

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
	
func unlock_theme(index: int):
	var unlocked_themes = _get_config_value("shop", "themes", [])
	if not index in unlocked_themes:
		unlocked_themes.append(index)
	_set_config_value("shop", "themes", unlocked_themes)
	
func get_unlocked_themes() -> Array:
	return _get_config_value("shop", "themes", [])

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

func set_level_complete(level_id: int):
	var completed_levels = _get_config_value("level", "completed", [])
	if not level_id in completed_levels:
		completed_levels.append(level_id)
	_set_config_value("level", "completed", completed_levels)

func get_level_completed(level_id: int) -> bool:
	var completed_levels = _get_config_value("level", "completed", [])
	var skipped_levels = _get_config_value("level", "skipped", [])
	return level_id in completed_levels or level_id in skipped_levels

func get_last_completed_level() -> int:
	var completed_levels = _get_config_value("level", "completed", [])
	var skipped_levels = _get_config_value("level", "skipped", [])
	
	var last_completed_level = null
	for idx_chapter in range(Data.data.size()):
		var chapter = Data.data[idx_chapter]
		for idx_level in range(chapter.levels.size()):
			var level = chapter.levels[idx_level]
			if level.id in completed_levels or level.id in skipped_levels:
				last_completed_level = [idx_chapter, idx_level]
	return last_completed_level

func set_level_skipped(level_id: int):
	var skipped_levels = _get_config_value("level", "skipped", [])
	if not level_id in skipped_levels:
		skipped_levels.append(level_id)
	_set_config_value("level", "skipped", skipped_levels)

func get_level_skipped(level_id: int) -> bool:
	var skipped_levels = _get_config_value("level", "skipped", [])
	return level_id in skipped_levels
	
func clear_level_data():
	_set_config_value("level", "completed", [])
	_set_config_value("level", "skipped", [])
