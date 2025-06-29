extends Control

@onready var color_rect = $ColorRect
@onready var transition = $Transition
var scene1 = preload("res://Scenes/Scene-1_70s.tscn")

func _on_play_pressed():
	transition.play("fade_out")
	await transition.animation_finished
	get_tree().change_scene_to_packed(scene1)
	transition.play_backwards("fade_out")
	
func reload_scene():
	transition.play("fade_out")
	await transition.animation_finished
	get_tree().reload_current_scene()
	transition.play_backwards("fade_out")
