extends Camera2D

@export var train: Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(train):
		position.x = train.position.x
