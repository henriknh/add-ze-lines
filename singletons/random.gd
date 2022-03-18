extends Node

var rng = RandomNumberGenerator.new()

func randf() -> float:
	return rng.randf()

func randi() -> int:
	return rng.randi()
