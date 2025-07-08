#SceneManager
extends Node

var current_scene: Node = null

func load_scene(scene_path: String) -> void:
	if current_scene:
		current_scene.queue_free()
	call_deferred("_load_scene", scene_path)

func _load_scene(scene_path: String) -> void:
	var new_scene = load(scene_path).instantiate()
	add_child(new_scene)
	current_scene = new_scene
