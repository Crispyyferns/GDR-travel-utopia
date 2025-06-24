extends Node3D


# Called when the node enters the scene tree for the first time.
func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		get_tree().change_scene_to_file("res://Scene-2_80s.tscn")
		
