extends ColorRect

@onready var shader_material := self.material as ShaderMaterial

func _ready():
	visible = false
	
func _process(_delta):
	shader_material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)
	material.set_shader_parameter("opacity", 0.5)  # For 50% visibility

func play_transition():
	visible = true
	modulate.a = 0.0  # Start transparent

	var fade_in = create_tween()
	fade_in.tween_property(self, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	fade_in.tween_interval(0.3)  # Hold the full noise briefly

	fade_in.tween_property(self, "modulate:a", 0.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	fade_in.tween_callback(Callable(self, "_on_transition_finished"))

func _on_transition_finished():
	visible = false
