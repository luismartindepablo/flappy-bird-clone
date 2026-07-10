extends Parallax2D

func _ready() -> void:
	EventBus.game_over.connect(func(): process_mode = Node.PROCESS_MODE_DISABLED)
	EventBus.game_started.connect(func(): process_mode = Node.PROCESS_MODE_INHERIT)
