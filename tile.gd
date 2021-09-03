extends Node2D

class_name Tile

export(Vector2) var coord = Vector2.ZERO

func _ready():
	add_to_group("Tile")
	position = coord * 32
