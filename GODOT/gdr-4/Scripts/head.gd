extends Node3D

@onready var main_cam = $"." #Hauptkamera
@onready var ch3d = $".." #Character3D
@onready var raycast = $Camera3D/RayCast3D
@onready var hand = $Hand

@export var raycast_path      : NodePath   # e.g. "RayCast3D"
@export var main_camera_path  : NodePath   # e.g. "MainCam"

var active_cam   : PhantomCamera3D  = null        # currently‑active phantom
var last_hit     : Node      = null

var v = Vector3()
var sens = 0.08

#var held_object: RigidBody3D = null #Object we're holding
var rotating = false

# Called when the node enters the scene tree for the first time.
func _ready():

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	raycast   = get_node(raycast_path)
	main_cam  = get_node(main_camera_path)

func _physics_process(delta: float) -> void:
	_handle_hover()
	_handle_clicks()

func _process(delta):

	main_cam.rotation_degrees.x = v.x
	ch3d.rotation_degrees.y = v.y

	#var object = raycast.get_collider()
	#if raycast.is_colliding():
	#	if object.is_in_group("pickable"):
	#		if Input.is_action_pressed("left_mouse"):
	#			object.global_position = hand.global_position
	#			object.global_rotation = hand.global_rotation
	#			object.collision_layer = 2
	#			object.linear_velocity = Vector3(0.1, 3, 0.1)


func _input(event):

	if event is InputEventMouseMotion:
		v.y -= (event.relative.x * sens)
		v.x -= (event.relative.y * sens)
		v.x = clamp(v.x,-60,70)

func _handle_hover() -> void:
	raycast.force_raycast_update()  # update every physics tick
	var hit : Node = raycast.get_collider()

	# turned off hover on the previous object (if any)
	if hit != last_hit and last_hit and last_hit.has_method("hover_interactable"):
		last_hit.hover_wagon(false)

	# turn on hover on the newly‑hit object
	if hit and hit.has_method("hover_interactable"):
		hit.hover_wagon(true)
		
		last_hit = hit   
		print("Raycast hit: ", raycast.get_collider())
				   # remember for next frame
	
func _handle_clicks() -> void:
	if Input.is_action_just_pressed("mouse_left") and raycast.is_colliding():
		var hit = raycast.get_collider()
		print("Raycast hit:", hit)
		
		if hit.is_in_group("interactables"):
			print("In group! Triggering phantom...")
			_enter_phantom(hit)

		if hit.has_method("activate_phantom_camera"):
			print("Calling activate_phantom_camera() on:", hit)
			_enter_phantom(hit)
		else:
			print("No method on this node. It has methods:", hit.get_method_list())


func _enter_phantom(target: Node) -> void:
	active_cam = target.activate_phantom_camera()  # ask object for its cam
	if active_cam:
		main_cam.current = false

func _exit_phantom() -> void:
	if active_cam and last_hit and last_hit.has_method("return_to_main_camera"):
		last_hit.return_to_main_camera()
		main_cam.current = true
		active_cam = null

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
