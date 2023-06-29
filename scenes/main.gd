extends Node2D

@export var mountain_scene: PackedScene
@export var lake_scene: PackedScene
@export var obstacle_timer: Timer
@export var obstacle_spawn: Node2D
@export var death_screen: PackedScene
@export var train: Node2D
@export var hs_label: Label

var global_hs = 0

func get_rand_y():
	var size_y = get_viewport_rect().size.y
	return randf_range(-size_y/2, size_y/2)

func spawn_mountain_range(x):
	var spawn_y = get_rand_y()
	var seperation = randf_range(30, 100)
	var x_dir = randf_range(-1, 1)
	var y_dir = randf_range(-1, 1)
	for i in range(randi_range(2, 5)):
		var moutain = mountain_scene.instantiate()
		moutain.global_position = Vector2(x + i * seperation * x_dir, spawn_y + i * seperation * y_dir)
		add_child(moutain)
		
func spawn_lake(x, y):
	for i in range(3):
		var lake = lake_scene.instantiate()
		lake.global_position = Vector2(x + randf_range(-100, 100),y + randf_range(-100, 100))
		add_child(lake)


func _on_obstacle_timer_timeout():
	spawn_mountain_range(obstacle_spawn.global_position.x + get_viewport_rect().size.x + 100)
	spawn_lake(obstacle_spawn.global_position.x + get_viewport_rect().size.x + 100, get_rand_y())
	obstacle_timer.wait_time = randi_range(2, 5)
	
	
func save_game(score):
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	if score > global_hs:
		save_file.store_line(str(score))
		global_hs = score
		hs_label.text = "Highscore: " + str(global_hs)
	else:
		save_file.store_line(str(global_hs))
	save_file.flush()
	
	
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
		
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json_string = save_file.get_line()
	global_hs = float(json_string)
	hs_label.text = "Highscore: " + str(global_hs)
	save_file.flush()

func _ready():
	load_game()

func _on_train_tree_exiting():
	save_game(floor(train.global_position.x/10))
	$CanvasLayer.add_child(death_screen.instantiate())

