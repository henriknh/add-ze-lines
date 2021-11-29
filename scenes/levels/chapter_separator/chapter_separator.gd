extends Control


func _ready():
	$CenterContainer/HBoxContainer/ColorRect.color = Themes.theme.on_background
	$CenterContainer/HBoxContainer/ColorRect2.color = Themes.theme.on_background
	$CenterContainer/HBoxContainer/ColorRect3.color = Themes.theme.on_background
