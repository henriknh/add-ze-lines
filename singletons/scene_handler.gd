extends Node


onready var scene_main_menu = preload("res://scenes/main_menu/main_menu.tscn").instance()
onready var scene_game = preload("res://scenes/game/game.tscn").instance()
onready var scene_levels = preload("res://scenes/levels/levels.tscn").instance()
onready var scene_themes = preload("res://scenes/themes/themes.tscn").instance()
onready var scene_settings = preload("res://scenes/settings/settings.tscn").instance()

enum SCENES {
	MAIN_MENU,
	GAME,
	LEVELS,
	THEMES,
	SETTINGS
}
onready var scenes = {
	SCENES.MAIN_MENU: scene_main_menu,
	SCENES.GAME: scene_game,
	SCENES.LEVELS: scene_levels,
	SCENES.THEMES: scene_themes,
	SCENES.SETTINGS: scene_settings
}

onready var root = get_tree().root
onready var current_id = -1
onready var current = scenes[SCENES.MAIN_MENU]#get_tree().current_scene
onready var previous = null

func _ready():
	yield(get_tree(), "idle_frame")
	
	switch_to(SCENES.MAIN_MENU)

func switch_to(scene: int):
	current_id = scene
	_set_scene(scenes[scene])
	
func back():
	if previous:
		_set_scene(previous)
	
func _set_scene(scene):
	if is_instance_valid(current):
		current.set_process(false)
		previous = current
		
		if root.is_a_parent_of(current):
			root.remove_child(current)
	
	root.add_child(scene)
	scene.set_process(true)
	get_tree().current_scene = scene
	current = scene
	
func is_current(scene: int) -> bool:
	return scene == current_id
	
