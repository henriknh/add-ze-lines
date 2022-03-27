class_name ParallaxLine
extends Line2D

const OFFSET = 2
const SPEED_BASE = 10
const SPEED_VARIYING = 30

enum STATES { SPAWN, HEAD, TAIL }

var state: int = STATES.SPAWN
var origin: Vector2 = Vector2()
var direction: Vector2 = Vector2()
var speed: float = 0
var color = Color.red setget set_color
var viewport_size = Vector2()

func _ready():
	points = []
	z_index = -100
	default_color = color
	self_modulate = Color(1,1,1,0.2)
	
	get_tree().get_root().connect("size_changed", self, "_on_resize")
	_on_resize()

func _on_resize():
	viewport_size = get_viewport().get_visible_rect().size
	state = STATES.SPAWN

func set_color(color):
	default_color = color

func _physics_process(delta):
	match state:
		STATES.SPAWN:
			origin = get_origin()
			direction = get_direction()
			speed = SPEED_BASE + SPEED_VARIYING * Random.randf()
			
			points = [
				origin,
				origin
			]
			
			state = STATES.HEAD
		
		STATES.HEAD:
			if outside_viewport(points[0]):
				state = STATES.TAIL
			points[0] += direction * speed * delta
		STATES.TAIL:
			if outside_viewport(points[1]):
				state = STATES.SPAWN
			points[1] += direction * speed * delta


func outside_viewport(point: Vector2) -> bool:
	if point.x < -OFFSET \
		or point.y < -OFFSET \
		or point.x > viewport_size.x + OFFSET \
		or point.y > viewport_size.y + OFFSET:
		return true
	return false
	
func get_origin() -> Vector2:
	var center = viewport_size / 2
	var origin_helper = Vector2(10000,10000).rotated(Random.randf() * 2.0 * PI) + center
	
	var viewport_segments = [
		[Vector2.ONE * -OFFSET, Vector2(-OFFSET, viewport_size.y + OFFSET)],
		[Vector2(-OFFSET, viewport_size.y + OFFSET), Vector2(viewport_size.x + OFFSET, viewport_size.y + OFFSET)],
		[Vector2(viewport_size.x + OFFSET, viewport_size.y + OFFSET), Vector2(viewport_size.x + OFFSET, -OFFSET)],
		[Vector2(viewport_size.x + OFFSET, -OFFSET), Vector2.ONE * -OFFSET],
	]
	
	for viewport_segment in viewport_segments:
		var intersection = Geometry.segment_intersects_segment_2d(
			center, 
			origin_helper, 
			viewport_segment[0], 
			viewport_segment[1]
		)
		
		if intersection:
			return intersection
	
	breakpoint
	return Vector2.ONE * -OFFSET

func get_direction() -> Vector2:
	var towards_center = origin.direction_to(viewport_size / 2).normalized()
	if abs(towards_center.x) < abs(towards_center.y):
		return Vector2(
			-1 if Random.randi() % 2 == 0 else 1,
			round(towards_center.y)
		)
	else:
		return Vector2(
			round(towards_center.x),
			-1 if Random.randi() % 2 == 0 else 1
		)
