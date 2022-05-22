extends TextureButton

func _ready():
	pressed = Storage.has_sound()
	
	Themes.connect("theme_changed", self, "_on_theme_changed")
	_on_theme_changed()

func _on_toggle(is_toggled: bool):
	Storage.set_has_sound(is_toggled)

func _on_theme_changed():
	self_modulate = Themes.theme.on_background
