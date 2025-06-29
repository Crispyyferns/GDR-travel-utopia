extends Node3D

@onready var transition = $Transition
# Called when the node enters the scene tree for the first time.
func _ready():
	transition.play("fade_in")
