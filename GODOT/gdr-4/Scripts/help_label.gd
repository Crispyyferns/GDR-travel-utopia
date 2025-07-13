extends Node

@export var help_label_path: NodePath        # Assign the Label node in the Inspector
@export var fade_duration := 1.0             # seconds to fade in/out
@export var visible_time  := 5.0             # seconds label stays fully visible
@export var interval_time := 15.0            # seconds between reappearances

@onready var help_label: Label = get_node(help_label_path)
var tween: Tween
var tip_index := 0

var tips := [
	"Klick mit der linken Maustaste auf Objekte über denen ein gelber Kreis erscheint um sie näher zu betrachten.",
	"Rechtsklick um die nahe Ansicht zu verlassen.",
	"Klicke auf das Radio um in die 80er oder zurück in die 70er Jahre zu reisen. Dafür dann mit dem Mausrad vor- oder zurückscrollen.",
	"Drücke ESC auf der Tastatur um die Anwendung zu pausieren."
]

func _ready():
	help_label.visible = true
	help_label.modulate.a = 0.0
	help_label.text = tips[tip_index]
	_start_help_cycle()

func _update_help_text():
	tip_index = (tip_index + 1) % tips.size()
	help_label.text = tips[tip_index]

func _start_help_cycle():
	tween = create_tween()
	
	# Initial fade-in
	tween.tween_property(help_label, "modulate:a", 1.0, fade_duration)
	tween.tween_interval(visible_time)
	tween.tween_property(help_label, "modulate:a", 0.0, fade_duration)
	tween.tween_interval(interval_time)

	# Loop from second appearance onward
	tween.set_loops()
	tween.tween_callback(Callable(self, "_update_help_text"))
	tween.tween_property(help_label, "modulate:a", 1.0, fade_duration)
	tween.tween_interval(visible_time)
	tween.tween_property(help_label, "modulate:a", 0.0, fade_duration)
	tween.tween_interval(interval_time)
