#Head
# PlayerController.gd
extends Node3D

@onready var main_camera = $Camera3DPlayer #Hauptkamera #Player Camera
@onready var ch3d = $".." #Character3D
@onready var raycast = $Camera3DPlayer/RayCast3DPlayer
#@onready var hand = $Hand

var v = Vector3()
var sens = 0.05


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):

	if event is InputEventMouseMotion:
		v.y -= (event.relative.x * sens)
		v.x -= (event.relative.y * sens)
		v.x = clamp(v.x,-80,70)
		
func _process(_delta):

	main_camera.rotation_degrees.x = v.x
	ch3d.rotation_degrees.y = v.y

func _unhandled_input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
