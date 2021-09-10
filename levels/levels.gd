extends MarginContainer

onready var chapters_outlet = $VBoxContainer/ScrollContainer/VBoxContainer

func _ready():
	load_levels()
	
func save_and_reload():
	Data.save_data()
	load_levels()

func load_levels():
	for child in chapters_outlet.get_children():
		chapters_outlet.remove_child(child)
	
	for chapter in Data.data:
		var container = VBoxContainer.new()
		container.set("custom_constants/separation", 24)
		
		# Metadata
		var container_title = HBoxContainer.new()
		
		# chapter title
		var chapter_title = Label.new()
		chapter_title.text = chapter.title
		chapter_title.size_flags_horizontal = SIZE_EXPAND_FILL
		chapter_title.set("custom_fonts/font", preload("res://assets/font/font_48.tres"))
		container_title.add_child(chapter_title)
		
		# edit chapter
		if Storage.editor:
			var edit_chapter = Button.new()
			edit_chapter.text = "edit"
			edit_chapter.theme = preload("res://levels/levels.tres")
			edit_chapter.connect("pressed", self, "edit_chapter", [chapter])
			container_title.add_child(edit_chapter)
		
		container.add_child(container_title)
		
		# Levels
		var container_grid = GridContainer.new()
		container_grid.columns = 1 if Storage.editor else 2
		
		for level in chapter.levels:
			var level_container = HBoxContainer.new()
			
			# play level
			var play_level = Button.new()
			play_level.theme = preload("res://levels/levels.tres")
			play_level.text = level.title
			play_level.size_flags_horizontal = SIZE_EXPAND_FILL
			play_level.connect("pressed", self, "play_level", [chapter, level])
			level_container.add_child(play_level)
			
			# edit level
			if Storage.editor:
				var edit_level = Button.new()
				edit_level.theme = preload("res://levels/levels.tres")
				edit_level.text = "edit"
				edit_level.connect("pressed", self, "edit_level", [chapter, level])
				level_container.add_child(edit_level)
			
			container_grid.add_child(level_container)
		
		# add new level
		if Storage.editor:
			var button_add_level = Button.new()
			button_add_level.text = "new"
			button_add_level.theme = preload("res://levels/levels.tres")
			button_add_level.connect("pressed", self, "new_level", [chapter])
			container_grid.add_child(button_add_level)
		
		container.add_child(container_grid)
		chapters_outlet.add_child(container)
	
	# add new chapter
	if Storage.editor:
		var button_add_chapter = Button.new()
		button_add_chapter.text = "new chapter"
		button_add_chapter.theme = preload("res://levels/levels.tres")
		button_add_chapter.connect("pressed", self, "new_chapter")
		chapters_outlet.add_child(button_add_chapter)

func _on_load_level():
	get_tree().change_scene("res://game/game.tscn")
	
func _on_back():
	get_tree().change_scene("res://menu/menu.tscn")
	
func play_level(chapter, level):
	Level.init(chapter, level)
	get_tree().change_scene("res://game/game.tscn")
	
func new_chapter():
	Data.data.append({
		"title": "chapter %d" % (Data.data.size() + 1),
		"levels": []
	})
	save_and_reload()

func edit_chapter(chapter):
	var idx = Data.data.find(chapter)
	
	var dialog = AcceptDialog.new()
	dialog.connect("custom_action", self, "on_edit_chapter", [chapter, dialog])
	if idx > 0:
		dialog.add_button("Move up", true, "move_up")
	if idx < Data.data.size() - 1:
		dialog.add_button("Move down", true, "move_down")
	dialog.add_button("Delete", true, "delete")
	
	var line_edit = LineEdit.new()
	line_edit.text = chapter.title
	dialog.register_text_enter(line_edit)
	dialog.add_child(line_edit)
	dialog.connect("confirmed", self, "on_edit_chapter", [line_edit, chapter, dialog])
	
	add_child(dialog)
	dialog.popup_centered()

func on_edit_chapter(action, chapter, dialog: AcceptDialog):
	var idx = Data.data.find(chapter)
	
	if action is String and action == "move_up":
		Data.data.remove(idx)
		Data.data.insert(idx - 1, chapter)
	elif action is String and action == "move_down":
		Data.data.remove(idx)
		Data.data.insert(idx + 1, chapter)
	elif action is String and action == "delete":
		Data.data.remove(idx)
	else:
		chapter.title = action.text
	
	dialog.queue_free()
	save_and_reload()

func new_level(chapter):
	chapter.levels.append({
		"title": "level %d" % (chapter.levels.size() + 1),
		"grid_size": 5,
		"operators": []
	})
	save_and_reload()

func edit_level(chapter, level):
	var idx = chapter.levels.find(level)
	
	var dialog = AcceptDialog.new()
	dialog.connect("custom_action", self, "on_edit_level", [level, chapter, dialog])
	if idx > 0:
		dialog.add_button("Move up", true, "move_up")
	if idx < chapter.levels.size() - 1:
		dialog.add_button("Move down", true, "move_down")
	dialog.add_button("Delete", true, "delete")
	
	var line_edit = LineEdit.new()
	line_edit.text = level.title
	dialog.register_text_enter(line_edit)
	dialog.add_child(line_edit)
	dialog.connect("confirmed", self, "on_edit_level", [line_edit, level, chapter, dialog])
	
	add_child(dialog)
	dialog.popup_centered()

func on_edit_level(action, level, chapter, dialog: AcceptDialog):
	var idx = chapter.levels.find(level)
	
	if action is String and action == "move_up":
		chapter.levels.remove(idx)
		chapter.levels.insert(idx - 1, level)
	elif action is String and action == "move_down":
		chapter.levels.remove(idx)
		chapter.levels.insert(idx + 1, level)
	elif action is String and action == "delete":
		chapter.levels.remove(idx)
	else:
		level.title = action.text
	
	dialog.queue_free()
	save_and_reload()
