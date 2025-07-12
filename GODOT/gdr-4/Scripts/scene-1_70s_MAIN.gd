#Main
extends Node3D

@export var main_camera: Camera3D
@export var raycast: RayCast3D
@export var ui: CanvasLayer          # drag your UI CanvasLayer here

#@onready var transition = $Transition
# Called when the node enters the scene tree for the first time.

# ───────────────────────────────
# runtime state
# ───────────────────────────────
var last_target          : StaticBody3D = null
var tween                : Tween        = null
var target_cam_callback  : Camera3D     = null
var original_cam_xform   : Transform3D

# mouse‑drag rotation
var rotating             : bool         = false
var prev_mouse_pos       : Vector2      = Vector2.ZERO

# tweakables
var drag_sensitivity     := 0.5   # larger → spins faster
var zoom_amount          := 1.1   # each click of Zoom button


# ───────────────────────────────
func _ready() -> void:
	
	#var time_controller = $VolumeTimeController
	#time_controller.time_changed.connect(_on_time_changed)
	
	original_cam_xform = main_camera.global_transform
	raycast.enabled    = true
	ui = get_node("Complete UIs/Info_UI")



# ───────────────────────────────
# INPUT – rotate selected object with LMB drag
# ───────────────────────────────
func _unhandled_input(event: InputEvent) -> void:
	if last_target == null:
		return                  # nothing selected to rotate

	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if event.pressed:
				#rotating = true
				#prev_mouse_pos = event.position
			#else:
				#rotating = false
#
	#elif event is InputEventMouseMotion and rotating:
		#var delta: Vector2 = event.position - prev_mouse_pos
		#prev_mouse_pos  = event.position
		## Horizontal drag → Y‑axis spin, Vertical drag → X‑axis tilt
		#last_target.rotate_y(deg_to_rad(-delta.x * drag_sensitivity))
		#last_target.rotate_x(deg_to_rad(-delta.y * drag_sensitivity))


# ───────────────────────────────
func _physics_process(_delta: float) -> void:
	# Right‑click anywhere to exit viewer
	if Input.is_action_just_pressed("mouse_right_click"):
		_reset_camera()
		return

	# while inspecting (not on main camera) ignore clicks for selection
	if not main_camera.current:
		return

	# pick object with left click
	if raycast.is_colliding():
		if Input.is_action_just_pressed("mouse_left_click"):
			var obj := raycast.get_collider()
			if obj and obj.has_method("view_object"):
				_select_object(obj)


#func _on_time_changed(time_blend: float) -> void:
	## Example: change environment based on blend
	#$SetDesign.material_override.albedo_color = Color(1, 1, 1).lerp(Color(0.2, 0.1, 0.05), time_blend)
#
	#if time_blend > 0.8 and not has_node("FutureProp"):
		#var future_prop = preload("res://props/future_computer.tscn").instantiate()
		#future_prop.name = "FutureProp"
		#add_child(future_prop)
#
	#if time_blend < 0.3 and has_node("FutureProp"):
		#get_node("FutureProp").queue_free()




# ───────────────────────────────
# Selection / camera tween logic
# ───────────────────────────────
func _select_object(obj: StaticBody3D) -> void:
	if last_target && last_target.has_method("stop_viewing"):
		last_target.stop_viewing()

	# grab that object's viewer camera
	var target_cam: Camera3D = null
	if "local_view_camera" in obj and obj.local_view_camera != NodePath():
		target_cam = obj.get_node(obj.local_view_camera) as Camera3D

	if target_cam == null:
		print("⚠️  Object lacks local_view_camera")
		return

	# tween main cam to the target view
	_start_tween_to(target_cam)
	last_target = obj
	ui.show_info(obj.object_name, obj.description)

func _start_tween_to(target_cam: Camera3D) -> void:
	if tween: tween.kill()
	tween = create_tween()

	tween.tween_property(
		main_camera, "global_transform",
		target_cam.global_transform,
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# We no longer need to change cameras
	tween.tween_callback(Callable(self, "_on_tween_complete"))


func _on_tween_complete() -> void:
	# just confirm camera remains active and aligned
	main_camera.current = true

# ───────────────────────────────
# Reset to main view
# ───────────────────────────────
func _reset_camera() -> void:
	if tween: tween.kill()
	tween = create_tween()

	tween.tween_property(
		main_camera, "global_transform",
		original_cam_xform,
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_callback(Callable(self, "_on_reset_complete"))

func _on_reset_complete() -> void:
	main_camera.current = true
	main_camera.global_transform = original_cam_xform
	if last_target && last_target.has_method("stop_viewing"):
		last_target.stop_viewing()
	last_target = null
	ui.hide_info()
	rotating = false


# ───────────────────────────────
# UI button callbacks
# ───────────────────────────────
func _on_zoom_pressed() -> void:
	if not last_target: return
	var dir := main_camera.global_transform.basis.z.normalized()
	main_camera.global_transform.origin += dir * zoom_amount
