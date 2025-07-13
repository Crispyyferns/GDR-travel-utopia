extends StaticBody3D

var is_open: bool = false
var open_distance: float = -0.3
var closed_position: Vector3
var open_position: Vector3
var moving: bool = false

func _ready() -> void:
	closed_position = global_transform.origin

	# Move outward along the local -Z axis (drawer "outward" direction)
	var local_offset = -transform.basis.z.normalized() * open_distance
	open_position = closed_position + local_offset

func toggle_drawer() -> void:
	if moving:
		return

	moving = true
	var target_position: Vector3 = open_position if not is_open else closed_position

	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, 0.5) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(Callable(self, "_on_drawer_moved"))
	is_open = not is_open

func _on_drawer_moved() -> void:
	moving = false
