extends Node
#
#  TransitionManager – global singleton
#  Smooth radio‑static fade‑in → loading pause → scene switch → fade‑out
#-------------------------------------------------------------

const TRANSITION_LAYER_SCENE_to80s := preload("res://Scenes/transition_layer_to80s.tscn")

@export var transition_duration : float = 1.0   # fade‑in / fade‑out seconds
@export var loading_duration    : float = 5.0   # “loading” hold
@export var max_intensity       : float = 0.15  # shader noise strength

# internal refs
var layer          : CanvasLayer
var noise_overlay  : ColorRect
var static_player  : AudioStreamPlayer3D
var loading_label  : Label
var switching      : bool = false
var time_passed    : float = 0.0

# -------------------------------------------------------------
func _ready() -> void:
	# Instance the visual layer once and keep it alive
	layer = TRANSITION_LAYER_SCENE_to80s.instantiate()
	get_tree().root.add_child.call_deferred(layer)

	# Get references *after* instancing
	noise_overlay  = layer.get_node("NoiseOverlay")
	static_player  = layer.get_node("StaticPlayer")
	loading_label  = layer.get_node("LoadingLabel")

	# Initial visual/audio setup
	layer.visible            = false
	loading_label.visible    = false
	static_player.volume_db  = -80.0
	noise_overlay.material.set_shader_parameter("intensity", 0.0)
	noise_overlay.z_index = 999

var elapsed_time : float = 0.0

func _process(delta: float) -> void:
	elapsed_time += delta
	if noise_overlay:
		var shader_mat = noise_overlay.material
		if shader_mat:
			shader_mat.set_shader_parameter("time", elapsed_time)




	

# -------------------------------------------------------------
#  Public: call from anywhere  →  TransitionManager.play_transition_and_switch(scene)
# -------------------------------------------------------------
func play_transition_and_switch(scene_path: String) -> void:
	if switching: return
	switching = true
	time_passed = 0.0

	# Show transition layer and noise overlay
	layer.visible = true
	noise_overlay.visible = true
	loading_label.visible = true
	loading_label.modulate.a = 0.0
	static_player.volume_db = -80.0
	static_player.play()

	# FADE‑IN --------------------------------------------------
	var tw = create_tween()
	tw.parallel().tween_property(noise_overlay.material, "shader_parameter/intensity",
								 max_intensity, transition_duration)
	tw.parallel().tween_property(static_player, "volume_db",
								 0.0,            transition_duration)
	tw.parallel().tween_property(loading_label, "modulate:a",
								 1.0,            transition_duration)
	await tw.finished

	# HOLD ----------------------------------------------------
	await get_tree().create_timer(loading_duration).timeout

	# SWITCH --------------------------------------------------
	get_tree().change_scene_to_file(scene_path)
	await get_tree().process_frame

	# Make sure the transition layer stays on top after scene switch
	get_tree().root.call_deferred("move_child", layer, get_tree().root.get_child_count() - 1)
	layer.visible = true
	noise_overlay.visible = true

	# FADE‑OUT ------------------------------------------------
	tw = create_tween()
	tw.parallel().tween_property(noise_overlay.material, "shader_parameter/intensity",
								 0.0,           transition_duration)
	tw.parallel().tween_property(static_player, "volume_db",
								 -80.0,         transition_duration)
	tw.parallel().tween_property(loading_label, "modulate:a",
								 0.0,           transition_duration)
	await tw.finished

	# Hide everything after fade-out
	layer.visible = false
	noise_overlay.visible = false
	loading_label.visible = false
	static_player.stop()
	switching = false
