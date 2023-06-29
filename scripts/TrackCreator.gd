extends Node2D

@export var track_scene: PackedScene
@export var max_angle = 50 
@export var train: Node2D
@export var tangency_level = 0.5
signal tangent_created

var track_origin = Vector2(1, 0)
var past_direction = Vector2(1, 0)

var ghost_track = null 

func transform_track(track, origin, direction, length):
	if rad_to_deg(past_direction.angle_to(direction)) > max_angle: 
		direction = past_direction.rotated(deg_to_rad(max_angle)) 
	elif rad_to_deg(past_direction.angle_to(direction)) < -max_angle:
		direction = past_direction.rotated(deg_to_rad(-max_angle))
	track.global_position = origin + direction * length/2
	track.look_at(origin + direction)
	track.get_node("Sprite2D").region_rect = Rect2(0, 0, length, 16)
	track.get_node("CollisionShape2D").shape.extents = Vector2(length/2, 12)
	track.set_meta("Length", length)
	return direction 

func create_track(direction, length):
	var track = track_scene.instantiate()
	direction = transform_track(track, track_origin, direction, length)
	add_child(track)
	track_origin += direction * length
	past_direction = direction
	return track 	

# Called when the node enters the scene tree for the first time.
func _ready():
	track_origin.x = -get_viewport_rect().size.x/2
	create_track(Vector2(1, 0).normalized(), get_viewport_rect().size.x)
	
	# create ghost track 
	ghost_track = track_scene.instantiate() 
	ghost_track.get_node("Sprite2D").modulate.a = 0.5
	ghost_track.remove_from_group("tracks")
	add_child(ghost_track)
	

func _input(event):
	if event.is_action_pressed("place_track"):
		var dir = get_global_mouse_position() - track_origin
		create_track(dir.normalized(), dir.length())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = get_global_mouse_position() - track_origin
	transform_track(ghost_track, track_origin, dir.normalized(), dir.length())

func _on_tangency_timer_timeout():
	if randf() > tangency_level: 
		return 
	tangent_created.emit()
	var track = create_track(past_direction.rotated(deg_to_rad(randf_range(-max_angle, max_angle))), randf_range(16, 128))
	track.get_node("Sprite2D").modulate.r = 0
