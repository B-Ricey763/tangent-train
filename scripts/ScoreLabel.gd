extends Label

@export var train: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(train):
		text = "Score: " + str(floor(train.global_position.x/10))
	
