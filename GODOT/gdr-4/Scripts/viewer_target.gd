#ObjectA
# viewer_target.gd
extends StaticBody3D

@export var local_view_camera: NodePath
@export var object_name: String = "Unnamed Object"
@export var description: String = "No description available."

var camera_ref: Camera3D = null
var hovered = false

func _ready():
	if local_view_camera != NodePath():
		camera_ref = get_node(local_view_camera) as Camera3D
	set_process_input(false)

func view_object(_ignored):
	if camera_ref:
		camera_ref.current = true

func stop_viewing():
	if camera_ref:
		camera_ref.current = false
