extends MeshInstance3D

var rotating = false

var prev_mouse_position
var next_mouse_position


func rotateObject_inCameraLock():
	pass
	# if raycast collides with mesh3d collider:
	# pCam_3D_17 becomes active
	# pcam.get_camera_3d_resource()?? switch to this camera until the right mouse button is pressed
	# then reset to main camera (attached to Player)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("mouse_left")):
		rotating = true
		prev_mouse_position = get_viewport().get_mouse_position()
	if (Input.is_action_just_released("mouse_left")):
		rotating = false
		
	if (rotating):
		next_mouse_position = get_viewport().get_mouse_position()
		rotate_y((next_mouse_position.x - prev_mouse_position.x) * .1 * delta)
		rotate_z(-(next_mouse_position.y - prev_mouse_position.y) * .1 * delta)
		prev_mouse_position = next_mouse_position
