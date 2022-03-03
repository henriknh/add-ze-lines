extends Button

var _theme_solid = preload("res://theme_solid.tres")

onready var node_title = $VBox/Title
onready var node_purchase = $VBox/Purchase
onready var node_gem_icon = $VBox/Purchase/GemIcon
onready var node_price = $VBox/Purchase/Price
onready var node_selection_border = $SelectionBorder

var theme_button
var theme_index = 0

func _ready():
	Storage.connect("storage_changed", self, "_update_ui")

func _update_ui():
	theme = Themes.update_theme_solid(_theme_solid.duplicate(true), theme_button, true)
	node_title.theme = Themes.update_theme_solid(_theme_solid.duplicate(true), theme_button, false)
	node_price.theme = Themes.update_theme_solid(_theme_solid.duplicate(true), theme_button, false)
	
	
	print(Storage.get_unlocked_themes())
	var unlocked = theme_button.index == 0 or theme_index in Storage.get_unlocked_themes()
	
	node_title.text = theme_button.title as String
	node_price.text = theme_button.price as String
	node_purchase.visible = not unlocked
	node_selection_border.visible = theme_index == Storage.get_theme()
	
	node_gem_icon.self_modulate = theme_button.on_background

	modulate.a = 0.38 if not unlocked and Storage.get_gems() < theme_button.price else 1

func _on_click():
	if node_purchase.visible:
		Storage.unlock_theme(theme_index)
		Storage.set_gems(Storage.get_gems() - theme_button.price)
		Storage.set_theme(theme_index)
	else:
		Storage.set_theme(theme_index)
		_update_ui()
