extends Area2D

@export var speed = 300
var direction = Vector2.ZERO

func _ready():
	$Timer.start()

func _physics_process(delta):
	position += direction * speed * delta

func _on_Timer_timeout():
	queue_free()	

func _on_body_entered(body: Node2D) -> void:
	print('body entered from spear')
	if body.name == "Player":
		body.take_damage(25)
		queue_free()
	pass # Replace with function body.
