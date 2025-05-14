extends Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_area_entered(_area: Area2D) -> void:
	GameManager.add_worm()
	animation_player.play("pickup")
	await  animation_player.animation_finished
	queue_free()
