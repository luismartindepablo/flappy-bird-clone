class_name PipesPair
extends Node2D

signal hit

@export var speed: float = -200.0
@export var spawn_offset: float = 50.0
@export var vgap_offset: float = 125.0

var _moving: bool = true

func _ready() -> void:
	var screen_size := get_viewport_rect().size
	position.x = screen_size.x + spawn_offset
	position.y = randf_range(-vgap_offset, vgap_offset) + screen_size.y / 2.0
	
	EventBus.game_started.connect(func(): _moving = true)
	EventBus.game_over.connect(func(): _moving = false)

func _process(delta: float) -> void:
	if _moving:
		position.x += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_pipe_bird_entered(body: Node2D) -> void:
	if body is Bird:
		$AudioHit.play()
		hit.emit()

func _on_goal_line_body_entered(body: Node2D) -> void:
	if body is Bird:
		$AudioScore.play()
		GameState.update_score()
