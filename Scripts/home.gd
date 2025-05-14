extends Node2D

@onready var world_scene:PackedScene = preload("res://Scenes/world.tscn")


@onready var high_score: Label = $CanvasLayer/HighScore


func  _ready() -> void:
	high_score.text = "HighScore:" + str(SaveLoad.highest_points)
func load_scene(target_scene:PackedScene):
	get_tree().change_scene_to_packed(target_scene)
	

func _on_start_pressed() -> void:
	load_scene(world_scene)
