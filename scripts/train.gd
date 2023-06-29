extends CharacterBody2D

@export var speed = 0;
var start_speed = 0

var detected_track = null 

var direction = Vector2(1, 0)
func _physics_process(_delta):
	velocity = direction * speed
	look_at(position + direction)
	move_and_slide()


func _on_track_detector_body_entered(body):
	if body.is_in_group("tracks"):
		detected_track = body 

func _ready():
	start_speed = speed

func _process(delta):
	speed = start_speed * (1 + position.x/10000)
	
	if detected_track != null and abs(detected_track.to_local(position).y) < 1:
		direction = -detected_track.transform.x
		detected_track = null 


func _on_hitter_body_entered(body):
	if body.is_in_group("obstacles"):
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
