extends CharacterBody2D

# Constants
const WALK_SPEED = 100.0
const JUMP_VELOCITY = -300.0
const DOUBLE_JUMP_VELOCITY = -250.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# State Machine
enum State { IDLE, WALK, JUMP, FALL }
var state = State.IDLE

# Flags
var has_double_jumped: bool = false
var facing_right = true

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	update_state(delta)
	update_animation()
	move_and_slide()

func update_state(delta: float) -> void:
	var input_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

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

func play_animation(name: String) -> void:
	if sprite.animation != name:
		sprite.play(name)
