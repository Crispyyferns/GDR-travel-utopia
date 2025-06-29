extends Control

@onready var scene1 = preload("res://Scenes/Scene-1_70s.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	

func testESC():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	testESC()

func _on_resume_pressed():
	resume()

func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()
