extends Node

@export var pipes_pair_scene: PackedScene
@export var pipes_pair_parent: Node

@onready var timer: Timer = $TimerPipeSpawn

func _ready() -> void:
	timer.timeout.connect(_on_timer_pipe_spawn_timeout)
	EventBus.game_started.connect(_on_game_started)
	EventBus.game_over.connect(_on_game_over)
	
func _on_game_started() -> void:
	timer.start()

func _on_game_over() -> void:
	timer.stop()

func _on_timer_pipe_spawn_timeout() -> void:
	var pipes_pair := pipes_pair_scene.instantiate()
	pipes_pair_parent.add_child(pipes_pair)
