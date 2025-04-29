extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.heal(25)
		body.flash()  # Make player flash when picking up
		queue_free()
