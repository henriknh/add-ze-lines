extends MarginContainer

onready var node_menu: OptionButton = $VBoxContainer/LanguageContainer/OptionButton
onready var node_add_symbol: CheckButton = $VBoxContainer/AddSymbolContainer/AdditionSymbol
onready var node_editor: CheckButton = $VBoxContainer/Editor

func _ready():
	for idx in Localization.LOCALES.size():
		var locale = Localization.LOCALES.keys()[idx]
		var text = Localization.LOCALES.values()[idx]
		node_menu.add_item(text)
		
		if locale == Storage.get_locale():
			node_menu.select(idx)
	
	node_add_symbol.pressed = Storage.show_addition_symbol
	node_editor.pressed = Storage.editor
	node_editor.visible = OS.is_debug_build()
	
	Themes.connect("theme_changed", self, "_on_theme_changed")
	_on_theme_changed()

func _on_theme_changed():
	node_add_symbol.self_modulate = Themes.theme.on_background
	node_editor.self_modulate = Themes.theme.on_background

func _on_show_addition_symbol_toggled(show_addition_symbol: bool):
	Storage.show_addition_symbol = show_addition_symbol
	
func _on_editor_toggled(editor: bool):
	Storage.editor = editor

func _on_back():
	get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")

func _on_locale(index):
	Storage.set_locale(Localization.LOCALES.keys()[index])
