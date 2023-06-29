extends TextureRect


func fade_in():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1)

	



func _on_track_creator_tangent_created():
	fade_in()
