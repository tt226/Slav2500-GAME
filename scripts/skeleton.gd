extends CharacterBody2D

@export var speed = 50
@export var patrol_distance = 100
@export var attack_interval = 2.0
@export var projectile_scene : PackedScene

@onready var sprite = $AnimatedSprite2D
@onready var ray = $RayCast2D

var direction = -1
var patrol_origin = Vector2.ZERO
var attack_timer = 0.0

func _ready():
	patrol_origin = global_position
	sprite.play("walk")
	sprite.connect("frame_changed", _on_frame_changed)
	ray.enabled = true

func _on_frame_changed():
	if sprite.animation == "hit" and sprite.frame == 12:
		fire_projectile()
		attack_timer = attack_interval

func _physics_process(delta):
	attack_timer -= delta

	if ray.is_colliding() and ray.get_collider().name == "Player":
		if attack_timer <= 0:
			sprite.play("hit")
			if direction == -1:
				sprite.flip_h = false  # ← true for LEFT (because sprites usually face right by default)
			else:
				sprite.flip_h = true  # ← false for RIGHT
	else:
		sprite.play("walk")

		velocity.x = speed * direction
		velocity.y = 0  # No gravity fall

		if direction == -1:
			sprite.flip_h = true  # ← true for LEFT (because sprites usually face right by default)
		else:
			sprite.flip_h = false  # ← false for RIGHT

		move_and_slide()

		if abs(global_position.x - patrol_origin.x) > patrol_distance:
			direction *= -1
			ray.scale.x *= -1
			sprite.flip_h = not sprite.flip_h
			patrol_origin = global_position  

func fire_projectile():
	var arrow = projectile_scene.instantiate()
	get_parent().add_child(arrow)
	arrow.global_position = global_position
	if sprite.flip_h:
		arrow.scale.x = -1
	else:
		arrow.scale.x = 1
	arrow.direction = (ray.get_collision_point() - global_position).normalized()

var is_dead = false

func die():
	if not is_dead:
		is_dead = true
		sprite.play("dead")  # Make sure "dead" animation exists
		set_collision_layer(0)
		set_collision_mask(0)
		velocity = Vector2.ZERO

func take_damage(_amount):
	die()
