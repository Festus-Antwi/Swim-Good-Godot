extends Node2D

var worm_scene = preload("res://Scenes/worrm.tscn")
@export var number_of_worms:int = 30
@export var radius: int = 450
@onready var origin: Marker2D = $origin
@onready var worm_spawner: Node2D = $"."

func _ready() -> void:
	SpawnWorms()


func SpawnWorms():
	var angle_increament = 360 / number_of_worms
	var origin_pos = origin.global_position
	for i in range(number_of_worms):
		var angle = deg_to_rad((i * angle_increament))
		var x = origin_pos.x + radius * cos(angle)
		var y = origin_pos.y + radius * sin(angle)
		var worm_pos = Vector2(x,y)
		var instance = worm_scene.instantiate()
		add_child(instance)
		instance.global_position = worm_pos
		instance.rotation += angle
		instance.reparent(worm_spawner)
		await get_tree().create_timer(0.01).timeout
		
