extends Node2D

var urchin :RigidBody2D
var urhcin_scene = preload("res://Scenes/urchin.tscn")
@onready var urchins: Node2D = $Urchins

@onready var spawn_timer: Timer = $SpawnTimer
@onready var player_rotator: Node2D = $PlayerRotator
@onready var spawn_point: Marker2D = $SpawnPoint
@onready var fish: Area2D = $PlayerRotator/Fish
@onready var play_bttn: TextureButton = $CanvasLayer/PlayBttn
@onready var switch_bttn: TextureButton = $CanvasLayer/SwitchBttn
@onready var fish_sprite: Sprite2D = $PlayerRotator/Fish/FishSprite
@onready var game_over_lbl: Label = $CanvasLayer/GameOverLbl
@onready var score_lbl: Label = $CanvasLayer/Score
@onready var restart_bttn: TextureButton = $CanvasLayer/RestartBttn
@onready var collision_shape_2d: CollisionShape2D = $PlayerRotator/Fish/CollisionShape2D
@onready var high_score: Label = $CanvasLayer/HighScore
@onready var animation_player: AnimationPlayer = $AnimationPlayer


@export var movement_force: float = 35000.0  
@export var rotate_speed: float = 1
@export var rotate_direction:float = 0
@onready var worms_lbl: Label = $CanvasLayer/worms_lbl
@onready var level_lbl: Label = $CanvasLayer/level_lbl
@onready var worm_spawner: Node2D = $WormSpawner
@onready var dim: ColorRect = $CanvasLayer/Dim
var fish_scale_x:float = 0.6


func _ready() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	


func _process(delta: float) -> void:
	if GameManager.game_running == true and GameManager.game_over == false:
		rotate_player(delta)
		
	worms_lbl.text = ":" + str(GameManager.worms_collected)
	level_lbl.text = "Level:" + str(GameManager.level_number)

	check_level()
	


	
func rotate_player(delta):
	player_rotator.rotation += rotate_speed * rotate_direction * delta



func spawn_urchin(pos:Vector2) -> RigidBody2D:
	var instance = urhcin_scene.instantiate()
	add_child(instance)
	instance.global_position = pos
	instance.reparent(urchins)
	return instance

func shoot_urchin():
	var rotate_angle = randi_range(45, 65)
	if rotate_direction == -1:
		rotate_angle = -rotate_angle;
	else:
		rotate_angle = rotate_angle;
	var player_direction_vector = (fish.global_position - urchin.global_position)
	var offseted_vector = rotate_vector(player_direction_vector.x, player_direction_vector.y, rotate_angle).normalized()
	var force = offseted_vector * movement_force
	urchin.apply_force(force)
	
	
func rotate_vector(x: float, y: float, angle_degrees: float) -> Vector2:
	var angle_radians = (angle_degrees * PI) / 180
	var xNew = x * cos(angle_radians) - y * sin(angle_radians);
	var yNew = x * sin(angle_radians) + y * cos(angle_radians);
	return Vector2(xNew, yNew);

	
	
func _on_spawn_timer_timeout() -> void:
	if GameManager.game_running == true and GameManager.game_over == false:
		urchin = spawn_urchin(spawn_point.global_position)
		shoot_urchin()
	


func _on_boundary_body_entered(body: Node2D) -> void:
	body.queue_free()
	
	

func _on_play_pressed() -> void:
	GameManager.game_over = false
	GameManager.game_running = true
	spawn_timer.start() #start spawning urchins
	rotate_direction = 1 #start rotating player
	play_bttn.visible = false
	switch_bttn.visible = true
	switch_bttn.disabled = false
	collision_shape_2d.set_deferred("disabled", false) #turn on collision
	


func _on_switch_bttn_pressed() -> void:
	if rotate_direction == 0:
		rotate_direction = 1
	else:
		rotate_direction *= -1
		fish_sprite.scale.x *= -1


func  level_up():
	print("leveled up")
	GameManager.leveled_up = false
	switch_bttn.visible = false
	collision_shape_2d.set_deferred("disabled", true)
	player_rotator.rotation = 0
	fish_sprite.scale.x = fish_scale_x
	increase_difficulty()
	worm_spawner.SpawnWorms()
	animation_player.play("fade")
	await animation_player.animation_finished
	play_bttn.visible = true
	
	
func check_level():
	if GameManager.leveled_up == true:
		GameManager.game_running = false
		level_up()
		


func increase_difficulty():
	if movement_force <= 35000:
		movement_force += movement_force * 0.2
	elif movement_force > 50000:
		movement_force = 50000


func _on_fish_body_entered(body: Node2D) -> void:
	if body.is_in_group("Urchins"):
		print("you died")
		GameManager.worms = 0
		switch_bttn.disabled = true
		GameManager.game_over = true
		save_highest_points()
		animation_player.play("spiked")
		await animation_player.animation_finished
		game_over_lbl.visible = true
		score_lbl.visible = true
		high_score.visible = true
		score_lbl.text = "Score:" + str(GameManager.worms_collected)
		high_score.text = "HighScore:" + str(SaveLoad.highest_points)
		dim.visible = true
		restart_bttn.visible = true
		play_bttn.visible = false
		switch_bttn.visible = false
		

func save_highest_points():
	if GameManager.worms_collected > SaveLoad.highest_points:
		SaveLoad.highest_points = GameManager.worms_collected
	SaveLoad.save_points()


	

func reset_game():
	GameManager.worms = 0
	GameManager.worms_collected = 0
	game_over_lbl.visible = false
	score_lbl.visible = false
	high_score.visible = false
	dim.visible = false
	GameManager.level_number = 1
	restart_bttn.visible = false
	play_bttn.visible = true
	player_rotator.rotation = 0
	fish_sprite.scale.x = fish_scale_x
	movement_force = 35000.0
	collision_shape_2d.set_deferred("disabled", true)
	for item in worm_spawner.get_children():
		if item.is_in_group("Worms"):
			item.queue_free()
	worm_spawner.SpawnWorms()
