class_name Bird
extends CharacterBody2D

enum State { IDLE, FLYING, DEAD, FALLING }
var state: State = State.IDLE

@export var gravity: float = 1000
@export var flap_strength: float = -300.0
@export var max_up_angle: float = -30.0
@export var max_down_angle: float = 90.0

var start_position: Vector2

func _ready() -> void:
	EventBus.game_started.connect(_on_game_started)
	EventBus.game_over.connect(_on_game_over)
	
	var screen_size := get_viewport_rect().size
	position = Vector2(screen_size.x/2, screen_size.y/6)

func _physics_process(delta: float) -> void:
	match state:
		State.FLYING:
			velocity.y += gravity * delta
			if Input.is_action_just_pressed("bird_flap"):
				velocity.y = flap_strength
				$AudioFlap.play()
			var t := inverse_lerp(flap_strength, gravity, velocity.y)
			rotation_degrees = lerpf(max_up_angle, max_down_angle, t)
		State.FALLING:
			velocity.y += gravity * delta
			rotation_degrees = max_down_angle
	
	move_and_slide()

func _on_game_started() -> void:
	state = State.FLYING

func _on_game_over() -> void:
	state = State.DEAD
	velocity = Vector2.ZERO
	$AnimatedSprite2D.stop()
	await get_tree().create_timer(0.2).timeout
	state = State.FALLING
	$CollisionShape2D.disabled = true
