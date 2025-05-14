extends Node


const save_location = "user://SaveFile.json"
var highest_points = 0


func _ready() -> void:
	load_points()
	
	
func save_points():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_32(highest_points)
	file.close()
	
	
func load_points():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		highest_points = file.get_32()
		file.close()
