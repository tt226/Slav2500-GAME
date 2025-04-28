extends Area2D

@export var speed = 400
@export var direction = Vector2.RIGHT
@export var damage = 10

@onready var timer = $Timer

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	$AnimatedSprite2D.play("default")  # Play the blood animation
	timer.start()  # Start the timer to auto-destroy

func _physics_process(delta):
	position += direction.normalized() * speed * delta

func _on_body_entered(body):
	print('body entered')
	if body.is_in_group("enemies"):
		print('enemy')
		body.take_damage(damage)
		queue_free()


func _on_timer_timeout() -> void:
#	delete weapon after given time
	queue_free()
