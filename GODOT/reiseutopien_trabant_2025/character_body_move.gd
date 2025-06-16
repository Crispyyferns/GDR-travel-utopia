extends CharacterBody3D

signal interact_object

const SPEED = 3
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var ray_cast_3d = $Neck/Camera3D/RayCast3D

func _ready():
	add_to_group("player")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta):
	if ray_cast_3d.is_colliding():
		var collider = ray_cast_3d.get_collider()
		interact_object.emit(collider)
	else: interact_object.emit(null)
	
# 
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	# if Mouse is not captured (ESC not pressed), Mouse coordinates Neck movements
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.005)
			camera.rotate_x(-event.relative.y * 0.005)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-50), deg_to_rad(15))
			neck.rotation.y = clamp(neck.rotation.y, deg_to_rad(-50), deg_to_rad(60))


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()
