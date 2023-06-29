extends Control

@export var button: TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_pressed():
	get_tree().paused = false
	button.queue_free()
