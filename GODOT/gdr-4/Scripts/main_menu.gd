extends Control

var scene1 = preload("res://Scenes/Scene-1_70s.tscn")

func _on_play_pressed():
	TransitionManager_Empty.play_transition_and_switch("res://Scenes/Scene-1_70s.tscn")
