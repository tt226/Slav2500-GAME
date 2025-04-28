extends Area2D

@export var speed = 300
var direction = Vector2.ZERO

func _ready():
	$Timer.start()

func _physics_process(delta):
	position += direction * speed * delta

func _on_Timer_timeout():
	queue_free()

func _on_area_entered(area):
	if area.name == "Player":
		area.take_damage(1)
		queue_free()
