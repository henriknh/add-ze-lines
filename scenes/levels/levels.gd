extends MarginContainer

class_name Levels

onready var chapters_outlet = $VBoxContainer/ScrollContainer/VBoxContainer
var _theme = preload("res://theme_solid.tres")

func _ready():
	Data.connect("data_saved", self, "load_levels")
	load_levels()

func load_levels():
	for child in chapters_outlet.get_children():
		chapters_outlet.remove_child(child)
	
	for chapter in range(Data.data.size()):
		
		if Storage.editor:
			var chapter_editor = HBoxContainer.new()
			
			var chapter_label = Label.new()
			chapter_label.text = "Chapter %d" % (chapter + 1)
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
	
	# Button to add new chapter
	if Storage.editor:
		var button_new_chapter = Button.new()
		button_new_chapter.theme = preload("res://scenes/levels/level_button.tres")
		button_new_chapter.text = "New chapter"
		button_new_chapter.rect_min_size = Vector2(60, 40)
		button_new_chapter.focus_mode = Control.FOCUS_NONE
		button_new_chapter.connect("pressed", self, "_on_new_chapter")
		chapters_outlet.add_child(button_new_chapter)
	
func _on_back():
	get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")

func _on_move(chapter: int, dir: int):
	var chapter_data = Data.data[chapter]
	Data.data.remove(chapter)
	Data.data.insert(chapter + dir, chapter_data)
	Data.save_data()

func _on_delete(chapter: int):
	Data.data.remove(chapter)
	Data.save_data()









	
	
	
	
	
	
	
	
	
	
	
	
	
	
func play_level(chapter, level, is_editor = false):
	Level.init(chapter, level, is_editor)
	
func _on_new_chapter():
	Data.data.append({
		"levels": []
	})
	Data.save_data()

func edit_chapter(chapter: int):
	var dialog = AcceptDialog.new()
	dialog.connect("custom_action", self, "on_edit_chapter", [chapter, dialog])
	if chapter > 0:
		dialog.add_button("Move up", true, "move_up")
	if chapter < Data.data.size() - 1:
		dialog.add_button("Move down", true, "move_down")
	dialog.add_button("Delete", true, "delete")
	
	add_child(dialog)
	dialog.popup_centered()

func on_edit_chapter(action: String, chapter: int, dialog: AcceptDialog):
	var chapter_data = Data.data[chapter]
	
	if action is String and action == "move_up":
		Data.data.remove(chapter)
		Data.data.insert(chapter - 1, chapter_data)
	elif action is String and action == "move_down":
		Data.data.remove(chapter)
		Data.data.insert(chapter + 1, chapter_data)
	elif action is String and action == "delete":
		Data.data.remove(chapter)
	
	dialog.queue_free()

func edit_level(chapter: int, level: int):
	var dialog = AcceptDialog.new()
	dialog.connect("custom_action", self, "on_edit_level", [level, chapter, dialog])
	dialog.add_button("Edit level", true, "edit")
	if level > 0:
		dialog.add_button("Move up", true, "move_up")
	if level < Data.data[chapter].levels.size() - 1:
		dialog.add_button("Move down", true, "move_down")
	dialog.add_button("Delete", true, "delete")
	
	add_child(dialog)
	dialog.popup_centered()

func on_edit_level(action: String, level: int, chapter: int, dialog: AcceptDialog):
	var chapter_data = Data.data[chapter]
	var level_data = chapter_data.levels[level]
	
	if action is String and action == "edit":
		play_level(chapter, level, true)
	elif action is String and action == "move_up":
		chapter_data.levels.remove(level)
		chapter_data.levels.insert(level - 1, level_data)
	elif action is String and action == "move_down":
		chapter_data.levels.remove(level)
		chapter_data.levels.insert(level + 1, level_data)
	elif action is String and action == "delete":
		chapter_data.levels.remove(level)
	
	dialog.queue_free()
