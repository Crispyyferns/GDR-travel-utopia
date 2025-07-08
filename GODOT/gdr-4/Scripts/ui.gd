extends CanvasLayer

@export var name_label       : Label
@export var description_label: Label
@export var zoom_button      : Button
@export var close_button     : Button

signal zoom_pressed
signal close_pressed

func _ready() -> void:
	visible = false
	zoom_button.pressed .connect(Callable(self, "_on_zoom"))
	close_button.pressed.connect(Callable(self, "_on_close"))

func _on_zoom()  -> void: emit_signal("zoom_pressed")
func _on_close() -> void: emit_signal("close_pressed")

func show_info(obj_name: String, desc: String) -> void:
	name_label.text        = obj_name
	description_label.text = desc
	visible = true

func hide_info() -> void:
	visible = false


func _on_rotate_button_pressed():
	pass # Replace with function body.


func _on_zoom_button_pressed():
	pass # Replace with function body.


func _on_close_button_pressed():
	pass # Replace with function body.
