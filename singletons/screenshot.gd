extends Node

onready var initial_resolution: Vector2 = OS.window_size
var target_resolution: Vector2 = Vector2(1080, 1920)
onready var current_resolution: Vector2 = initial_resolution

func _ready():
	
	yield(get_tree(), "idle_frame")

func _input(event):
	if not OS.is_debug_build():
		return
	
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_S) and just_pressed:
		var filename = "user://screenshot_" + OS.get_system_time_msecs() as String +".png"
		var image = get_viewport().get_texture().get_data()
		image.flip_y()
		image.save_png(filename)
	
	if Input.is_key_pressed(KEY_R) and just_pressed:
		OS.window_size = target_resolution if OS.window_size == initial_resolution else initial_resolution
		#get_tree().set_screen_stretch( SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, target_resolution)
