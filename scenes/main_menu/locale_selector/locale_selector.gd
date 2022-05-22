extends MenuButton

func _ready():
	Themes.connect("theme_changed", self, "_on_theme_changed")
	_on_theme_changed()
	
	Storage.connect("storage_changed", self, "_on_storage_changed")
	_on_storage_changed()
	
	for locale in TranslationServer.get_loaded_locales():
		get_popup().add_item(locale)
	get_popup().connect("id_pressed", self, "_on_index_pressed")

func _on_theme_changed():
	self_modulate = Themes.theme.on_background
	
func _on_storage_changed():
	text = Storage.get_locale().to_upper()

func _on_index_pressed(index: int):
	Storage.set_locale(TranslationServer.get_loaded_locales()[index])
