class_name ParallaxLine
extends Line2D

enum STATES { SPAWN, HEAD, TAIL }

var state: int = STATES.SPAWN
var direction: int = 0
var color = Color.red setget set_color

func _init():
	print('init parallax line')

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	print('ready parallax line')
	points = [
		Vector2.ZERO,
		Vector2.ONE * 100
	]
	z_index = -100
	default_color = color

func set_color(color):
	prints('on theme changed', color)
	default_color = color

func _physics_process(delta):
	match state:
		STATES.SPAWN:
			var direction = Random.randi() % 2 == 0
			var short_side = Random.randi() % 2 == 0
			prints(direction, short_side)
			pass
			
			state = STATES.HEAD
		
		STATES.HEAD:
			pass
		
		STATES.TAIL:
			pass
