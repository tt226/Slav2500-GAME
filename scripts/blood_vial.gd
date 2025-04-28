extends Area2D

const VIAL_STRENGTH = 15

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.increase_health(VIAL_STRENGTH)
		queue_free()
