extends Control

func _ready():
	$Blur.play("RESET")
	

func resume():
	get_tree().paused = false
	$Blur.play_backwards("blur")
	

func pause():
	get_tree().paused = true
	$Blur.play("blur")
	

func testESC():
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		resume()


func _on_zurück_pressed():
	resume()

func _on_neustart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	$Blur.play_backwards("blur")

func _on_beenden_pressed():
	get_tree().quit()

func _process(delta):
	testESC()
