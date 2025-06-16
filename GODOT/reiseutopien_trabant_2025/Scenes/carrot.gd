extends StaticBody3D

@onready var food_ingredient_carrot_2: Node3D = $food_ingredient_carrot2
@onready var outlineMesh = $food_ingredient_carrot2/Carrot_0/MeshInstance3D

var selected = false
var outlineWidth = 0.05

func _ready():
	get_tree().get_first_node_in_group("player").interact_object.connect(_set_selected)
	
	outlineMesh.visible = false

func _process(delta):
	outlineMesh.visible = selected
	
	if selected: food_ingredient_carrot_2.position.y = outlineWidth
	else: food_ingredient_carrot_2.position.y = 0

func _set_selected(object):
	selected = self == object
