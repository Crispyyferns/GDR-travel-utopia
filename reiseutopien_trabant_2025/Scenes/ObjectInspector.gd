extends Node3D

@onready var camera = $"../../../../Player/CharacterBody3D/Neck/Camera3D"
@onready var ui_button = $"../../../../CanvasLayer/ReturnButton"

var selected_object: Node3D = null
var original_transform: Transform3D
var is_inspecting: bool = false
var inspect_distance: float = 2.0

func _ready():
	ui_button.visible = false
	ui_button.pressed.connect(_on_return_button_pressed) # ✅ Godot 4-style signal connection

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_inspecting:
			var _viewport = get_viewport()
			var from = camera.project_ray_origin(event.position)
			var to = from + camera.project_ray_normal(event.position) * 1000.0

			var space_state = get_world_3d().direct_space_state
			var query = PhysicsRayQueryParameters3D.create(from, to)
			var result = space_state.intersect_ray(query) # ✅ Updated raycast API for Godot 4

			if result and result.has("collider"):
				selected_object = result["collider"]
				original_transform = selected_object.global_transform
				move_object_to_camera(selected_object)
				is_inspecting = true
				ui_button.visible = true

func move_object_to_camera(obj: Node3D) -> void:
	var offset = -camera.global_transform.basis.z * inspect_distance
	var target_position = camera.global_transform.origin + offset
	var new_transform = obj.global_transform
	new_transform.origin = target_position

	# Optional: face the camera
	var look_dir = (camera.global_transform.origin - new_transform.origin).normalized()
	var new_basis = Basis(look_dir).orthonormalized()
	new_transform.basis = new_basis

	obj.global_transform = new_transform

func _on_return_button_pressed() -> void:
	if selected_object:
		selected_object.global_transform = original_transform
		selected_object = null
		is_inspecting = false
		ui_button.visible = false

func _input(event: InputEvent) -> void:
	if is_inspecting and event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var rot = selected_object.rotation_degrees
		rot.y -= event.relative.x * 0.2
		rot.x -= event.relative.y * 0.2
		rot.x = clamp(rot.x, -90, 90) # Optional clamp for realistic rotation
		selected_object.rotation_degrees = rot
