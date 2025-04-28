extends CharacterBody2D

# Constants
const WALK_SPEED = 100.0
const JUMP_VELOCITY = -500.0
const DOUBLE_JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# State Machine
enum State { IDLE, WALK, JUMP, FALL, ATTACK }
var state = State.IDLE

# Flags
var has_double_jumped: bool = false
var facing_right = true
var attack_blood_thrown: bool = false  # To prevent spawning multiple bloods in one attack

# Nodes
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.play("idle")
	sprite.connect("frame_changed", Callable(self, "_on_sprite_frame_changed"))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	update_state(delta)
	update_animation()
	move_and_slide()
	

func update_state(delta: float) -> void:
	var input_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# If currently attacking, ignore normal state changes
	if state == State.ATTACK:
		return

	# Attack Input
	if Input.is_action_just_pressed("attack") and state in [State.IDLE, State.WALK]:
		start_attack()
		return

	# Horizontal Movement
	if abs(input_x) > 0.1:
		velocity.x = input_x * WALK_SPEED
		facing_right = input_x > 0
		sprite.flip_h = not facing_right
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)

	# State Transitions
	match state:
		State.IDLE:
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_VELOCITY
				state = State.JUMP
			elif abs(input_x) > 0.1:
				state = State.WALK
			elif not is_on_floor():
				state = State.FALL

		State.WALK:
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_VELOCITY
				state = State.JUMP
			elif abs(input_x) < 0.1:
				state = State.IDLE
			elif not is_on_floor():
				state = State.FALL

		State.JUMP:
			if Input.is_action_just_pressed("jump") and not has_double_jumped:
				velocity.y = DOUBLE_JUMP_VELOCITY
				has_double_jumped = true
			elif velocity.y > 0:
				state = State.FALL

		State.FALL:
			if is_on_floor():
				has_double_jumped = false
				if abs(input_x) > 0.1:
					state = State.WALK
				else:
					state = State.IDLE

func update_animation() -> void:
	match state:
		State.IDLE:
			play_animation("idle")
		State.WALK:
			play_animation("walk")
		State.JUMP, State.FALL:
			play_animation("jump")
		State.ATTACK:
			play_animation("attack 1")  # Set your attack animation name here

func play_animation(animation_name: String) -> void:
	if sprite.animation != animation_name:
		sprite.play(animation_name)

func start_attack():
	state = State.ATTACK
	velocity.x = 0
	attack_blood_thrown = false  # Reset so it can throw blood this attack

func _on_sprite_frame_changed():
	if state == State.ATTACK:
		if sprite.animation == "attack 1":
			if sprite.frame == 5 and not attack_blood_thrown:
				throw_blood()
				attack_blood_thrown = true
			elif sprite.frame == 8:
				# Attack animation finished
				if is_on_floor():
					state = State.IDLE
				else:
					state = State.FALL


#@onready var blood_spawn_point = $BloodSpawnPoint

func throw_blood():
	var blood = preload("res://scenes/blood_weapon.tscn").instantiate()
	get_parent().add_child(blood)

	var spawn_pos = global_position
	spawn_pos.y -= 45  # always lift the same amount
	spawn_pos.x += 20 if facing_right else -20  # move right or left

	blood.global_position = spawn_pos
	blood.direction = Vector2.RIGHT if facing_right else Vector2.LEFT

func take_damage(amount: int):
	print(amount)
