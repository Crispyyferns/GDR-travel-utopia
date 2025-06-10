extends MeshInstance3D

@onready var Lamp = $Lamp_stand_Placeholder
@onready var outlineMesh = $MeshInstance3D

var selected = false
var outlineWidth = 0.05

func _ready():
	get_tree().get_first_node_in_group("player").interact_object.connect(_set_selected)
	
	outlineMesh.visible = false

func _process(delta):
	outlineMesh.visible = selected
	
	if selected: Lamp.position.y = outlineWidth
	else: Lamp.position.y = 0
	
func _set_selected(object):
	selected = self == object
