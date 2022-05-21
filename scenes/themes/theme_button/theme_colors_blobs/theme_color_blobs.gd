extends HBoxContainer

var theme_colors

func _update_ui():
	$ColorRect.color = theme_colors.colors[1].background
	$ColorRect2.color = theme_colors.colors[2].background
	$ColorRect3.color = theme_colors.colors[3].background
	$ColorRect4.color = theme_colors.colors[4].background
	$ColorRect5.color = theme_colors.colors[5].background
