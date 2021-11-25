extends Control

var loaded = false;

func _ready():
	$PanelContainer/HBoxContainer/CoordXSpinBox.value = Level.level_data.grid_size[0]
	$PanelContainer/HBoxContainer/CoordYSpinBox.value = Level.level_data.grid_size[1]
	loaded = true

func _on_changed(_v):
	if not loaded:
		return
	
	Level.level_data.grid_size = [
		$PanelContainer/HBoxContainer/CoordXSpinBox.value,
		$PanelContainer/HBoxContainer/CoordYSpinBox.value
	]
	Data.save_data()
	
	Level.init(Level.chapter, Level.level)
