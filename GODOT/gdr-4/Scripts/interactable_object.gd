extends StaticBody3D

@export var pcam_host_path: NodePath         # The controller node
@export var phantom_camera_path: NodePath    # The PhantomCamera3D node

var pcam_host: PhantomCameraHost                          # Should be PhantomCameraHost, but plugin may not register type
var phantom_cam: PhantomCamera3D                      # Will be a PhantomCamera3D

var rotating = false
var prev_mouse_position
var next_mouse_position

func _ready():
	pcam_host = get_node_or_null(pcam_host_path)
	phantom_cam = get_node_or_null(phantom_camera_path)

	if not pcam_host:
		push_error("PhantomCameraHost not found — check 'pcam_host_path'")
	if not phantom_cam:
		push_error("PhantomCamera3D not found — check 'phantom_camera_path'")

func hover_object(active: bool) -> void:
	if $Highlight:
		$Highlight.visible = active

func activate_phantom_camera():
	if pcam_host and phantom_cam:
		pcam_host.view(phantom_cam)  # This enters the phantom view

func return_to_main_camera():
	if pcam_host:
		pcam_host.view(null)         # This exits to main/default camera

func _process(delta):
	# Only rotate when in phantom mode
	if rotating:
		rotate_object(delta)

func rotate_object(delta):
	if Input.is_action_just_pressed("mouse_left"):
		rotating = true
		prev_mouse_position = get_viewport().get_mouse_position()

	if Input.is_action_just_released("mouse_left"):
		rotating = false

	if rotating:
		next_mouse_position = get_viewport().get_mouse_position()
		rotate_y((next_mouse_position.x - prev_mouse_position.x) * 0.1 * delta)
		rotate_z(-(next_mouse_position.y - prev_mouse_position.y) * 0.1 * delta)
		prev_mouse_position = next_mouse_position
