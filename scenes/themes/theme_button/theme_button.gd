extends Control

var _theme_solid = preload("res://theme_solid.tres")

enum STATE { BROWSE, PURCHASE, CONFIRM }
var state: int = STATE.BROWSE 

onready var node_background = $ColorRect
onready var node_container = $MarginContainer
onready var node_browse = $MarginContainer/Browse
onready var node_browse_title = $MarginContainer/Browse/VBox/Title
onready var node_purchase = $MarginContainer/Purchase
onready var node_purchase_title = $MarginContainer/Purchase/VBox/Title
onready var node_purchase_gem_icon = $MarginContainer/Purchase/VBox/Purchase/GemIcon
onready var node_purchase_price = $MarginContainer/Purchase/VBox/Purchase/Price
onready var node_confirm = $MarginContainer/Confirm
onready var node_confirm_gem_icon = $MarginContainer/Confirm/CenterContainer/Cost/GemIcon
onready var node_confirm_cost = $MarginContainer/Confirm/CenterContainer/Cost/Price
onready var node_confirm_cancel = $MarginContainer/Confirm/CenterContainer2/HBoxContainer/Cancel
onready var node_confirm_proceed = $MarginContainer/Confirm/CenterContainer2/HBoxContainer/Proceed
onready var node_selection_border = $SelectionBorder

var theme_button
var theme_index = 0

func _ready():
	Storage.connect("storage_changed", self, "_update_ui")
	Themes.connect("theme_purchase_initiated", self, "_reset_state")
	_reset_state()

func _reset_state():
	var unlocked = theme_button.index == 0 or theme_index in Storage.get_unlocked_themes()
	state = STATE.BROWSE if unlocked else STATE.PURCHASE
	_update_ui()

func _update_ui():
	#theme = Themes.update_theme_solid(_theme_solid.duplicate(true), theme_button, true)
	#node_browse_title.theme = Themes.update_theme_solid(_theme_solid.duplicate(true), theme_button, false)
	#node_purchase_title.theme = Themes.update_theme_solid(_theme_solid.duplicate(true), theme_button, false)
	#node_purchase_price.theme = Themes.update_theme_solid(_theme_solid.duplicate(true), theme_button, false)
	#node_confirm_cost.theme = Themes.update_theme_solid(_theme_solid.duplicate(true), theme_button, false)
	node_browse_title.add_color_override("font_color", theme_button.on_background)
	node_purchase_title.add_color_override("font_color", theme_button.on_background)
	node_purchase_price.add_color_override("font_color", theme_button.on_background)
	node_confirm_cost.add_color_override("font_color", theme_button.on_background)
	
	node_browse.visible = state == STATE.BROWSE
	node_purchase.visible = state == STATE.PURCHASE
	node_confirm.visible = state == STATE.CONFIRM
	node_selection_border.visible = theme_index == Storage.get_theme()
	
	node_browse_title.text = theme_button.title as String
	node_purchase_title.text = theme_button.title as String
	node_purchase_price.text = theme_button.price as String
	node_confirm_cost.text = "-%s" % theme_button.price
	
	node_purchase_gem_icon.self_modulate = theme_button.on_background
	node_confirm_gem_icon.self_modulate = theme_button.on_background
	node_confirm_cancel.self_modulate = theme_button.on_background
	node_confirm_proceed.self_modulate = theme_button.on_background

	node_background.color = theme_button.background

	node_container.modulate.a = 0.38 if state != STATE.BROWSE and Storage.get_gems() < theme_button.price else 1
	
func _on_purchase():
	if Storage.get_gems() < theme_button.price:
		return
	Themes.emit_signal("theme_purchase_initiated")
	state = STATE.CONFIRM
	_update_ui()

func _on_confirm_buy():
	if Storage.get_gems() < theme_button.price:
		return
	Storage.unlock_theme(theme_index)
	Storage.set_gems(Storage.get_gems() - theme_button.price)
	Storage.set_theme(theme_index)
	_reset_state()

func _on_select():
	Storage.set_theme(theme_index)
	_update_ui()
	
