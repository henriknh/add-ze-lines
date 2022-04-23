extends Node

const LOCALES = {
	"en": "english",
	"sv": "svenska"
}
var current_locale = null

func _ready():
	set_storage_locale(false)
	Storage.connect("storage_changed", self, "set_storage_locale")
	
func set_storage_locale(reload = true):
	var new_locale = Storage.get_locale()
	TranslationServer.set_locale(new_locale)
	if reload and new_locale != current_locale:
		get_tree().reload_current_scene()
	current_locale = new_locale
