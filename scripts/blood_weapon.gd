extends Area2D

@export var speed = 400
@export var direction = Vector2.RIGHT
@export var damage = 10

func _ready():
    connect("area_entered", Callable(self, "_on_area_entered"))
    $AnimatedSprite2D.play("default")  # Play the blood animation
    get_node("Timer").start()  # Start the timer to auto-destroy

func _physics_process(delta):
    position += direction.normalized() * speed * delta

func _on_Timer_timeout():
    queue_free()

func _on_area_entered(area):
    if area.is_in_group("enemies"):
        area.take_damage(damage)
        queue_free()
