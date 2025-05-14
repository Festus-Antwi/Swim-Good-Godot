extends Label


func _process(_delta: float) -> void:
	# Update the Label text with the current FPS
	text = "FPS: %d" % Engine.get_frames_per_second()
