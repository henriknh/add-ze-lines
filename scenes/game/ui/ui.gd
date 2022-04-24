extends CanvasLayer

var next_chapter = null
var next_level = null

onready var node_dialog: Popup = $PopupDialog
onready var node_dialog_panel: Control = $PopupDialog/PanelContainer
onready var node_dialog_header: Label = $PopupDialog/PanelContainer/MarginContainer/VBoxContainer/Header
onready var node_dialog_description: Label = $PopupDialog/PanelContainer/MarginContainer/VBoxContainer/Description
onready var node_dialog_cancel: Control = $PopupDialog/PanelContainer/MarginContainer/VBoxContainer/Actions/Cancel
onready var node_dialog_cancel_button: TextureButton = $PopupDialog/PanelContainer/MarginContainer/VBoxContainer/Actions/Cancel/TextureButton
onready var node_dialog_watch_ad: Control = $PopupDialog/PanelContainer/MarginContainer/VBoxContainer/Actions/WatchAd
onready var node_dialog_watch_ad_button: TextureButton = $PopupDialog/PanelContainer/MarginContainer/VBoxContainer/Actions/WatchAd/TextureButton
onready var node_dialog_confirm: Control = $PopupDialog/PanelContainer/MarginContainer/VBoxContainer/Actions/Confirm
onready var node_dialog_confirm_button: TextureButton = $PopupDialog/PanelContainer/MarginContainer/VBoxContainer/Actions/Confirm/TetureButton

func _ready():
	var center = get_viewport().get_visible_rect().size.x / 2
	$OnLevelComplete/ConfettiLeft.position = Vector2(center - 150, -80)
	$OnLevelComplete/ConfettiRight.position = Vector2(center + 150, -80)
	
	_show_hide_ui()
	
	Themes.connect("theme_changed", self, "_on_theme_changed")
	_on_theme_changed()
	
	Level.connect("level_changed", self, "on_level_changed")
	Storage.connect("storage_changed", self, "on_level_changed")
	on_level_changed()
	
	
	get_tree().get_root().connect("size_changed", self, "_on_resize")

func _on_theme_changed():
	$TopRight/MarginContainer/HBoxContainer/Restart.self_modulate = Themes.theme.on_background
	$TopRight/MarginContainer/HBoxContainer/Skip.self_modulate = Themes.theme.on_background
	$TopRight/MarginContainer/HBoxContainer/Back.self_modulate = Themes.theme.on_background
	node_dialog_cancel_button.self_modulate = Themes.theme.on_background
	node_dialog_watch_ad_button.self_modulate = Themes.theme.on_background
	node_dialog_confirm_button.self_modulate = Themes.theme.on_background
	
func on_level_changed():
	#yield(get_tree(), "idle_frame")
	var prev_levels = 0
	for prev_chapter in range(Level.chapter):
		prev_levels += Data.data[prev_chapter].levels.size()
	$TopLeft/MarginContainer2/VBoxContainer/LevelTitle.text = tr("LEVEL") + " %d" % (prev_levels + Level.level + 1)
	$TopLeft/MarginContainer2/VBoxContainer/ChapterTitle.text = tr("CHAPTER") + " %d" % (Level.chapter + 1)
	
	next_chapter = null
	next_level = null
	
	if Level.level + 1 < Data.data[Level.chapter].levels.size():
		next_chapter = Level.chapter
		next_level = Level.level + 1
	elif Level.chapter + 1 < Data.data.size() and Data.data[Level.chapter + 1].levels.size():
		next_chapter = Level.chapter + 1
		next_level = 0
		
	var skippable_count_tier = Storage.get_skippable_count_tier()
	if skippable_count_tier < Level.chapter:
		Storage.set_skippable_count_tier(Level.chapter)
	
	$OnLevelComplete/MarginContainer/CenterContainer/VBoxContainer/NextLevel.visible = next_chapter or next_level
	$OnLevelComplete/MarginContainer/CenterContainer/VBoxContainer/NextLevel.text = tr("NEXT_CHAPTER") if next_chapter else tr("NEXT_LEVEL")
	$OnLevelComplete/MarginContainer/CenterContainer/VBoxContainer/NoMoreLevels.visible = not next_chapter and not next_level

	var level_data = Data.data[Level.chapter].levels[Level.level]
	var level_completed = Storage.get_level_completed(level_data.id)
	var level_skipped = Storage.get_level_skipped(level_data.id)
	var skip_disabled = level_completed or level_skipped
	$TopRight/MarginContainer/HBoxContainer/Skip.disabled = skip_disabled
	$TopRight/MarginContainer/HBoxContainer/Skip.self_modulate.a = 0.38 if skip_disabled else 1
	
	if Storage.get_editor():
		$UIEditor.visible = true
		$OnLevelComplete.visible = false
	else:
		$UIEditor.visible = false
		$OnLevelComplete.visible = Level.level_ready and Level.level_complete

func _physics_process(delta):
	_show_hide_ui()
	
func _show_hide_ui():
	var line_has_two_points = false
	for line in get_tree().get_nodes_in_group("Line"):
		if line.points.size() >= 2:
			line_has_two_points = true
			break
	
	var restart_disabled = not line_has_two_points
	$TopRight/MarginContainer/HBoxContainer/Restart.disabled = restart_disabled
	$TopRight/MarginContainer/HBoxContainer/Restart.self_modulate.a = 0.38 if restart_disabled else 1

func _on_back():
#	if Level.previous_scene:
#		get_tree().change_scene(Level.previous_scene)
#	else:
#		get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")
	SceneHandler.back()

func _on_next_level(show_ad = true):
	if show_ad:
		AdHelper.show_ad()
	Level.create(next_chapter, next_level)
	Level.initalize()

func _on_redo_level():
	#Level.create(Level.chapter, Level.level)
	Level.initalize()
	
func _on_skip_level():
	node_dialog_watch_ad.visible = Data.is_mobile()
	node_dialog_confirm.visible = not Data.is_mobile()
	node_dialog_description.visible = false
	
	node_dialog_header.text = tr('SKIP_LEVEL_QUESTION')
	
	if not Data.is_mobile():
		var skipped = Storage.get_skipped_level_count()
		var skippable = Storage.get_number_of_skippable_levels()
		
		node_dialog_description.text = tr('%s_OF_%s_LEVELS_SKIPPED') % [skipped, skippable]
		node_dialog_description.visible = true
		
		if skipped >= skippable:
			node_dialog_header.text = tr('MAX_LEVELS_SKIPPED')
			node_dialog_confirm.visible = false
	
	node_dialog.popup_centered(node_dialog_panel.rect_size)

func _on_dialog_cancel():
	node_dialog.hide()

func _on_dialog_watch_ad():
	node_dialog.hide()
	AdHelper.show_ad(true)
	yield(AdHelper.ad_mob, "interstitial_closed")
	_on_successful_skip()

func _on_dialog_confirm():
	node_dialog.hide()
	_on_successful_skip()

func _on_successful_skip():
	Storage.set_level_skipped(Level.level_data.id)
	_on_next_level(false)
	

func _on_resize():
	if node_dialog.visible:
		node_dialog.popup_centered(node_dialog_panel.rect_size)
