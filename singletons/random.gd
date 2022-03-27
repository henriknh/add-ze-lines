extends Node

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	
func randf() -> float:
	return rng.randf()

func randi() -> int:
	return rng.randi()
