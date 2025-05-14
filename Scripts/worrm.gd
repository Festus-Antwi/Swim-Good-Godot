extends Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var collected: bool = false

func _on_area_entered(area: Area2D) -> void:
	if collected:
		return
	if area.has_method("fish"):
		collected = true
		GameManager.add_worm()
		animation_player.play("pickup")
		await  animation_player.animation_finished
		queue_free()
