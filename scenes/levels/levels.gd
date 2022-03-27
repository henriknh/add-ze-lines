extends Control

class_name Levels

onready var scroll_container: ScrollContainer = $ScrollContainer
onready var chapters_outlet = $ScrollContainer/MarginContainer/ChapterOutlet
onready var node_header = $MarginContainer/Header
var _theme = preload("res://theme_solid.tres")

func _ready():
	yield(get_tree(), "idle_frame")
	Data.connect("data_saved", self, "load_levels")
	load_levels()
	
	Themes.connect("theme_changed", self, "_update_ui")
	_update_ui()
	
func _update_ui():
	node_header.add_color_override("font_color", Themes.theme.on_background)

func load_levels():
	for child in chapters_outlet.get_children():
		chapters_outlet.remove_child(child)
	
	for chapter in range(Data.data.size()):
		
		if Storage.editor:
			var chapter_editor = HBoxContainer.new()
			
			var chapter_label = Label.new()
			chapter_label.text = tr("CHAPTER") + " %d" % (chapter + 1)
			chapter_label.size_flags_horizontal = SIZE_FILL + SIZE_EXPAND
			chapter_editor.add_child(chapter_label)
			
			var chapter_move_up = Button.new()
			chapter_move_up.text = "^"
			chapter_move_up.connect("pressed", self, "_on_move", [chapter, -1])
			chapter_move_up.disabled = chapter == 0
			chapter_editor.add_child(chapter_move_up)
			
			var chapter_move_down = Button.new()
			chapter_move_down.text = "v"
			chapter_move_down.connect("pressed", self, "_on_move", [chapter, 1])
			chapter_move_down.disabled = (chapter + 1) == Data.data.size()
			chapter_editor.add_child(chapter_move_down)
			
			var chapter_move_delete = Button.new()
			chapter_move_delete.text = "x"
			chapter_move_delete.connect("pressed", self, "_on_delete", [chapter])
			chapter_editor.add_child(chapter_move_delete)
			
			chapters_outlet.add_child(chapter_editor)
		
		var chapter_instance = preload("res://scenes/levels/chapter/chapter.tscn").instance()
		chapter_instance.chapter = chapter
		chapters_outlet.add_child(chapter_instance)
		
		#if chapter + 1 < Data.data.size():
		#	chapters_outlet.add_child(preload("res://scenes/levels/chapter_separator/chapter_separator.tscn").instance())
	
	# Button to add new chapter
	if Storage.editor:
		var button_new_chapter = Button.new()
		button_new_chapter.theme = preload("res://scenes/levels/level_button.tres")
		button_new_chapter.text = "New chapter"
		button_new_chapter.rect_min_size = Vector2(60, 40)
		button_new_chapter.focus_mode = Control.FOCUS_NONE
		button_new_chapter.connect("pressed", self, "_on_new_chapter")
		chapters_outlet.add_child(button_new_chapter)
	
	#yield(get_tree(), "idle_frame")
	var last_enabled = null
	for button in get_tree().get_nodes_in_group("PlayLevelButton"):
		if not button.disabled:
			last_enabled = button
	if last_enabled:
		scroll_container.ensure_control_visible(last_enabled)
		scroll_container.scroll_vertical += scroll_container.rect_size.y / 2
	
func _on_back():
	#get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")
	SceneHandler.switch_to(SceneHandler.SCENES.MAIN_MENU)

func _on_move(chapter: int, dir: int):
	var chapter_data = Data.data[chapter]
	Data.data.remove(chapter)
	Data.data.insert(chapter + dir, chapter_data)
	Data.save_data()

func _on_delete(chapter: int):
	Data.data.remove(chapter)
	Data.save_data()
