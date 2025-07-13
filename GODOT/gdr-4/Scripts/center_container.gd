extends CenterContainer

@export var DOT_RADIUS: float = 3.0
@export var RING_RADIUS: float = 10.0
@export var RING_THICKNESS: float = 2.0
@export var DOT_COLOR: Color = Color.WHITE
@export var RING_COLOR: Color = Color.WHITE
@export var raycast_path: NodePath  # Drag your RayCast3D here

var raycast: RayCast3D
var is_hovering: bool = false

func _ready() -> void:
	if raycast_path != NodePath():
		raycast = get_node(raycast_path)
	queue_redraw()

func _process(_delta: float) -> void:
	if not raycast:
		return

	var was_hovering = is_hovering
	is_hovering = false

	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.is_in_group("interactable"):
			is_hovering = true

	if is_hovering != was_hovering:
		queue_redraw()

func _draw() -> void:
	# Always draw the center dot
	draw_circle(Vector2.ZERO, DOT_RADIUS, DOT_COLOR)

	# If hovering, draw a larger ring around the dot
	if is_hovering:
		draw_arc(Vector2.ZERO, RING_RADIUS, 0, TAU, 64, RING_COLOR, RING_THICKNESS)
