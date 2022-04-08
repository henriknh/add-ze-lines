extends Node

const LOCALES = {
	"en": "english",
	"sv": "svenska"
}
var current_locale = null

func _ready():
	
	Storage.set_locale(OS.get_locale_language())
	Storage.set_locale('en')
	
	set_storage_locale()
	Storage.connect("storage_changed", self, "set_storage_locale")
	
func set_storage_locale():
	var new_locale = Storage.get_locale()
	TranslationServer.set_locale(new_locale)
	if new_locale != current_locale:
		get_tree().reload_current_scene()
		current_locale = new_locale
