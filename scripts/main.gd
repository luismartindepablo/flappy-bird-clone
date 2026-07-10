extends Node

@onready var ground: Area2D = $World/Ground
var _can_restart:bool = false

func _ready() -> void:
	$Audio/AudioStart.play()
	ground.hit.connect(_on_hit)
	get_tree().node_added.connect(_on_node_added)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("bird_flap") and GameState.phase == GameState.Phase.MENU:
		EventBus.game_started.emit()
	if event.is_action_pressed("bird_flap") and GameState.phase == GameState.Phase.DEAD and _can_restart:
		GameState._on_game_reset()
		get_tree().reload_current_scene()

func _on_hit() -> void:
	if GameState.phase == GameState.Phase.PLAYING:
		EventBus.game_over.emit()
		$Audio/AudioGameOver.play()
		
		# Wait IDLE a couple of seconds before restart option
		_can_restart = false
		await get_tree().create_timer(2.0).timeout
		_can_restart = true

func _on_node_added(node: Node) -> void:
	if node is PipesPair:
		node.hit.connect(_on_hit)
