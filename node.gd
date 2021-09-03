tool
extends Tile

export(int) var number = 1
export(bool) var is_start = true
export(bool) var is_end = false


func _ready():
	$Label.text = number as String
	$Start.visible = is_start
	$End.visible = is_end
