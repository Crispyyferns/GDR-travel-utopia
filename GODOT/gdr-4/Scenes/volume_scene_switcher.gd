# res://VolumeSceneSwitcher.gd
extends Node

@export var object_viewer_path : NodePath
@onready var object_viewer = get_node(object_viewer_path)

func _unhandled_input(event: InputEvent) -> void:
	if object_viewer == null: return
	var target = object_viewer.last_target if "last_target" in object_viewer else null
	if target == null or not target.is_in_group("radio_focus"): return

	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("mouse_wheel_up"):
			TransitionManager_to80s.play_transition_and_switch("res://Scenes/Scene-2_80s.tscn")
		elif Input.is_action_just_pressed("mouse_wheel_down"):
			TransitionManager_to80s.play_transition_and_switch("res://Scenes/Scene-1_70s.tscn")
